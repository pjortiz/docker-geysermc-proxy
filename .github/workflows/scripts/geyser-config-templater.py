from doctest import SKIP
from re import S
import sys
import json

from ruamel.yaml import YAML

ORIGINAL_GEYSER_CONFIG_PATH: str = ".temp/geyser_config.yml"
TEMPLATED_GEYSER_CONFIG_PATH: str = "templates/geyser_config.template.yml"
ENV_MAP_PATH: str = ".temp/env_map.json"

# keys to skip from templating
SKIP_KEYS = [
    "bedrock.port",
    "bedrock.clone-remote-port",
    "config-version",
    "floodgate-key-file"
]

OVERRIDE_DEFAULTS: dict = {
    "remote.forward-hostname": True,
    "metrics.enabled": False,
    "floodgate-key-file": "/Geyser/floodgate/key.pem",
    "saved-user-logins": "",
    "bedrock.proxy-protocol-whitelisted-ips": ""
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

def save_key(key: list[str], placeholder: str, value=None):
    KEYS[placeholder] = {get_key_path(key): value}
    
def convert_key_to_placeholder(key: list[str]):
    return "_".join(key).upper().replace("-", "_")

def construct_placeholder_list(key: list[str], value, fString: str = "$(echo \"[{0}]\" | sed -r 's/\\s?,\\s?|\\s?,?\\s?\\n\\s?/, /g')"):
    return fString.format(construct_placeholder_string(key, value))
    
def construct_placeholder_string(key: list[str], value, fString: str = "${{{0}}}"):
    placeholder = convert_key_to_placeholder(key)
    key_path = get_key_path(key)
    default = OVERRIDE_DEFAULTS.get(key_path) if key_path in OVERRIDE_DEFAULTS.keys() else ", ".join(value) if isinstance(value, list) else value
    save_key(key, placeholder, default)
    return fString.format(placeholder)

def convert_value_to_string(value):
    temp_value = value
    if value is None:
        temp_value = "null"
    if isinstance(value, bool):
        temp_value = str(value).lower()
    return temp_value

def convert_value_to_templated(value, key: list[str] = []):
    if isinstance(value, dict):
        for k, v in value.items():
            value[k] = convert_value_to_templated(v, key + [k])
        return value
    key_path = get_key_path(key)
    if key_path in SKIP_KEYS: # skip the key, don't template it
        # override the default value if configured else return the value
        return OVERRIDE_DEFAULTS[key_path] if key_path in OVERRIDE_DEFAULTS.keys() else value
    if isinstance(value, list):
        return construct_placeholder_list(key, value)
    return construct_placeholder_string(key, value)

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


