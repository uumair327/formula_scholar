import json
import re

def camel_to_title(text):
    # Insert space before capital letters and capitalize the first letter
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1 \2', text)
    title = re.sub('([a-z0-9])([A-Z])', r'\1 \2', s1).title()
    return title

for lang in ['en', 'ar', 'mr', 'ur']:
    filepath = f'lib/l10n/app_{lang}.arb'
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        updated = 0
        for key, value in data.items():
            if isinstance(value, str) and value.lower().replace(" ", "") == key.lower():
                # The value is just the key capitalized (e.g. "Privacypolicytitle" for "privacyPolicyTitle")
                # Let's fix it by converting the key to Title Case
                proper_text = camel_to_title(key)
                data[key] = proper_text
                updated += 1
                
        if updated > 0:
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"Fixed {updated} keys in {filepath}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
