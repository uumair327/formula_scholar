import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

void main() async {
  final serviceAccountPath =
      r'C:\Users\uumai\Downloads\zip\formula_scholar\formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json';

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  print('Starting populating MSBSHSE Firestore data...');

  // --- MSBSHSE Board ---
  final boardsRef = firestore.collection('boards');
  await boardsRef.doc('msbshse').set({
    'id': 'msbshse',
    'countryId': 'IN',
    'stateId': 'MH',
    'type': 'state',
    'name': 'MSBSHSE',
    'description': 'Maharashtra State Board of Secondary and Higher Secondary Education'
  });

  // --- Classes ---
  final gradesRef = boardsRef.doc('msbshse').collection('classes');
  await gradesRef.doc('class_9').set({
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
      'description': 'Complete syllabus for Maharashtra State Board Class 9 Algebra.',
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
      'description': 'Complete syllabus for Maharashtra State Board Class 9 Geometry.',
      'category': 'Mathematics',
      'imageUrl': '',
      'unitCount': 9,
      'formulaCount': 12,
      'iconName': 'compass',
      'colorValue': 0xFF056C42,
      'badgeText': 'MSBSHSE 9th',
      'isFeatured': false,
    }
  ];

  for (var sub in msbSubjects) {
     await subjectsRef.doc(sub['id'] as String).set(sub);
  }

  // --- Chapters & Formulas ---
  final chaptersData = {
    'msbshse_class_9_algebra': [
      {'id': 'sets', 'name': '1. Sets', 'subtitle': 'Collections and Operations', 'formulas': [
        {'id': 'f1', 'title': 'Union of Sets', 'latex': r'A \cup B = \{x \mid x \in A \text{ or } x \in B\}', 'description': 'Elements in A or B or both'},
        {'id': 'f2', 'title': 'Intersection of Sets', 'latex': r'A \cap B = \{x \mid x \in A \text{ and } x \in B\}', 'description': 'Elements common to A and B'}
      ]},
      {'id': 'real_numbers', 'name': '2. Real Numbers', 'subtitle': 'Properties and Surds', 'formulas': [
        {'id': 'f1', 'title': 'Properties of Surds', 'latex': r'\sqrt{a} \times \sqrt{b} = \sqrt{ab}', 'description': 'Product of two surds'},
      ]},
      {'id': 'polynomials', 'name': '3. Polynomials', 'subtitle': 'Algebraic Operations', 'formulas': [
        {'id': 'f1', 'title': 'Remainder Theorem', 'latex': r'P(a) = \text{Remainder when } P(x) \text{ is divided by } (x-a)', 'description': 'Remainder Theorem'}
      ]},
      {'id': 'ratio_proportion', 'name': '4. Ratio and Proportion', 'subtitle': 'Comparisons', 'formulas': [
        {'id': 'f1', 'title': 'Proportion', 'latex': r'\frac{a}{b} = \frac{c}{d} \implies ad = bc', 'description': 'Cross multiplication in proportion'}
      ]},
      {'id': 'linear_eq_two_vars', 'name': '5. Linear Equations in Two Variables', 'subtitle': 'Graphical Methods', 'formulas': [
        {'id': 'f1', 'title': 'General Form', 'latex': r'ax + by + c = 0', 'description': 'General form of a linear equation'}
      ]},
      {'id': 'financial_planning', 'name': '6. Financial Planning', 'subtitle': 'Taxes and Savings', 'formulas': [
        {'id': 'f1', 'title': 'Income Tax', 'latex': r'\text{Tax} = \text{Taxable Income} \times \text{Rate}', 'description': 'Basic tax calculation'}
      ]},
      {'id': 'statistics', 'name': '7. Statistics', 'subtitle': 'Data Interpretation', 'formulas': [
        {'id': 'f1', 'title': 'Mean', 'latex': r'\bar{x} = \frac{\sum x_i}{n}', 'description': 'Average of given data'}
      ]},
    ],
    'msbshse_class_9_geometry': [
      {'id': 'basic_concepts', 'name': '1. Basic Concepts in Geometry', 'subtitle': 'Points, Lines, Planes', 'formulas': [
        {'id': 'f1', 'title': 'Distance Formula (1D)', 'latex': r'd(A, B) = |x_2 - x_1|', 'description': 'Distance between two points on a number line'}
      ]},
      {'id': 'parallel_lines', 'name': '2. Parallel Lines', 'subtitle': 'Transversals and Angles', 'formulas': [
        {'id': 'f1', 'title': 'Alternate Interior Angles', 'latex': r'\angle 1 = \angle 2', 'description': 'Alternate interior angles are equal when lines are parallel'}
      ]},
      {'id': 'triangles', 'name': '3. Triangles', 'subtitle': 'Congruence and Properties', 'formulas': [
        {'id': 'f1', 'title': 'Angle Sum Property', 'latex': r'\angle A + \angle B + \angle C = 180^\circ', 'description': 'Sum of angles in a triangle'}
      ]},
      {'id': 'constructions_triangles', 'name': '4. Constructions of Triangles', 'subtitle': 'Geometric Tools', 'formulas': [
        {'id': 'f1', 'title': 'Perpendicular Bisector', 'latex': r'PA = PB', 'description': 'Any point on a perpendicular bisector is equidistant from endpoints'}
      ]},
      {'id': 'quadrilaterals', 'name': '5. Quadrilaterals', 'subtitle': 'Types and Properties', 'formulas': [
        {'id': 'f1', 'title': 'Angle Sum of Quadrilateral', 'latex': r'\sum \angle = 360^\circ', 'description': 'Sum of angles in a quadrilateral'}
      ]},
      {'id': 'circle', 'name': '6. Circle', 'subtitle': 'Chords and Arcs', 'formulas': [
        {'id': 'f1', 'title': 'Area of Circle', 'latex': r'A = \pi r^2', 'description': 'Area enclosed by a circle'}
      ]},
      {'id': 'coordinate_geometry', 'name': '7. Co-ordinate Geometry', 'subtitle': 'Distance and Graphs', 'formulas': [
        {'id': 'f1', 'title': 'Distance Formula', 'latex': r'd = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}', 'description': 'Distance between two points'}
      ]},
      {'id': 'trigonometry', 'name': '8. Trigonometry', 'subtitle': 'Ratios and Identities', 'formulas': [
        {'id': 'f1', 'title': 'Fundamental Identity', 'latex': r'\sin^2 \theta + \cos^2 \theta = 1', 'description': 'Trigonometric identity'}
      ]},
      {'id': 'surface_area_volume', 'name': '9. Surface Area and Volume', 'subtitle': '3D Shapes', 'formulas': [
        {'id': 'f1', 'title': 'Volume of Cylinder', 'latex': r'V = \pi r^2 h', 'description': 'Volume of a cylinder'}
      ]},
    ]
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
        'status': 'locked', // We handle unlocking via feature flag in UI
      };
      await chapRef.doc(chMap['id'] as String).set(chapDoc);
      
      final formRef = chapRef.doc(chMap['id'] as String).collection('formulas');
      for (var formMap in formulas) {
        await formRef.doc(formMap['id'] as String).set({
          'id': formMap['id'],
          'title': formMap['title'],
          'latex': formMap['latex'],
          'description': formMap['description'],
          'isMastered': false
        });
      }
    }
  }

  print('Done populating MSBSHSE data! Formulas and chapters added correctly.');
  exit(0);
}
