#!/bin/bash -e

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <path-to-packages.yaml>"
  exit 1
fi

if ! command -v spack >/dev/null 2>&1; then
  echo "spack not found; this script requires spack to be in PATH"
  exit 1
fi

script=/tmp/get-external-list.py
cat <<'EOF' >$script
import yaml
import sys

def print_external_specs(file_path):
    try:
        with open(file_path, 'r') as f:
            # Load the YAML content into a Python dictionary
            config = yaml.safe_load(f)

        # Access the 'packages' section
        packages = config.get('packages', {})

        for pkg_name, pkg_info in packages.items():
            # Check if this package has an 'externals' list
            externals = pkg_info.get('externals', [])
            for entry in externals:
                # Get the spec associated with this external entry
                spec = entry.get('spec')
                if spec:
                    print(f"{spec}")

    except FileNotFoundError:
        print(f"Error: {file_path} not found.")
    except yaml.YAMLError as exc:
        print(f"Error parsing YAML: {exc}")

if __name__ == "__main__":
    # Path to your packages.yaml (defaulting to current dir)
    path = "packages.yaml" if len(sys.argv) < 2 else sys.argv[1]
    print_external_specs(path)
EOF

externals=$(mktemp)
python $script $1 > $externals

while IFS= read -r line; do
  spack install "$line"
done < $externals

