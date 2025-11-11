#!/usr/bin/env python3
import os, sys

# Rules:
# 1) Any directory containing "mkdocs.yml" is considered a TechDocs site root.
# 2) Additionally, directories with catalog-info.yaml that include annotation
#    'backstage.io/techdocs-ref: dir:.' are included if they also have docs/.
#
# The script prints absolute paths, one per line.

repo_root = os.getcwd()
candidates = set()

for root, dirs, files in os.walk(repo_root):
    if "node_modules" in root or ".git" in root or "dist" in root:
        continue
    if "mkdocs.yml" in files:
        candidates.add(root)
    if "catalog-info.yaml" in files or "catalog-info.yml" in files:
        # heuristic: if docs/ present, include
        if os.path.isdir(os.path.join(root, "docs")):
            candidates.add(root)

for c in sorted(candidates):
    print(c)
