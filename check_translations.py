import json
import codecs

with codecs.open(r'c:\Users\uumai\Downloads\zip\formula_scholar\lib\l10n\app_en.arb', 'r', 'utf-8') as f:
    en_data = json.load(f)

for lang in ['ar', 'ur', 'mr']:
    try:
        with codecs.open(fr'c:\Users\uumai\Downloads\zip\formula_scholar\lib\l10n\app_{lang}.arb', 'r', 'utf-8') as f:
            lang_data = json.load(f)
        
        untranslated = []
        for key, value in en_data.items():
            if not key.startswith('@'):
                if key in lang_data and lang_data[key] == value:
                    untranslated.append(key)
                elif key not in lang_data:
                    untranslated.append(key)
        
        print(f"Untranslated keys in {lang}: {len(untranslated)}")
    except Exception as e:
        print(f"Error loading {lang}: {e}")
