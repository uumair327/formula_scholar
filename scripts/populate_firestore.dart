import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

String resolveServiceAccountPath(List<String> args) {
  if (args.isNotEmpty) {
    return args.first;
  }

  final envPath = Platform.environment['FIREBASE_SERVICE_ACCOUNT_PATH'];
  if (envPath != null && envPath.isNotEmpty) {
    return envPath;
  }

  throw StateError(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.',
  );
}

String resolveTargetUserUid() {
  final envUid = Platform.environment['TARGET_USER_UID'];
  if (envUid != null && envUid.isNotEmpty) {
    return envUid;
  }

  // Defaults to the provided Firebase Auth UID for local seeding.
  return '3y6cquvN0KbzhmqayddYABzLWMh2';
}

String resolveTargetUserEmail() {
  final envEmail = Platform.environment['TARGET_USER_EMAIL'];
  if (envEmail != null && envEmail.isNotEmpty) {
    return envEmail;
  }

  // Defaults to the provided Firebase Auth email for local seeding.
  return 'uumair327@gmail.com';
}

void main(List<String> args) async {
  final serviceAccountPath = resolveServiceAccountPath(args);
  final targetUid = resolveTargetUserUid();
  final targetEmail = resolveTargetUserEmail();

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  stdout.writeln('Starting populating Firestore...');

  // --- Onboarding: Countries & States ---
  stdout.writeln('Populating Countries & States...');
  final countriesRef = firestore.collection('countries');
  await countriesRef.doc('IN').set({
    'name': 'India',
    'isoCode': 'IN',
    'flagUrl': '',
  });

  final indiaStatesRef = countriesRef.doc('IN').collection('states');
  final indiaStates = [
    {'id': 'MH', 'name': 'Maharashtra', 'stateCode': 'MH'},
    {'id': 'DL', 'name': 'Delhi', 'stateCode': 'DL'},
    {'id': 'KA', 'name': 'Karnataka', 'stateCode': 'KA'},
    {'id': 'TN', 'name': 'Tamil Nadu', 'stateCode': 'TN'},
  ];
  for (final state in indiaStates) {
    await indiaStatesRef.doc(state['id']).set(state);
  }

  // --- Onboarding: Boards & Grades ---
  stdout.writeln('Populating Boards & Grades...');
  final boardsRef = firestore.collection('boards');

  final boardsData = [
    {
      'id': 'cbse',
      'countryId': 'IN',
      'type': 'national',
      'name': 'CBSE',
      'description': 'Central Board of Secondary Education',
    },
    {
      'id': 'icse',
      'countryId': 'IN',
      'type': 'private',
      'name': 'ICSE',
      'description': 'Council for Indian School Certificate',
    },
    {
      'id': 'msbshse',
      'countryId': 'IN',
      'stateId': 'MH',
      'type': 'state',
      'name': 'MSBSHSE',
      'description':
          'Maharashtra State Board of Secondary and Higher Secondary Education',
    },
  ];

  final gradesData = [
    {'id': 'class_8', 'label': 'Class 8', 'classNumber': 8, 'isPopular': false},
    {
      'id': 'class_9',
      'label': 'Class 9',
      'classNumber': 9,
      'subtitle': 'Foundation Year',
      'isPopular': true,
    },
    {
      'id': 'class_10',
      'label': 'Class 10',
      'classNumber': 10,
      'isPopular': false,
    },
    {
      'id': 'class_11',
      'label': 'Class 11',
      'classNumber': 11,
      'isPopular': false,
    },
    {
      'id': 'class_12',
      'label': 'Class 12',
      'classNumber': 12,
      'isPopular': false,
    },
  ];

  for (var boardMap in boardsData) {
    stdout.writeln('  Adding board: ${boardMap['id']}');
    final boardDoc = boardsRef.doc(boardMap['id'] as String);
    await boardDoc.set(boardMap);

    // Add both classes and grades subcollections for compatibility.
    final classesRef = boardDoc.collection('classes');
    final gradesRef = boardDoc.collection('grades');
    for (var gradeMap in gradesData) {
      await classesRef.doc(gradeMap['id'] as String).set(gradeMap);
      await gradesRef.doc(gradeMap['id'] as String).set(gradeMap);
    }
  }

  // --- Dashboard: Subjects ---
  stdout.writeln('Populating Subjects...');
  final subjectsRef = firestore.collection('subjects');
  final subjectsData = [
    {
      'id': 'math',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'name': 'Mathematics',
      'subtitle': 'Polynomials & Geometrical Proofs',
      'description':
          'Detailed CBSE compliant formula sheets for algebraic identities and theorems.',
      'category': 'Mathematics',
      'imageUrl': '',
      'unitCount': 8,
      'formulaCount': 124,
      'iconName': 'calculator',
      'colorValue': 0xFF00639A,
      'badgeText': 'CBSE 9 CURATED',
      'isFeatured': true,
      'masteryPercentage': null,
      'lastViewed': null,
    },
    {
      'id': 'physics',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'name': 'Physics',
      'subtitle': 'Gravitation & Sound',
      'description':
          'Universal law of gravitation and its implications in the Grade IX science curriculum.',
      'category': 'Physics',
      'imageUrl': '',
      'unitCount': 6,
      'formulaCount': 89,
      'iconName': 'rocket',
      'colorValue': 0xFF056C42,
      'badgeText': 'GRADE 9',
      'isFeatured': false,
      'masteryPercentage': 75.0,
      'lastViewed': null,
    },
    {
      'id': 'chemistry',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'name': 'Chemistry',
      'subtitle': 'Atoms & Molecules',
      'description': 'Atomic mass, molecular formula & mole concept.',
      'category': 'Chemistry',
      'imageUrl': '',
      'unitCount': 5,
      'formulaCount': 67,
      'iconName': 'flask-conical',
      'colorValue': 0xFF655781,
      'badgeText': null,
      'isFeatured': false,
      'masteryPercentage': null,
      'lastViewed': '2 days ago',
    },
    {
      'id': 'biology',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'name': 'Biology',
      'subtitle': 'Cell: The Fundamental Unit',
      'description': 'Exploring cell structure, organelles and functions.',
      'category': 'Biology',
      'imageUrl': '',
      'unitCount': 4,
      'formulaCount': 42,
      'iconName': 'microscope',
      'colorValue': 0xFF707881,
      'badgeText': null,
      'isFeatured': false,
      'masteryPercentage': null,
      'lastViewed': null,
    },
  ];

  for (var subjectMap in subjectsData) {
    stdout.writeln('  Adding subject: ${subjectMap['id']}');
    await subjectsRef.doc(subjectMap['id'] as String).set(subjectMap);
  }

  // --- Chapters: Mastery Tools ---
  stdout.writeln('Populating Mastery Tools...');
  final masteryTools = [
    {
      'id': 'video_lessons',
      'label': 'Video Lessons',
      'iconName': 'graduationCap',
      'category': 'guided_learning',
      'isEnabled': false,
      'supportSubtitle':
          'Video Lessons are currently being prepared. Contact support if you need access to guided tutorial content.',
      'displayOrder': 1,
    },
    {
      'id': 'practice_quiz',
      'label': 'Practice Quiz',
      'iconName': 'helpCircle',
      'category': 'assessment',
      'isEnabled': true,
      'routeName': 'practice',
      'displayOrder': 2,
    },
    {
      'id': 'cheat_sheets',
      'label': 'Cheat Sheets',
      'iconName': 'fileText',
      'category': 'quick_reference',
      'isEnabled': false,
      'supportSubtitle':
          'Cheat Sheets provide quick formula reference guides. Contact support to request this feature for your curriculum.',
      'displayOrder': 3,
    },
    {
      'id': 'visualizer_3d',
      'label': 'Visualizer 3D',
      'iconName': 'box',
      'category': 'visual_learning',
      'isEnabled': false,
      'supportSubtitle':
          '3D Visualizer helps understand geometric concepts. Contact support to request 3D visualization tools.',
      'displayOrder': 4,
    },
  ];

  for (final subjectMap in subjectsData) {
    final subjectId = subjectMap['id'] as String;
    final toolsRef = subjectsRef.doc(subjectId).collection('mastery_tools');
    for (final tool in masteryTools) {
      await toolsRef.doc(tool['id'] as String).set(tool);
    }
  }

  // --- Chapters (Subcollections of Subjects) ---
  stdout.writeln('Populating Chapters...');
  final chaptersData = {
    'math': [
      {
        'id': 'polynomials',
        'name': 'Polynomials',
        'subtitle': 'Algebra & Equations',
        'completedFormulas': 8,
        'totalFormulas': 12,
        'progressPercent': 65.0,
        'status': 'inProgress',
      },
      {
        'id': 'triangles',
        'name': 'Triangles',
        'subtitle': 'Geometry & Theorems',
        'completedFormulas': 2,
        'totalFormulas': 20,
        'progressPercent': 10.0,
        'status': 'notStarted',
      },
      {
        'id': 'circles',
        'name': 'Circles',
        'subtitle': 'Theorems & Proofs',
        'completedFormulas': 0,
        'totalFormulas': 15,
        'progressPercent': 0.0,
        'status': 'locked',
      },
    ],
    'physics': [
      {
        'id': 'motion',
        'name': 'Motion',
        'subtitle': 'Velocity, acceleration & graphs',
        'completedFormulas': 3,
        'totalFormulas': 6,
        'progressPercent': 50.0,
        'status': 'inProgress',
      },
      {
        'id': 'force',
        'name': 'Force and Laws of Motion',
        'subtitle': 'Newton’s three laws',
        'completedFormulas': 0,
        'totalFormulas': 5,
        'progressPercent': 0.0,
        'status': 'notStarted',
      },
      {
        'id': 'gravitation',
        'name': 'Gravitation',
        'subtitle': 'Universal law & Free fall',
        'completedFormulas': 0,
        'totalFormulas': 4,
        'progressPercent': 0.0,
        'status': 'locked',
      },
    ],
    'chemistry': [
      {
        'id': 'matter',
        'name': 'Matter in our Surroundings',
        'subtitle': 'States of matter',
        'completedFormulas': 2,
        'totalFormulas': 4,
        'progressPercent': 50.0,
        'status': 'inProgress',
      },
      {
        'id': 'atoms',
        'name': 'Atoms and Molecules',
        'subtitle': 'Moles & formulae',
        'completedFormulas': 0,
        'totalFormulas': 6,
        'progressPercent': 0.0,
        'status': 'notStarted',
      },
      {
        'id': 'structure_of_atom',
        'name': 'Structure of the Atom',
        'subtitle': 'Electrons, protons & neutrons',
        'completedFormulas': 0,
        'totalFormulas': 5,
        'progressPercent': 0.0,
        'status': 'locked',
      },
    ],
  };

  for (var entry in chaptersData.entries) {
    final subId = entry.key;
    final chList = entry.value;
    final chapRef = subjectsRef.doc(subId).collection('chapters');
    for (var chMap in chList) {
      await chapRef.doc(chMap['id'] as String).set(chMap);
    }
  }

  // --- Formulas for specific chapters ---
  stdout.writeln('Populating Formulas for Chapters...');
  final formulasData = {
    'polynomials': [
      {
        'id': 'f1',
        'title': 'Square of Sum',
        'latex': r'(x + y)^2 = x^2 + 2xy + y^2',
        'description': 'Used to expand the square of a sum of two terms.',
        'isMastered': true,
      },
      {
        'id': 'f2',
        'title': 'Square of Difference',
        'latex': r'(x - y)^2 = x^2 - 2xy + y^2',
        'description':
            'Used to expand the square of a difference of two terms.',
        'isMastered': true,
      },
      {
        'id': 'f3',
        'title': 'Difference of Squares',
        'latex': r'x^2 - y^2 = (x + y)(x - y)',
        'description': 'Factors the difference of two squared terms.',
        'isMastered': false,
      },
      {
        'id': 'f4',
        'title': 'Square of Trinomial',
        'latex': r'(x + y + z)^2 = x^2 + y^2 + z^2 + 2xy + 2yz + 2zx',
        'description': 'Expands the square of a sum of three terms.',
        'isMastered': false,
      },
    ],
    'triangles': [
      {
        'id': 'f1',
        'title': 'SAS Congruence',
        'latex':
            r'\triangle ABC \cong \triangle DEF \iff AB=DE, \angle B=\angle E, BC=EF',
        'description': 'Side-Angle-Side congruence rule.',
        'isMastered': false,
      },
      {
        'id': 'f2',
        'title': 'ASA Congruence',
        'latex':
            r'\triangle ABC \cong \triangle DEF \iff \angle B=\angle E, BC=EF, \angle C=\angle F',
        'description': 'Angle-Side-Angle congruence rule.',
        'isMastered': false,
      },
      {
        'id': 'f3',
        'title': 'SSS Congruence',
        'latex': r'\triangle ABC \cong \triangle DEF \iff AB=DE, BC=EF, AC=DF',
        'description': 'Side-Side-Side congruence rule.',
        'isMastered': false,
      },
      {
        'id': 'f4',
        'title': 'Isosceles Triangle Theorem',
        'latex': r'AB = AC \implies \angle B = \angle C',
        'description':
            'Angles opposite to equal sides of a triangle are equal.',
        'isMastered': false,
      },
    ],
    'circles': [
      {
        'id': 'f1',
        'title': 'Equal Chords Theorem',
        'latex': r'AB = CD \implies \angle AOB = \angle COD',
        'description':
            'Equal chords of a circle subtend equal angles at the center.',
        'isMastered': false,
      },
      {
        'id': 'f2',
        'title': 'Perpendicular from Center',
        'latex': r'OM \perp AB \implies AM = MB',
        'description':
            'The perpendicular from the center of a circle to a chord bisects the chord.',
        'isMastered': false,
      },
      {
        'id': 'f3',
        'title': 'Angles in Same Segment',
        'latex': r'\angle ACB = \angle ADB',
        'description': 'Angles in the same segment of a circle are equal.',
        'isMastered': false,
      },
      {
        'id': 'f4',
        'title': 'Cyclic Quadrilateral',
        'latex': r'\angle A + \angle C = 180^\circ',
        'description':
            'The sum of either pair of opposite angles of a cyclic quadrilateral is 180^circ.',
        'isMastered': false,
      },
    ],
  };

  for (var entry in formulasData.entries) {
    final chapterId = entry.key;
    final formulas = entry.value;
    final formulasRef = subjectsRef
        .doc('math')
        .collection('chapters')
        .doc(chapterId)
        .collection('formulas');
    for (var fMap in formulas) {
      await formulasRef.doc(fMap['id'] as String).set(fMap);
    }
  }

  // --- Practice Questions ---
  stdout.writeln('Populating Practice Questions...');
  final practiceRef = firestore.collection('practice_questions');
  final questionsData = [
    {
      'id': 'q1',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'category': 'Geometry Basics',
      'topic': 'Circles & Areas',
      'questionText': 'What is the formula for the area of a circle?',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuClyZ-0UYuRRBHxAK0Ii_GxesoYDVyrxZfvJWsymATBzNfEFu_iTlQKrn6WDEUNWXKoitdhKsUElgGpRyyEDswTW9KhMMYs5QimgyHDlitfY1ZJhQhiZOF7b4GxG2HZ-t9M95XrDj9ci-A4O49TQ6E3FzBYrSZEs9k4pH8cjHZeYeZcK5cCJ9fbre1soRe_zMPcEFzy3-XsnbRIvRP-wZLWM3lfBCxO1TpPnNRhgXNZULDzi3iu0pqVs0JAbFAFhDPU1sb6_0jjdHU',
      'options': [
        {'id': 'A', 'text': '2πr'},
        {'id': 'B', 'text': 'πr²'},
        {'id': 'C', 'text': 'πd'},
        {'id': 'D', 'text': '4/3 πr³'},
      ],
      'correctOptionId': 'B',
      'points': 10,
    },
    {
      'id': 'q2',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'category': 'Geometry Basics',
      'topic': 'Triangles',
      'questionText':
          'What is the area of a triangle with base b and height h?',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuClyZ-0UYuRRBHxAK0Ii_GxesoYDVyrxZfvJWsymATBzNfEFu_iTlQKrn6WDEUNWXKoitdhKsUElgGpRyyEDswTW9KhMMYs5QimgyHDlitfY1ZJhQhiZOF7b4GxG2HZ-t9M95XrDj9ci-A4O49TQ6E3FzBYrSZEs9k4pH8cjHZeYeZcK5cCJ9fbre1soRe_zMPcEFzy3-XsnbRIvRP-wZLWM3lfBCxO1TpPnNRhgXNZULDzi3iu0pqVs0JAbFAFhDPU1sb6_0jjdHU',
      'options': [
        {'id': 'A', 'text': 'b × h'},
        {'id': 'B', 'text': '½ × b × h'},
        {'id': 'C', 'text': 'b + h'},
        {'id': 'D', 'text': '2(b + h)'},
      ],
      'correctOptionId': 'B',
      'points': 10,
    },
    {
      'id': 'q3',
      'boardId': 'cbse',
      'gradeId': 'class_9',
      'category': 'Polynomial Identities',
      'topic': 'Circles & Areas', // kept from mock
      'questionText': 'Expand: (a + b)²',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuClyZ-0UYuRRBHxAK0Ii_GxesoYDVyrxZfvJWsymATBzNfEFu_iTlQKrn6WDEUNWXKoitdhKsUElgGpRyyEDswTW9KhMMYs5QimgyHDlitfY1ZJhQhiZOF7b4GxG2HZ-t9M95XrDj9ci-A4O49TQ6E3FzBYrSZEs9k4pH8cjHZeYeZcK5cCJ9fbre1soRe_zMPcEFzy3-XsnbRIvRP-wZLWM3lfBCxO1TpPnNRhgXNZULDzi3iu0pqVs0JAbFAFhDPU1sb6_0jjdHU',
      'options': [
        {'id': 'A', 'text': 'a² + b²'},
        {'id': 'B', 'text': 'a² + 2ab + b²'},
        {'id': 'C', 'text': 'a² - 2ab + b²'},
        {'id': 'D', 'text': '2a + 2b'},
      ],
      'correctOptionId': 'B',
      'points': 10,
    },
  ];

  for (var qMap in questionsData) {
    stdout.writeln('  Adding practice question: ${qMap['id']}');
    await practiceRef.doc(qMap['id'] as String).set(qMap);
  }

  // --- Saved Notes ---
  stdout.writeln('Populating Saved Notes...');
  final savedNotesRef = firestore.collection('saved_notes');
  final savedNotesData = [
    {
      'id': 'note_1',
      'curriculumKey': 'cbse_class_9',
      'title': 'Polynomial Identity Cheatsheet',
      'subject': 'Mathematics',
      'content':
          'Remember the three core identities: square of sum, square of difference, and difference of squares. Use them to factor quickly in revision problems.',
      'savedAt': Timestamp.fromDate(DateTime.utc(2026, 4, 17)),
    },
    {
      'id': 'note_2',
      'curriculumKey': 'cbse_class_9',
      'title': 'Triangle Theorems Summary',
      'subject': 'Mathematics',
      'content':
          'SAS, ASA, and SSS congruence rules are the backbone of most proof questions. Practice naming the rule before writing the proof.',
      'savedAt': Timestamp.fromDate(DateTime.utc(2026, 4, 16)),
    },
  ];

  for (final note in savedNotesData) {
    stdout.writeln('  Adding saved note: ${note['id']}');
    await savedNotesRef.doc(note['id'] as String).set(note);
  }

  // --- Target User Data (for testing Profile and Dashboard) ---
  stdout.writeln('Populating Target User Data...');
  final usersRef = firestore.collection('users');

  // Seed target user profile
  await usersRef.doc(targetUid).set({
    'uid': targetUid,
    'email': targetEmail,
    'displayName': 'Uumair',
    'photoUrl': 'https://via.placeholder.com/150',
    'boardId': 'cbse',
    'gradeId': 'class_9',
  });

  // Seed target user stats
  await usersRef.doc(targetUid).collection('stats').doc('current').set({
    'formulas': 47,
    'streak': 12,
    'points': 850,
    'lastUpdated': Timestamp.now(),
  });

  // Seed target user recent studies
  stdout.writeln('Adding recent studies for target user...');
  final recentStudiesRef = usersRef.doc(targetUid).collection('recent_studies');
  final recentStudiesData = [
    {
      'id': 'rs1',
      'subjectId': 'math',
      'title': 'Polynomials',
      'subject': 'Mathematics',
      'lastViewed': 'Today at 3:45 PM',
      'iconName': 'calculator',
      'colorValue': 0xFFD4A574,
      'backgroundColorValue': 0xFFFFEAD1,
      'viewedAt': Timestamp.now(),
    },
    {
      'id': 'rs2',
      'subjectId': 'physics',
      'title': 'Motion',
      'subject': 'Physics',
      'lastViewed': 'Yesterday at 2:30 PM',
      'iconName': 'flashArrowRight',
      'colorValue': 0xFF3B82F6,
      'backgroundColorValue': 0xFFDEEAFF,
      'viewedAt': Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 1)),
      ),
    },
    {
      'id': 'rs3',
      'subjectId': 'chemistry',
      'title': 'Atomic Structure',
      'subject': 'Chemistry',
      'lastViewed': '2 days ago at 11:15 AM',
      'iconName': 'microscope',
      'colorValue': 0xFFEA580C,
      'backgroundColorValue': 0xFFFECDD2,
      'viewedAt': Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 2)),
      ),
    },
  ];

  for (final study in recentStudiesData) {
    stdout.writeln('  Adding recent study: ${study['id']}');
    await recentStudiesRef.doc(study['id'] as String).set(study);
  }

  stdout.writeln('Done populating Firestore!');
  exit(0);
}
