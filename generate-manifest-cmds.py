#!/usr/bin/env python3

import json
import os
import subprocess
import sys


def _err(*args, **kwargs):
    kwargs['file'] = sys.stderr
    print(*args, **kwargs)


manifests = None
with open('manifests.json', 'r') as fs:
    manifests = json.load(fs)

tag_suffix_missing = False
missing = []
for kk, vv in manifests.items():
    refs = vv.get("refs", [])
    missing.extend([r for r in refs if r not in os.environ])

    images = vv.get("images", [])
    for img in images:
        refs = img.get("refs", [])
        missing.extend([r for r in refs if r not in os.environ])
        if "tag_suffix" not in img:
            tag_suffix_missing = True

errors = []
if len(missing) > 0:
    missing.sort()
    errors.append("ERROR: Required environment variables are missing:\n{}\n".format("\n".join(f"  {v}" for v in missing)))

if 'E4S_VERSION' not in os.environ:
    errors.append("ERROR: Required environment variable is missing: E4S_VERSION\n")

if 'REGISTRY' not in os.environ:
    errors.append("ERROR: Required enviroment variable is missing: REGISTRY\n")

if tag_suffix_missing is True:
    errors.append("ERROR: Some images are missing required field: tag_suffix\n")

if len(errors) > 0:
    _err("\n".join(errors))
    sys.exit(1)

reg = os.environ['REGISTRY']
e4s_ver = os.environ['E4S_VERSION']

cmds = []

for kk, vv in manifests.items():
    refs = vv.get("refs", [])

    if "refs" in vv:
        refs = vv["refs"]
        for tag in [e4s_ver, "latest"]:
            img = "{}/{}:{}".format(reg, kk, tag)
            cmd = ['docker', 'buildx', 'imagetools', 'create', '-t', img]
            cmd.extend([os.environ[r] for r in refs])
            cmds.append(cmd)
    
    if "images" in vv:
        for img in vv["images"]:
            suffix = img["tag_suffix"]
            refs = img["refs"]
            img = "{}/{}:{}-{}".format(reg, kk, e4s_ver, suffix)
            cmd = ['docker', 'buildx', 'imagetools', 'create', '-t', img]
            cmd.extend([os.environ[r] for r in refs])
            cmds.append(cmd)

cmdfile="cmds.sh"
with open(cmdfile, "w") as fs:
    fs.write("#!/bin/bash -e\n\n")
    for cmd in cmds:
        fs.write("{}\n\n".format(" ".join(cmd)))

print("Successfully generated command file to push manifests: {}".format(cmdfile))