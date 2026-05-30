import json
import collections
import codecs

updates = {
  "legalEffectiveDate": "Effective: April 2026",
  "legalInfoWeCollect": "Information We Collect",
  "legalInfoWeCollectContent": "We collect information you provide directly, such as your name, email address, and academic preferences (board, grade, subjects) when you create an account. We also collect usage data including formulas viewed, quiz scores, and study progress to personalize your experience.",
  "legalHowWeUse": "How We Use Your Information",
  "legalHowWeUseContent": "Your information is used to: personalize your learning dashboard, track your study progress and mastery levels, recommend relevant formulas and chapters, send study reminders (with your consent), and improve our educational content and features.",
  "legalDataStorage": "Data Storage & Security",
  "legalDataStorageContent": "Your data is stored securely on Google Firebase servers with encryption at rest and in transit. We use industry-standard security measures to protect your personal information. You can request data export or deletion at any time through the app settings.",
  "legalThirdParty": "Third-Party Services",
  "legalThirdPartyContent": "We use the following third-party services: Firebase (authentication and data storage by Google), Google Sign-In (optional account linking). These services have their own privacy policies which we encourage you to review.",
  "legalYourRights": "Your Rights",
  "legalYourRightsContent": "You have the right to: access your personal data, correct inaccurate data, request deletion of your account and data, export your data in a portable format, and opt out of non-essential communications. To exercise these rights, contact us through the Help & Support section.",
  "legalChildrenPrivacy": "Children's Privacy",
  "legalChildrenPrivacyContent": "Formula Scholar is designed for students of all ages. For users under 13, we collect only the minimum information necessary for the service. We do not knowingly collect sensitive personal information from children. Parents may contact us to review or delete their child's data.",
  "legalChanges": "Changes to This Policy",
  "legalChangesContent": "We may update this Privacy Policy from time to time. We will notify you of any material changes through the app and update the effective date. Your continued use of Formula Scholar after changes indicates acceptance of the updated policy.",
  "legalContact": "Contact Us",
  "legalContactContent": "If you have questions about this Privacy Policy or your data, please contact us through the Help & Support section in the app, or email us at support@formulascholar.app.",
  "legalAcceptance": "Acceptance of Terms",
  "legalAcceptanceContent": "By creating an account or using Formula Scholar, you agree to these Terms of Service. If you do not agree, please do not use the service. We may update these terms and will notify you of significant changes.",
  "legalUseOfService": "Use of Service",
  "legalUseOfServiceContent": "Formula Scholar provides educational tools for learning mathematical and scientific formulas. The service is provided \"as is\" for personal, non-commercial educational use. You agree not to: share your account credentials, use the service for unauthorized purposes, or attempt to reverse-engineer any part of the application.",
  "legalUserAccounts": "User Accounts",
  "legalUserAccountsContent": "You are responsible for maintaining the security of your account and password. You must provide accurate information during registration. You may delete your account at any time, which will permanently remove your data from our systems.",
  "legalIntellectualProperty": "Intellectual Property",
  "legalIntellectualPropertyContent": "All content, design, and code within Formula Scholar are protected by intellectual property laws. Educational formulas themselves are in the public domain, but our presentation, explanations, and quiz content are proprietary. You may not reproduce or distribute our content without permission.",
  "legalTermination": "Termination",
  "legalTerminationContent": "We may suspend or terminate your access if you violate these terms. You may terminate your account at any time. Upon termination, your right to use the service ceases and your data will be deleted per our retention policy.",
  "legalDisclaimer": "Disclaimer",
  "legalDisclaimerContent": "Formula Scholar is an educational aid and should supplement, not replace, formal education. We strive for accuracy but do not guarantee that all content is error-free. We are not liable for academic outcomes based on use of this application.",
  "legalGoverningLaw": "Governing Law",
  "legalGoverningLawContent": "These Terms of Service are governed by applicable law. Any disputes arising from these terms will be resolved through appropriate legal channels in the jurisdiction where the service provider is located.",
  "legalFooterTitle": "Your Privacy & Security Matter to Us",
  "legalFooterDesc": "We are committed to protecting your personal information and providing a safe learning environment."
}

filepath = 'lib/l10n/app_en.arb'

with codecs.open(filepath, 'r', encoding='utf-8') as f:
    data = json.load(f, object_pairs_hook=collections.OrderedDict)

for k, v in updates.items():
    data[k] = v

with codecs.open(filepath, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
