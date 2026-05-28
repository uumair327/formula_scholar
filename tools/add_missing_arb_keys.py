import json,sys,re
from pathlib import Path
root=Path('.')
arb_path=root/'lib'/'l10n'/'app_en.arb'
keys_path=root/'build_l10n_keys.txt'
if not arb_path.exists() or not keys_path.exists():
    print('Missing files')
    sys.exit(1)
with open(arb_path,'r',encoding='utf8') as f:
    txt=f.read()
# load as JSON
data=json.loads(txt)
with open(keys_path,'r',encoding='utf8') as f:
    keys=[k.strip() for k in f.readlines() if k.strip()]
added=0
for k in keys:
    if k not in data:
        # create a friendly value
        v=re.sub(r'_', ' ', k).capitalize()
        data[k]=v
        added+=1
if added>0:
    # write back
    with open(arb_path,'w',encoding='utf8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print('Added',added,'keys to',arb_path)
else:
    print('No missing keys')
