import re,glob,sys
s=set()
for f in glob.glob('lib/**/*.dart',recursive=True):
    try:
        with open(f,encoding='utf8') as fh:
            txt=fh.read()
            for m in re.findall(r'context\.l10n\.([A-Za-z0-9_]+)',txt):
                s.add(m)
            for m in re.findall(r'\bl10n\.([A-Za-z0-9_]+)',txt):
                s.add(m)
    except Exception as e:
        pass
out='\n'.join(sorted(s))
with open('build_l10n_keys.txt','w',encoding='utf8') as o:
    o.write(out)
print('Wrote build_l10n_keys.txt with %d keys' % len(s))
