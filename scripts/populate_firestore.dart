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

  stdout.writeln('Starting populating Firestore...');

  // --- Onboarding: Boards & Grades ---
  stdout.writeln('Populating Boards & Grades...');
  final boardsRef = firestore.collection('boards');

  final boardsData = [
    {
      'id': 'cbse',
      'name': 'CBSE',
      'description': 'Central Board of Secondary Education',
    },
    {
      'id': 'icse',
      'name': 'ICSE',
      'description': 'Council for Indian School Certificate',
    },
    {
      'id': 'state',
      'name': 'State Board',
      'description': 'Regional Curriculum',
    },
    {
      'id': 'igcse',
      'name': 'IGCSE',
      'description': 'International General Cert.',
    },
    {
      'id': 'ib',
      'name': 'IB Board',
      'description': 'International Baccalaureate',
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

    // Add grades as subcollection for each board
    final gradesRef = boardDoc.collection('grades');
    for (var gradeMap in gradesData) {
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

  stdout.writeln('Done populating Firestore!');
  exit(0);
}
