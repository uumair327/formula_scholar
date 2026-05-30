import json
import collections
import codecs

updates = {
  "circlesAndAreas": "Circles & Areas",
  "geometryBasics": "GEOMETRY BASICS",
  "practiceQuestionLabel": "QUESTION",
  "ofLabel": "of",
  "ptsLabel": "pts",
  "correct": "Correct!",
  "plusPointsTemplate": "+10 Points",
  "masteryLevelIncreasing": "Mastery level increasing",
  "areaOfCircleQuestion": "Which of the following formulas correctly represents the area of a circle with radius r?",
  "nextQuestion": "Next Question",
  "quizCompleteTitle": "Quiz Complete!",
  "quizCompleteDesc": "Great effort! Review your results below.",
  "practiceNoQuestionsTitle": "No practice questions yet",
  "practiceNoQuestionsDesc": "Your current curriculum does not have practice questions available yet. Try again soon or open Chapters to keep learning.",
  "playAgain": "Play Again",
  "wrongAnswer": "Incorrect",
  "tryNextTime": "Review and try again next time",
  "practiceReadyTitle": "Ready to Practice?",
  "practiceReadyDesc": "Choose a subject and test your knowledge with practice questions.",
  "practiceChooseSubject": "Choose Subject",
  "allSubjects": "All Subjects",
  "timedMode": "Timed Mode",
  "timedModeDesc": "Set a time limit for this quiz",
  "duration": "Duration",
  "scoreLabel": "Score",
  "correctLabel": "Correct",
  "incorrectLabel": "Incorrect",
  "perCategory": "Per Category",
  "retryIncorrect": "Retry Incorrect",
  "backToDashboard": "Back to Dashboard",
  "timeTaken": "Time Taken",
  "formulaFlow": "Formula Scholar"
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
