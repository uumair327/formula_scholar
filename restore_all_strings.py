import json
import collections
import codecs
import re

filepath = 'lib/l10n/app_en.arb'
strings_file = 'scratch_strings_utf8.dart'

with codecs.open(strings_file, 'r', encoding='utf-8') as f:
    dart_content = f.read()

# Match simple string constants
# static const String key = 'value'; or "value"
pattern = r"static\s+const\s+String\s+(\w+)\s*=\s*(?:'([^']*)'|\"([^\"]*)\");"
matches = re.findall(pattern, dart_content)

updates = {}
for m in matches:
    key = m[0]
    val = m[1] if m[1] else m[2]
    # Replace escaped quotes if necessary
    val = val.replace("\\'", "'").replace('\\"', '"')
    updates[key] = val

with codecs.open(filepath, 'r', encoding='utf-8') as f:
    data = json.load(f, object_pairs_hook=collections.OrderedDict)

updated_count = 0
for k, v in updates.items():
    if k in data:
        # Don't overwrite if it's already properly set and not Title Cased (just a heuristic, or just overwrite all simple ones)
        # Actually, let's just overwrite them all, since the dart file is the source of truth!
        data[k] = v
        updated_count += 1

print(f"Updated {updated_count} simple string constants.")

with codecs.open(filepath, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
