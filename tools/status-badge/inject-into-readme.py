#!/usr/bin/env python3
import re, sys, os

readme = 'README.md'
snippet = '<!-- Policy Status Badge -->\n<img alt="Policy Status" src="http://localhost:8091/badge.svg">\n'

if not os.path.exists(readme):
    print('README.md not found', file=sys.stderr); sys.exit(1)

txt = open(readme, 'r', encoding='utf-8', errors='ignore').read()
if 'Policy Status Badge' in txt:
    print('Badge snippet already present; no change.'); sys.exit(0)

# Insert after top image or heading if found, else prepend
m = re.search(r'<img[^>]+>', txt)
if m:
    pos = m.end()
    out = txt[:pos] + "\n\n" + snippet + txt[pos:]
else:
    h = re.search(r'(^# .+?$)', txt, flags=re.M)
    if h:
        pos = h.end()
        out = txt[:pos] + "\n\n" + snippet + txt[pos:]
    else:
        out = snippet + "\n" + txt

open(readme, 'w', encoding='utf-8').write(out)
print('Injected badge snippet into README.md')
