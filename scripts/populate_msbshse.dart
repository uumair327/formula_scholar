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

void main(List<String> args) async {
  final serviceAccountPath = resolveServiceAccountPath(args);

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  stdout.writeln('Starting populating MSBSHSE Firestore data...');

  // --- Country: India ---
  await firestore.collection('countries').doc('IN').set({
    'name': 'India',
    'isoCode': 'IND',
    'flagUrl': 'https://flagcdn.com/w80/in.png',
  });

  // --- State: Maharashtra ---
  // Doc ID 'maharashtra' — this is what the Flutter adapter reads as stateId.
  await firestore
      .collection('countries')
      .doc('IN')
      .collection('states')
      .doc('maharashtra')
      .set({'name': 'Maharashtra', 'stateCode': 'MH', 'countryId': 'IN'});

  // --- MSBSHSE Board ---
  // stateId MUST match the state document ID ('maharashtra') so the
  // Flutter onboarding adapter can filter boards by state correctly.
  final boardsRef = firestore.collection('boards');
  await boardsRef.doc('msbshse').set({
    'id': 'msbshse',
    'countryId': 'IN',
    'stateId': 'maharashtra',
    'type': 'state',
    'name': 'MSBSHSE',
    'description':
        'Maharashtra State Board of Secondary and Higher Secondary Education',
  });

  // --- Classes ---
  final gradesRef = boardsRef.doc('msbshse').collection('classes');
  await gradesRef.doc('class_9').set({
    'id': 'class_9',
    'label': 'Class 9',
    'classNumber': 9,
    'isPopular': true,
  });

  // Backward compatibility for adapters still reading `grades` in some paths.
  final legacyGradesRef = boardsRef.doc('msbshse').collection('grades');
  await legacyGradesRef.doc('class_9').set({
    'id': 'class_9',
    'label': 'Class 9',
    'classNumber': 9,
    'isPopular': true,
  });

  // --- Subjects ---
  final subjectsRef = firestore.collection('subjects');
  final msbSubjects = [
    {
      'id': 'msbshse_class_9_algebra',
      'boardId': 'msbshse',
      'gradeId': 'class_9',
      'name': 'Mathematics',
      'subtitle': 'Part 1 - Algebra (Maths-I)',
      'description':
          'Complete syllabus for Maharashtra State Board Class 9 Algebra.',
      'category': 'Mathematics',
      'imageUrl': '',
      'unitCount': 7,
      'formulaCount': 10,
      'iconName': 'calculator',
      'colorValue': 0xFF00639A,
      'badgeText': 'MSBSHSE 9th',
      'isFeatured': true,
    },
    {
      'id': 'msbshse_class_9_geometry',
      'boardId': 'msbshse',
      'gradeId': 'class_9',
      'name': 'Mathematics',
      'subtitle': 'Part 2 - Geometry (Maths-II)',
      'description':
          'Complete syllabus for Maharashtra State Board Class 9 Geometry.',
      'category': 'Mathematics',
      'imageUrl': '',
      'unitCount': 9,
      'formulaCount': 12,
      'iconName': 'compass',
      'colorValue': 0xFF056C42,
      'badgeText': 'MSBSHSE 9th',
      'isFeatured': false,
    },
  ];

  for (var sub in msbSubjects) {
    await subjectsRef.doc(sub['id'] as String).set(sub);
  }

  // --- Mastery Tools (subject scoped) ---
  // Seeded as a subcollection to keep chapters feature extensible
  // without changing chapter/formula schemas.
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

  for (final sub in msbSubjects) {
    final subjectId = sub['id'] as String;
    final toolsRef = subjectsRef.doc(subjectId).collection('mastery_tools');
    for (final tool in masteryTools) {
      await toolsRef.doc(tool['id'] as String).set(tool);
    }
  }

  // --- Chapters & Formulas ---
  final chaptersData = {
    'msbshse_class_9_algebra': [
      {
        'id': 'sets',
        'name': '1. Sets',
        'subtitle': 'Collections and Operations',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Union of Sets',
            'latex': r'A \cup B = \{x \mid x \in A \text{ or } x \in B\}',
            'description': 'Elements in A or B or both',
          },
          {
            'id': 'f2',
            'title': 'Intersection of Sets',
            'latex': r'A \cap B = \{x \mid x \in A \text{ and } x \in B\}',
            'description': 'Elements common to A and B',
          },
        ],
      },
      {
        'id': 'real_numbers',
        'name': '2. Real Numbers',
        'subtitle': 'Properties and Surds',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Properties of Surds',
            'latex': r'\sqrt{a} \times \sqrt{b} = \sqrt{ab}',
            'description': 'Product of two surds',
          },
        ],
      },
      {
        'id': 'polynomials',
        'name': '3. Polynomials',
        'subtitle': 'Algebraic Operations',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Remainder Theorem',
            'latex':
                r'P(a) = \text{Remainder when } P(x) \text{ is divided by } (x-a)',
            'description': 'Remainder Theorem',
          },
        ],
      },
      {
        'id': 'ratio_proportion',
        'name': '4. Ratio and Proportion',
        'subtitle': 'Comparisons',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Proportion',
            'latex': r'\frac{a}{b} = \frac{c}{d} \implies ad = bc',
            'description': 'Cross multiplication in proportion',
          },
        ],
      },
      {
        'id': 'linear_eq_two_vars',
        'name': '5. Linear Equations in Two Variables',
        'subtitle': 'Graphical Methods',
        'formulas': [
          {
            'id': 'f1',
            'title': 'General Form',
            'latex': r'ax + by + c = 0',
            'description': 'General form of a linear equation',
          },
        ],
      },
      {
        'id': 'financial_planning',
        'name': '6. Financial Planning',
        'subtitle': 'Taxes and Savings',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Income Tax',
            'latex': r'\text{Tax} = \text{Taxable Income} \times \text{Rate}',
            'description': 'Basic tax calculation',
          },
        ],
      },
      {
        'id': 'statistics',
        'name': '7. Statistics',
        'subtitle': 'Data Interpretation',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Mean',
            'latex': r'\bar{x} = \frac{\sum x_i}{n}',
            'description': 'Average of given data',
          },
        ],
      },
    ],
    'msbshse_class_9_geometry': [
      {
        'id': 'basic_concepts',
        'name': '1. Basic Concepts in Geometry',
        'subtitle': 'Points, Lines, Planes',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Distance Formula (1D)',
            'latex': r'd(A, B) = |x_2 - x_1|',
            'description': 'Distance between two points on a number line',
          },
        ],
      },
      {
        'id': 'parallel_lines',
        'name': '2. Parallel Lines',
        'subtitle': 'Transversals and Angles',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Alternate Interior Angles',
            'latex': r'\angle 1 = \angle 2',
            'description':
                'Alternate interior angles are equal when lines are parallel',
          },
        ],
      },
      {
        'id': 'triangles',
        'name': '3. Triangles',
        'subtitle': 'Congruence and Properties',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Angle Sum Property',
            'latex': r'\angle A + \angle B + \angle C = 180^\circ',
            'description': 'Sum of angles in a triangle',
          },
        ],
      },
      {
        'id': 'constructions_triangles',
        'name': '4. Constructions of Triangles',
        'subtitle': 'Geometric Tools',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Perpendicular Bisector',
            'latex': r'PA = PB',
            'description':
                'Any point on a perpendicular bisector is equidistant from endpoints',
          },
        ],
      },
      {
        'id': 'quadrilaterals',
        'name': '5. Quadrilaterals',
        'subtitle': 'Types and Properties',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Angle Sum of Quadrilateral',
            'latex': r'\sum \angle = 360^\circ',
            'description': 'Sum of angles in a quadrilateral',
          },
        ],
      },
      {
        'id': 'circle',
        'name': '6. Circle',
        'subtitle': 'Chords and Arcs',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Area of Circle',
            'latex': r'A = \pi r^2',
            'description': 'Area enclosed by a circle',
          },
        ],
      },
      {
        'id': 'coordinate_geometry',
        'name': '7. Co-ordinate Geometry',
        'subtitle': 'Distance and Graphs',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Distance Formula',
            'latex': r'd = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}',
            'description': 'Distance between two points',
          },
        ],
      },
      {
        'id': 'trigonometry',
        'name': '8. Trigonometry',
        'subtitle': 'Ratios and Identities',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Fundamental Identity',
            'latex': r'\sin^2 \theta + \cos^2 \theta = 1',
            'description': 'Trigonometric identity',
          },
        ],
      },
      {
        'id': 'surface_area_volume',
        'name': '9. Surface Area and Volume',
        'subtitle': '3D Shapes',
        'formulas': [
          {
            'id': 'f1',
            'title': 'Volume of Cylinder',
            'latex': r'V = \pi r^2 h',
            'description': 'Volume of a cylinder',
          },
        ],
      },
    ],
  };

  for (var entry in chaptersData.entries) {
    final subId = entry.key;
    final chList = entry.value;
    final chapRef = subjectsRef.doc(subId).collection('chapters');
    for (var chMap in chList) {
      final formulas = chMap['formulas'] as List<Map<String, dynamic>>;
      final chapDoc = {
        'id': chMap['id'],
        'name': chMap['name'],
        'subtitle': chMap['subtitle'],
        'completedFormulas': 0,
        'totalFormulas': formulas.length,
        'progressPercent': 0.0,
        'status': 'notStarted',
      };
      await chapRef.doc(chMap['id'] as String).set(chapDoc);

      final formRef = chapRef.doc(chMap['id'] as String).collection('formulas');
      for (var formMap in formulas) {
        await formRef.doc(formMap['id'] as String).set({
          'id': formMap['id'],
          'title': formMap['title'],
          'latex': formMap['latex'],
          'description': formMap['description'],
          'isMastered': false,
        });
      }
    }
  }

  // --- Practice Questions (board/grade scoped) ---
  final practiceRef = firestore.collection('practice_questions');
  final msbPractice = [
    {
      'id': 'msb_q1',
      'boardId': 'msbshse',
      'gradeId': 'class_9',
      'category': 'Algebra Basics',
      'topic': 'Polynomials',
      'questionText': 'Which identity expands (a + b)^2 ?',
      'imageUrl': '',
      'options': [
        {'id': 'A', 'text': 'a^2 + b^2'},
        {'id': 'B', 'text': 'a^2 + 2ab + b^2'},
        {'id': 'C', 'text': 'a^2 - 2ab + b^2'},
        {'id': 'D', 'text': '2a + 2b'},
      ],
      'correctOptionId': 'B',
      'points': 10,
    },
    {
      'id': 'msb_q2',
      'boardId': 'msbshse',
      'gradeId': 'class_9',
      'category': 'Geometry Basics',
      'topic': 'Triangles',
      'questionText': 'What is the sum of interior angles of a triangle?',
      'imageUrl': '',
      'options': [
        {'id': 'A', 'text': '90 degrees'},
        {'id': 'B', 'text': '120 degrees'},
        {'id': 'C', 'text': '180 degrees'},
        {'id': 'D', 'text': '360 degrees'},
      ],
      'correctOptionId': 'C',
      'points': 10,
    },
  ];

  for (final question in msbPractice) {
    await practiceRef.doc(question['id'] as String).set(question);
  }

  stdout.writeln(
    'Done populating MSBSHSE data! Formulas and chapters added correctly.',
  );
  exit(0);
}
