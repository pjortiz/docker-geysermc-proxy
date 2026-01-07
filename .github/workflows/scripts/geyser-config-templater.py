from doctest import SKIP
from re import S
import sys
import json

from ruamel.yaml import YAML, CommentToken
from ruamel.yaml.scalarstring import PlainScalarString

ORIGINAL_GEYSER_CONFIG_PATH: str = ".temp/geyser_config.yml"
TEMPLATED_GEYSER_CONFIG_PATH: str = "templates/geyser_config.template.yml"
ENV_MAP_PATH: str = "env_map.json"

# keys to skip from templating
SKIP_KEYS = [
    "config-version",
    "advanced.floodgate-key-file"
]

OVERRIDE_DEFAULTS: dict = {
    "java.forward-hostname": True,
    "enable-metrics": False,
    "advanced.floodgate-key-file": "/Geyser/floodgate/key.pem",
    "saved-user-logins": ""
}

KEYS: dict = {} # store the keys
    
yaml = YAML() # initialize the yaml object
yaml.width = sys.maxsize # set the width to the maximum size
yaml.default_flow_style = True  # Ensure arrays are output with [ and ]

# convert the config to templed config
# foo: bar -> foo: ${FOO:-bar}
# foo:
#  bar: baz -> foo: ${FOO_BAR:-baz}
# foo: [bar, baz] -> foo: $(echo "[${FOO:-bar, baz}]") 

def get_key_path(key: list[str]):
    return ".".join(key)

def save_key(key: list[str], placeholder: str, value=None, comment=""):
    KEYS[placeholder] = {get_key_path(key): value, "comment": comment or ""}
    
def convert_key_to_placeholder(key: list[str]):
    return "_".join(key).upper().replace("-", "_")

# def replace_preserving_ca(old_value, new_value):
#     if hasattr(old_value, "ca") and hasattr(new_value, "ca"):
#         new_value.ca = old_value.ca
#     return new_value

def construct_placeholder_list(key: list[str], value, comment: str = None, fString: str = "$(echo \"[{0}]\" | sed -r 's/\\s?,\\s?|\\s?,?\\s?\\n\\s?/, /g')"):
    return fString.format(construct_placeholder_string(key, value, comment))
    # return replace_preserving_ca(value, LiteralScalarString(fString.format(construct_placeholder_string(key, value, comment))))

def construct_placeholder_string(key: list[str], value, comment: str = "", fString: str = "${{{0}}}"):
    placeholder = convert_key_to_placeholder(key)
    key_path = get_key_path(key)
    default = OVERRIDE_DEFAULTS.get(key_path) if key_path in OVERRIDE_DEFAULTS.keys() else ", ".join(value) if isinstance(value, list) else value
    save_key(key, placeholder, default, comment)
    return fString.format(placeholder)

def convert_value_to_string(value):
    temp_value = value
    if value is None:
        temp_value = "null"
    if isinstance(value, bool):
        temp_value = str(value).lower()
    return temp_value

def normalize_comment_lines(tokens):
    if not tokens:
        return []

    # ruamel may return a single CommentToken
    if isinstance(tokens, CommentToken):
        tokens = [tokens]

    # or a tuple
    if not isinstance(tokens, (list, tuple)):
        return []

    lines = []
    for token in tokens:
        if token and hasattr(token, "value") and token.value:
            temp_lines = token.value.split("\n")
            temp_lines = [line.strip() for line in temp_lines]
            lines.extend([line.removeprefix("# ") for line in temp_lines if line.strip()])

    return lines

def get_previous_sibling_key(parrents, key):
    mapping = parrents[-1]
    current_key = key[-1]
    sibling_keys = list(mapping.keys())
    idx = sibling_keys.index(current_key)
    if idx == 0:
        return None
    prev_key = sibling_keys[idx - 1]
    return prev_key

def was_prev_silbling_dict(parrents, key):
    mapping = parrents[-1]
    prev_key = get_previous_sibling_key(parrents, key)
    
    if not prev_key:
        return False
    
    prev_value = mapping.get(prev_key)
    return isinstance(prev_value, dict)

def get_last_child_key(mapping):
    if not mapping:
        return None
    keys = list(mapping.keys())
    if not keys:
        return None
    return keys[-1]
    

def get_comment_of_last_nested_child(parrents, key, comment_index: int = 2) -> str | None:
    """
    Recursively get the comment of the last nested child key. if the last child is a dict, go deeper until a non-dict key is found.
    """
    mapping = parrents[-1]
    current_key = key[-1]
    current_value = mapping.get(current_key)
    
    if not isinstance(current_value, dict):
        return get_key_comment(parrents, key, comment_index, ignore_siblings=True)
    
    last_key = get_last_child_key(current_value)
    if not last_key:
        return None
    
    return get_comment_of_last_nested_child(parrents + [current_value], key + [last_key], comment_index)
    

