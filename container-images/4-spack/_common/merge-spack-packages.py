import yaml
import sys

if len(sys.argv) != 3:
  print("Usage: {} <packages-1.yaml> <packages-2.yaml>".format(sys.argv[0]))
  sys.exit(1)

pkgs_f1 = sys.argv[1]
pkgs_f2 = sys.argv[2]

with open(pkgs_f1, 'r') as f1, open(pkgs_f2, 'r') as f2:
    pkgs1 = yaml.safe_load(f1)["packages"]
    pkgs2 = yaml.safe_load(f2)["packages"]

pkgs = pkgs1.copy()
pkgs.update(pkgs2)

# pkgs = pkgs1 | pkgs2 # requires >py3.8

print(yaml.dump({"packages": pkgs}))

