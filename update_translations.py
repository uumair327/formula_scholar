import json
import codecs
import os

arb_dir = r"c:\Users\uumai\Downloads\zip\formula_scholar\lib\l10n"

# The specific translations we want to inject/fix for the screenshot elements
translations = {
    "keepGoing": {
        "en": "Keep Going",
        "ar": "واصل التقدم",
        "ur": "جاری رکھیں",
        "mr": "पुढे चला"
    },
    "startNow": {
        "en": "Start Now",
        "ar": "ابدأ الآن",
        "ur": "ابھی شروع کریں",
        "mr": "आता सुरू करा"
    },
    "continueLearning": {
        "en": "Continue Learning",
        "ar": "متابعة التعلم",
        "ur": "سیکھنا جاری رکھیں",
        "mr": "शिकणे सुरू ठेवा"
    },
    "formulasLabel": {
        "en": "formulas",
        "ar": "صيغ",
        "ur": "فارمولے",
        "mr": "सूत्रे"
    },
    "doneLabel": {
        "en": "{percent}% done",
        "ar": "تم إنجاز {percent}%",
        "ur": "{percent}% مکمل",
        "mr": "{percent}% पूर्ण"
    },
    "formulasCountLabel": {
        "en": "{completed}/{total} formulas",
        "ar": "{completed}/{total} صيغ",
        "ur": "{completed}/{total} فارمولے",
        "mr": "{completed}/{total} सूत्रे"
    },
    "sortNameAZ": {
        "en": "Name A-Z",
        "ar": "الاسم أ-ي",
        "ur": "نام A-Z",
        "mr": "नाव A-Z"
    },
    "sortNameZA": {
        "en": "Name Z-A",
        "ar": "الاسم ي-أ",
        "ur": "نام Z-A",
        "mr": "नाव Z-A"
    },
    "sortProgressHigh": {
        "en": "Progress High",
        "ar": "التقدم عالٍ",
        "ur": "زیادہ پیش رفت",
        "mr": "प्रगती जास्त"
    },
    "sortProgressLow": {
        "en": "Progress Low",
        "ar": "التقدم منخفض",
        "ur": "کم پیش رفت",
        "mr": "प्रगती कमी"
    },
    "sortMostFormulas": {
        "en": "Most Formulas",
        "ar": "الأكثر صيغاً",
        "ur": "سب سے زیادہ فارمولے",
        "mr": "सर्वाधिक सूत्रे"
    },
    "sortFewestFormulas": {
        "en": "Fewest Formulas",
        "ar": "الأقل صيغاً",
        "ur": "سب سے کم فارمولے",
        "mr": "सर्वात कमी सूत्रे"
    }
}

metadata = {
    "@doneLabel": {
        "placeholders": {
            "percent": {
                "type": "int",
                "example": "50"
            }
        }
    },
    "@formulasCountLabel": {
        "placeholders": {
            "completed": {
                "type": "int",
                "example": "1"
            },
            "total": {
                "type": "int",
                "example": "3"
            }
        }
    }
}

for lang in ["en", "ar", "ur", "mr"]:
    filepath = os.path.join(arb_dir, f"app_{lang}.arb")
    with codecs.open(filepath, 'r', 'utf-8') as f:
        data = json.load(f)
    
    for key, trans_dict in translations.items():
        data[key] = trans_dict[lang]
        if key in metadata and lang == "en":
            data[f"@{key}"] = metadata[f"@{key}"]
            
    with codecs.open(filepath, 'w', 'utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("Updated arb files.")
