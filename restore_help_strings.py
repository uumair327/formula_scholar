import json
import collections
import codecs

updates = {
  "helpAndSupport": "Help & Support",
  "faq1Question": "How do I change my grade?",
  "faq1Answer": "Go to Profile → Account Information to update your grade. Your curriculum will automatically adjust to match.",
  "faq2Question": "Can I use the app offline?",
  "faq2Answer": "Yes! Previously viewed formulas and chapters are cached for offline access. Bookmarks are always available offline.",
  "faq3Question": "How are streaks calculated?",
  "faq3Answer": "Your streak counts consecutive days with at least 5 minutes of study time. The counter resets at midnight local time.",
  "faq4Question": "What is Formula Scholar Pro?",
  "faq4Answer": "Pro unlocks advanced features like 3D visualizers, unlimited practice quizzes, and priority access to new content.",
  "resources": "Resources",
  "userGuide": "User Guide",
  "userGuideDesc": "Learn how to use Formula Scholar",
  "videoTutorials": "Video Tutorials",
  "videoTutorialsDesc": "Watch step-by-step guides",
  "privacyPolicy": "Privacy Policy",
  "privacyPolicyDesc": "How we protect your data",
  "termsOfServiceDesc": "Rules and guidelines for app usage"
}

filepath = 'lib/l10n/app_en.arb'

with codecs.open(filepath, 'r', encoding='utf-8') as f:
    data = json.load(f, object_pairs_hook=collections.OrderedDict)

for k, v in updates.items():
    if k in data:
        data[k] = v
    else:
        # Add missing ones just in case
        data[k] = v

with codecs.open(filepath, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