def get_key_comment(parrents, key, comment_index: int = 1, ignore_siblings: bool = False) -> str | None:
    """
    Extract comment immediately above a key, if present.
    """
    
    mapping = parrents[-1]
    current_key = key[-1]
    
    if not hasattr(mapping, "ca"):
        return None
    
    
    item = []
    sibling_keys = list(mapping.keys())
    idx = sibling_keys.index(current_key)
    
    # Fixes: off-by-one error when reading comments, gets comment of previous key instead of current key
    # Check parent mapping for comment if at first key of current mapping
    # since no previous sibling key exists
    if idx == 0 and len(parrents) > 1 and not isinstance(mapping.get(current_key), dict):
        return get_key_comment(parrents[:-1], key[:-1], 3)  # check parent mapping for comment
    elif isinstance(mapping.get(current_key), dict) or ignore_siblings: 
        item = mapping.ca.items.get(current_key)
    elif was_prev_silbling_dict(parrents, key):
        # if the previous sibling was a dict, get the comment of its last child key recursively
        prev_sibling_key = get_previous_sibling_key(parrents, key)
        return get_comment_of_last_nested_child(parrents, key[:-1] + [prev_sibling_key], 2)
    else:
        prev_key = sibling_keys[idx - 1]
        item = mapping.ca.items.get(prev_key)

    if not item and prev_siblings_value_prefix_matches(parrents, key, "$(echo"):
            # handle case when previous sibling is a templated list
            item = mapping.ca.items.get(current_key)
            
    if not item:
        return None
        
    lines:list[str] = normalize_comment_lines(item[comment_index])

    return " ".join(lines) if lines else None

def extract_seq_comments(seq):
    comments = []

    if not hasattr(seq, "ca"):
        return comments

    # element comments
    for item in seq.ca.items.values():
        if item and item[0]:  # inline comment on element
            comments.extend(normalize_comment_lines(item[0]))

    return comments

def replace_seq_with_scalar(parent, key, seq, scalar_value):
    comments = extract_seq_comments(seq)

    parent[key] = PlainScalarString(scalar_value)

    if comments:
        parent.yaml_set_comment_before_after_key(
            key,
            before="\n".join(dict.fromkeys(comments))
        )
        
def prev_siblings_value_prefix_matches(parrents, key, prefix: str) -> bool:
    mapping = parrents[-1]
    prev_key = get_previous_sibling_key(parrents, key)
    
    if not prev_key:
        return False
    
    prev_value = mapping.get(prev_key)
    if isinstance(prev_value, str):
        return prev_value.strip().startswith(prefix)
    
    return False

def convert_value_to_templated(value, key: list[str] = [], parents:list[dict] = []): 
    if isinstance(value, dict):
        for k, v in value.items():
            value[k] = convert_value_to_templated(v, key + [k], parents + [value])
        return value
    key_path = get_key_path(key)
    
    comment = None
    if value is not None:
        comment = get_key_comment(parents, key, 1 if prev_siblings_value_prefix_matches(parents, key, "$(echo") else 2)
        
    if key_path in SKIP_KEYS: # skip the key, don't template it
        # override the default value if configured else return the value
        return OVERRIDE_DEFAULTS[key_path] if key_path in OVERRIDE_DEFAULTS.keys() else value
    if isinstance(value, list):
        backup_comments = extract_seq_comments(value)
        result = construct_placeholder_list(key, value, comment)
        # preserve the comment tokens
        if backup_comments:
            replace_seq_with_scalar(parents[-1], key[-1], value, result)
        return result
    return construct_placeholder_string(key, value, comment)

# check if the file exists
try:
    with open(ORIGINAL_GEYSER_CONFIG_PATH, "r") as file:
        config = yaml.load(file)
except FileNotFoundError:
    print(f"File not found: {ORIGINAL_GEYSER_CONFIG_PATH}")
    exit(1)
except PermissionError:
    print(f"Permission denied: {ORIGINAL_GEYSER_CONFIG_PATH}")
    exit(1)
    
# convert the config to templed config
config = convert_value_to_templated(config)

try:
    with open(TEMPLATED_GEYSER_CONFIG_PATH, "w") as file:
        yaml.dump(config, file)
except FileNotFoundError:
    print(f"File not found: {TEMPLATED_GEYSER_CONFIG_PATH}")
    exit(1)
except PermissionError:
    print(f"Permission denied: {TEMPLATED_GEYSER_CONFIG_PATH}")
    exit(1)

print(f"Config templated: {TEMPLATED_GEYSER_CONFIG_PATH}")

try:
    with open(ENV_MAP_PATH, "w") as file:
        json.dump(KEYS, file, indent=4)
except FileNotFoundError:
    print(f"File not found: {ENV_MAP_PATH}")
    exit(1)
except PermissionError:
    print(f"Permission denied: {ENV_MAP_PATH}")
    exit(1)


