import json

updates = {
  "step1Tag": "Location Preference",
  "step1Title": "Where are you studying?",
  "step1Subtitle": "We'll tailor your formulas and curriculum based on your region's educational standards.",
  "step1CountryLabel": "Select Country",
  "step1StateLabel": "Select State or Region",
  "step1StateHint": "Search state (e.g. Maharashtra)",
  "step1LocalizedTitle": "Localized Content",
  "step1LocalizedDesc": "We automatically sync with CBSE, ICSE, and various State Board syllabi based on your choice.",
  "step1PrivacyTitle": "Privacy Guaranteed",
  "step1PrivacyDesc": "Your location is only used to personalize your curriculum roadmap.",
  "step1Continue": "Continue to Step 2",
  "step2Tag": "Curriculum Selection",
  "step2Title": "Select Your Curriculum",
  "step2NotSureTitle": "Not sure about your board?",
  "step2NotSureDesc": "Check your school ID card or textbook covers for the official board affiliation.",
  "step2LearnMore": "Learn more",
  "step3Tag": "Grade Selection",
  "step3Title": "Select Your Class",
  "step3Subtitle": "Choose your academic year to tailor formulas and practice sets to your curriculum.",
  "step4Tag": "Commitment",
  "step4Title": "Set your weekly goal",
  "step4Subtitle": "Consistency is the key to mastery. How much time can you dedicate?",
  "step4Casual": "Casual Learner",
  "step4CasualDesc": "15 mins / day",
  "step4Regular": "Regular Scholar",
  "step4RegularDesc": "30 mins / day",
  "step4Intensive": "Intensive Mastery",
  "step4IntensiveDesc": "60+ mins / day",
  "step4EnterSanctuary": "Enter Sanctuary",
  "onboardingNeedHelp": "Need Help?",
  "onboardingBoardSubtitle": "Personalize your journey by selecting your academic board. We'll tailor your formulas and practice sets to your specific curriculum.",
  "onboardingSelectBoard": "Select Board",
  "onboardingBoardChangeHint": "Selected board can be changed later in Profile.",
  "onboardingBoardSelected": "BOARD SELECTED",
  "onboardingJourneyProgress": "Journey Progress",
  "onboardingGradeSubtitle": "We'll customize your FormulaFlow experience based on your current curriculum.",
  "onboardingMostPopular": "MOST POPULAR",
  "onboardingGradeChangeHint": "You can always change your grade in Profile settings later.",
  "onboardingBack": "Back",
  "onboardingContinue": "Continue",
  "onboardingAppBrand": "Formula Sanctuary",
  "privacyPolicyDesc": "How we handle your data",
  "privacyPolicyTitle": "Privacy Policy",
  "termsOfServiceDesc": "Rules for using this app",
  "termsOfServiceTitle": "Terms of Service",
  "loginTitle": "Welcome Back",
  "loginSubtitle": "Enter your credentials to access your sanctuary.",
  "loginEmailLabel": "Email or Username",
  "loginEmailHint": "scholar@formulaflow.com",
  "loginPasswordLabel": "Password",
  "loginPasswordHint": "••••••••••••",
  "loginForgotPassword": "Forgot Password?",
  "forgotPasswordTitle": "Reset Password",
  "forgotPasswordDesc": "Enter your email address and we'll send you a link to reset your password.",
  "forgotPasswordSend": "Send Reset Link",
  "forgotPasswordSuccess": "Password reset link sent! Check your email inbox.",
  "forgotPasswordCancel": "Cancel",
  "loginSignIn": "Sign In",
  "loginOr": "OR",
  "loginGoogle": "Google",
  "loginSchoolId": "School ID",
  "loginNoAccount": "Don't have an account?",
  "loginSignUp": "Sign Up",
  "loginBrandTagline": "Master every\nformula with\nease.",
  "loginBrandDesc": "The ultimate cognitive sanctuary for high school scholars. Organize, learn, and excel in your mathematical journey.",
  "loginStudentPortal": "STUDENT PORTAL",
  "signupTitle": "Create your account",
  "signupSubtitle": "Start your journey into the Cognitive Sanctuary.",
  "signupFullName": "Full Name",
  "signupFullNameHint": "John Doe",
  "signupEmail": "Email Address",
  "signupEmailHint": "name@school.com",
  "signupPassword": "Password",
  "signupConfirmPassword": "Confirm Password",
  "signupPasswordHint": "••••••••",
  "signupTerms": "I agree to the ",
  "signupTermsLink": "Terms of Service",
  "signupAnd": " and ",
  "signupPrivacy": "Privacy Policy",
  "signupCreateAccount": "Create Account",
  "signupOrJoin": "Or join with",
  "signupFacebook": "Facebook",
  "signupHasAccount": "Already have an account?",
  "signupSignIn": "Sign In",
  "signupBrandTitle": "Formula Sanctuary",
  "signupBrandHeadline": "Master the Flow of Knowledge.",
  "signupBrandDesc": "Join a sanctuary designed for focused learning. Transform complex equations into intuitive steps.",
  "signupTestimonial": "\"The formulas finally make sense. It doesn't feel like studying; it feels like exploring.\"",
  "signupTestimonialName": "Ishita Sharma",
  "signupTestimonialRole": "Class 9 Student"
}

import collections
import codecs

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
