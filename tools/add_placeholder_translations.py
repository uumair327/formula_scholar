import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
l10n_dir = ROOT / 'lib' / 'l10n'
en_file = l10n_dir / 'app_en.arb'
locales = ['ar', 'mr', 'ur']

def load(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding='utf-8'))

def save(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=False), encoding='utf-8')

def main():
    en = load(en_file)
    keys = [k for k in en.keys() if not k.startswith('@')]
    print(f'English keys: {len(keys)}')
    for loc in locales:
        path = l10n_dir / f'app_{loc}.arb'
        loc_data = load(path)
        added = 0
        for k in keys:
            if k not in loc_data:
                loc_data[k] = en[k]
                meta = f'@{k}'
                if meta in en:
                    loc_data[meta] = en[meta]
                added += 1
        save(path, loc_data)
        print(f'Locale {loc}: added {added} missing keys to {path.name}')

if __name__ == '__main__':
    main()
