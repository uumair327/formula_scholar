const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
    throw new Error('Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.');
}

const serviceAccount = require(path.resolve(serviceAccountPath));

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
}

const db = admin.firestore();
const { buildLocalizedFields } = require('./seed_locale_helpers');

async function seedFormulas() {
    console.log('Seeding Production-Level Formulas...\n');

    const formulaData = {
        math_001: {
            name: 'Mathematics',
            chapters: {
                chap_01: {
                    name: 'Polynomials & Algebra',
                    formulas: [
                        {
                            id: 'formula_poly_001',
                            title: 'Quadratic Formula',
                            latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
                            description: 'Solves quadratic equations ax² + bx + c = 0. The discriminant (b² - 4ac) determines real/complex roots.',
                            translations: {
                                'mr-IN': {
                                    title: 'द्विघात समीकरणाचे सूत्र',
                                    description: 'द्विघात समीकरण ax² + bx + c = 0 सोडवण्यासाठी वापरले जाते. विसंगती (b² - 4ac) वास्तविक किंवा जटिल मूळ ठरवते.'
                                },
                                'ur-IN': {
                                    title: 'دو درجی مساوات کا فارمولا',
                                    description: 'دو درجی مساوات ax² + bx + c = 0 کو حل کرنے کے لیے استعمال ہوتا ہے۔ تفریق (b² - 4ac) حقیقی یا مرکب جڑوں کا تعین کرتی ہے۔'
                                },
                                'ar-IN': {
                                    title: 'صيغة المعادلة التربيعية',
                                    description: 'تُستخدم لحل المعادلات التربيعية ax² + bx + c = 0. المُميّز (b² - 4ac) يحدد الجذور الحقيقية أو المركبة.'
                                }
                            },
                            category: 'algebraic',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11', 'IN_icse_10', 'IN_msbshse_10'],
                            examples: ['x² + 5x + 6 = 0 → x = -2, -3', '2x² - 3x - 5 = 0 → x = 2.5, -1'],
                            tags: ['algebra', 'quadratic', 'roots', 'discriminant']
                        },
                        {
                            id: 'formula_poly_002',
                            title: 'Difference of Squares',
                            latex: 'a^2 - b^2 = (a - b)(a + b)',
                            description: 'Fundamental factoring identity for difference of two squares.',
                            translations: {
                                'mr-IN': { title: 'चौरसातील फरक', description: 'दोन चौरसांच्या फरकाचे सामान्य घटक विभाजन सूत्र.' },
                                'ur-IN': { title: 'فروق مربع', description: 'دو مربع کے فرق کے لیے بنیادی عامل شناخت.' },
                                'ar-IN': { title: 'فرق المربعات', description: 'هوية أساسية لتقسيم الفرق بين مربعين.' }
                            },
                            category: 'factorization',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_cbse_10', 'IN_msbshse_9'],
                            examples: ['9 - 4 = (3-2)(3+2) = 1×5', 'x² - 1 = (x-1)(x+1)'],
                            tags: ['algebra', 'factorization', 'squares']
                        },
                        {
                            id: 'formula_poly_003',
                            title: 'Perfect Square Trinomial',
                            latex: '(a \\pm b)^2 = a^2 \\pm 2ab + b^2',
                            description: 'Expansion of a binomial squared, useful for completing the square.',
                            translations: {
                                'mr-IN': { title: 'संपूर्ण चौकोन त्रिनोमिअल', description: 'दोनपदी वर्गाचा विस्तार — "कम्प्लीटिंग द स्क्वेअर" साठी उपयोगी.' },
                                'ur-IN': { title: 'مکمل مربع ثلاثی', description: 'دونوں اجزاء کے مربع کے توسیع، مربع مکمل کرنے کے لیے مفید۔' },
                                'ar-IN': { title: 'ثلاثي المربع الكامل', description: 'توسيع ثنائي الحد بالمربع، مفيد لإكمال المربع.' }
                            },
                            category: 'expansion',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_8', 'IN_cbse_9'],
                            examples: ['(x+3)² = x² + 6x + 9', '(2x-1)² = 4x² - 4x + 1'],
                            tags: ['algebra', 'binomial', 'expansion']
                        },
                        {
                            id: 'formula_poly_004',
                            title: 'Sum of Cubes',
                            latex: 'a^3 + b^3 = (a + b)(a^2 - ab + b^2)',
                            description: 'Factorization of sum of two perfect cubes.',
                            translations: {
                                'mr-IN': { title: 'घनांचा बेरीज सूत्र', description: 'दोन परिपूर्ण घनांच्या बेरीजचे घटक विभाजन.' },
                                'ur-IN': { title: 'جمع مکعب', description: 'دو مکمل مکعبوں کے مجموعے کا عامل تجزیہ۔' },
                                'ar-IN': { title: 'مجموع المكعبات', description: 'تجزئة مجموع مكعبين كاملين.' }
                            },
                            category: 'factorization',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['8 + 27 = (2+3)(4-6+9) = 5×7 = 35', 'x³ + 1 = (x+1)(x²-x+1)'],
                            tags: ['algebra', 'cubes', 'factorization']
                        },
                        {
                            id: 'formula_poly_005',
                            title: 'Difference of Cubes',
                            latex: 'a^3 - b^3 = (a - b)(a^2 + ab + b^2)',
                            description: 'Factorization of difference of two perfect cubes.',
                            translations: {
                                'mr-IN': { title: 'घनांचा फरक', description: 'दोन परिपूर्ण घनांच्या फरकाशी संबंधित घटक विभाजन.' },
                                'ur-IN': { title: 'فرق مکعب', description: 'دو مکمل مکعبوں کے فرق کا عامل تجزیہ۔' },
                                'ar-IN': { title: 'فرق المكعبات', description: 'تجزئة فرق مكعبين كاملين.' }
                            },
                            category: 'factorization',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['27 - 8 = (3-2)(9+6+4) = 1×19 = 19', 'x³ - 1 = (x-1)(x²+x+1)'],
                            tags: ['algebra', 'cubes', 'factorization']
                        },
                        {
                            id: 'formula_poly_006',
                            title: 'Cube of Binomial Sum',
                            latex: '(a+b)^3 = a^3 + 3a^2b + 3ab^2 + b^3',
                            description: 'Full expansion of the cube of a binomial sum.',
                            translations: {
                                'mr-IN': { title: 'दोनपदी समाकाचा घन', description: 'दोनपदी बेरीजाचा घनाचा पूर्ण विस्तार.' },
                                'ur-IN': { title: 'مکعب جمع ثنائي', description: 'ثنائی جمع کے مکعب کی مکمل توسیع۔' },
                                'ar-IN': { title: 'مكعب مجموع ذو حدين', description: 'التوسيع الكامل لمكعب مجموع حدين.' }
                            },
                            category: 'expansion',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['(x+2)³ = x³ + 6x² + 12x + 8'],
                            tags: ['algebra', 'binomial', 'cubes', 'expansion']
                        },
                        {
                            id: 'formula_poly_007',
                            title: 'Cube of Binomial Difference',
                            latex: '(a-b)^3 = a^3 - 3a^2b + 3ab^2 - b^3',
                            description: 'Full expansion of the cube of a binomial difference.',
                            translations: {
                                'mr-IN': { title: 'दोनपदी वियोजनेचा घन', description: 'दोनपदी वियोजनेचा घनाचा पूर्ण विस्तार.' },
                                'ur-IN': { title: 'مکعب فرق ثنائي', description: 'ثنائی فرق کے مکعب کی مکمل توسیع۔' },
                                'ar-IN': { title: 'مكعب الفرق ذو الحدين', description: 'التوسيع الكامل لمكعب الفرق بين حدين.' }
                            },
                            category: 'expansion',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['(x-1)³ = x³ - 3x² + 3x - 1'],
                            tags: ['algebra', 'binomial', 'cubes', 'expansion']
                        }
                    ]
                },
                chap_02: {
                    name: 'Trigonometry',
                    formulas: [
                        {
                            id: 'formula_trig_001',
                            title: 'Pythagorean Identity',
                            latex: '\\sin^2\\theta + \\cos^2\\theta = 1',
                            description: 'Fundamental trigonometric identity relating sine and cosine.',
                            category: 'identity',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['If sin(θ)=3/5, then cos(θ)=4/5'],
                            tags: ['trigonometry', 'identity', 'sine', 'cosine']
                        },
                        {
                            id: 'formula_trig_002',
                            title: 'Law of Sines',
                            latex: '\\frac{a}{\\sin A} = \\frac{b}{\\sin B} = \\frac{c}{\\sin C}',
                            description: 'Relates sides of a triangle to angles opposite them.',
                            category: 'triangle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11', 'IN_icse_11'],
                            examples: ['In triangle ABC: a/sinA = b/sinB = 2R (circumradius)'],
                            tags: ['trigonometry', 'triangle', 'law-of-sines']
                        },
                        {
                            id: 'formula_trig_003',
                            title: 'Law of Cosines',
                            latex: 'c^2 = a^2 + b^2 - 2ab\\cos C',
                            description: 'Relates side lengths to the cosine of an angle in a triangle.',
                            category: 'triangle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11', 'IN_icse_11'],
                            examples: ['For right triangle with C=90°: c² = a² + b² (Pythagorean)'],
                            tags: ['trigonometry', 'triangle', 'law-of-cosines']
                        },
                        {
                            id: 'formula_trig_004',
                            title: 'Angle Sum Formula - Sine',
                            latex: '\\sin(A \\pm B) = \\sin A \\cos B \\pm \\cos A \\sin B',
                            description: 'Sine of sum/difference of two angles.',
                            category: 'compound-angle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['sin(60+30) = sin90 = 1'],
                            tags: ['trigonometry', 'compound-angle', 'sum-formula']
                        },
                        {
                            id: 'formula_trig_005',
                            title: 'Angle Sum Formula - Cosine',
                            latex: '\\cos(A \\pm B) = \\cos A \\cos B \\mp \\sin A \\sin B',
                            description: 'Cosine of sum/difference of two angles.',
                            category: 'compound-angle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['cos(60+30) = cos90 = 0'],
                            tags: ['trigonometry', 'compound-angle', 'cosine']
                        },
                        {
                            id: 'formula_trig_006',
                            title: 'Double Angle Formula - Sine',
                            latex: '\\sin 2\\theta = 2\\sin\\theta\\cos\\theta',
                            description: 'Sine of double angle in terms of sine and cosine.',
                            category: 'double-angle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['sin60 = 2sin30cos30 = 2×(½)×(√3/2) = √3/2'],
                            tags: ['trigonometry', 'double-angle']
                        },
                        {
                            id: 'formula_trig_007',
                            title: 'Double Angle Formula - Cosine',
                            latex: '\\cos 2\\theta = \\cos^2\\theta - \\sin^2\\theta = 2\\cos^2\\theta - 1 = 1 - 2\\sin^2\\theta',
                            description: 'Cosine of double angle in multiple equivalent forms.',
                            category: 'double-angle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['cos60 = 2cos²30-1 = 2(3/4)-1 = ½'],
                            tags: ['trigonometry', 'double-angle', 'cosine']
                        }
                    ]
                },
                chap_04: {
                    name: 'Quadratic Equations',
                    formulas: [
                        {
                            id: 'formula_quad_001',
                            title: 'Standard Form of Quadratic',
                            latex: 'ax^2 + bx + c = 0',
                            description: 'The standard form of a quadratic equation where a ≠ 0.',
                            category: 'algebraic',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['2x² + 3x - 5 = 0, here a=2, b=3, c=-5'],
                            tags: ['algebra', 'quadratic', 'standard-form']
                        },
                        {
                            id: 'formula_quad_002',
                            title: 'Discriminant',
                            latex: 'D = b^2 - 4ac',
                            description: 'Determines the nature of roots: D > 0 (real distinct), D = 0 (equal), D < 0 (imaginary).',
                            category: 'algebraic',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['2x²+3x-5=0: D = 9+40 = 49 > 0 (real distinct roots)'],
                            tags: ['algebra', 'quadratic', 'discriminant']
                        },
                        {
                            id: 'formula_quad_003',
                            title: 'Sum of Roots',
                            latex: '\\alpha + \\beta = -\\frac{b}{a}',
                            description: 'Sum of roots equals negative coefficient of x divided by coefficient of x².',
                            category: 'algebraic',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['2x²+3x-5=0: sum = -3/2'],
                            tags: ['algebra', 'quadratic', 'roots']
                        },
                        {
                            id: 'formula_quad_004',
                            title: 'Product of Roots',
                            latex: '\\alpha \\cdot \\beta = \\frac{c}{a}',
                            description: 'Product of roots equals constant term divided by coefficient of x².',
                            category: 'algebraic',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['2x²+3x-5=0: product = -5/2'],
                            tags: ['algebra', 'quadratic', 'roots']
                        },
                        {
                            id: 'formula_quad_005',
                            title: 'Forming Quadratic from Roots',
                            latex: 'x^2 - (\\alpha + \\beta)x + \\alpha\\beta = 0',
                            description: 'Construct a quadratic equation given its roots α and β.',
                            category: 'algebraic',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['Roots 2,3: x² - 5x + 6 = 0'],
                            tags: ['algebra', 'quadratic', 'roots']
                        }
                    ]
                },
                chap_05: {
                    name: 'Coordinate Geometry',
                    formulas: [
                        {
                            id: 'formula_coord_001',
                            title: 'Distance Formula',
                            latex: 'd = \\sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}',
                            description: 'Calculates the distance between two points in a plane.',
                            category: 'geometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['(0,0) to (3,4): d = √(9+16) = 5'],
                            tags: ['geometry', 'coordinate', 'distance']
                        },
                        {
                            id: 'formula_coord_002',
                            title: 'Section Formula',
                            latex: 'P = \\left(\\frac{mx_2+nx_1}{m+n}, \\frac{my_2+ny_1}{m+n}\\right)',
                            description: 'Point dividing a line segment internally in ratio m:n.',
                            category: 'geometry',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['(1,2) to (7,8) in ratio 1:2: P = (3,4)'],
                            tags: ['geometry', 'coordinate', 'section-formula']
                        },
                        {
                            id: 'formula_coord_003',
                            title: 'Midpoint Formula',
                            latex: 'M = \\left(\\frac{x_1+x_2}{2}, \\frac{y_1+y_2}{2}\\right)',
                            description: 'Midpoint of a line segment connecting two points.',
                            category: 'geometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['(0,0) to (6,8): M = (3,4)'],
                            tags: ['geometry', 'coordinate', 'midpoint']
                        },
                        {
                            id: 'formula_coord_004',
                            title: 'Area of Triangle (Coordinates)',
                            latex: 'A = \\frac{1}{2}|x_1(y_2-y_3) + x_2(y_3-y_1) + x_3(y_1-y_2)|',
                            description: 'Area of triangle given coordinates of three vertices.',
                            category: 'geometry',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['(0,0), (4,0), (0,3): A = ½|0+12+0| = 6 sq units'],
                            tags: ['geometry', 'coordinate', 'area', 'triangle']
                        },
                        {
                            id: 'formula_coord_005',
                            title: 'Slope of a Line',
                            latex: 'm = \\frac{y_2 - y_1}{x_2 - x_1} = \\tan\\theta',
                            description: 'Slope measures steepness and direction of a line.',
                            category: 'geometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['(1,2) to (4,8): m = 6/3 = 2'],
                            tags: ['geometry', 'coordinate', 'slope']
                        }
                    ]
                },
                chap_03: {
                    name: 'Triangles',
                    formulas: [
                        {
                            id: 'formula_tri_001',
                            title: 'Pythagorean Theorem',
                            latex: 'c^2 = a^2 + b^2',
                            description: 'In a right triangle, the square of the hypotenuse equals the sum of squares of the other two sides.',
                            category: 'geometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['3²+4²=5²=25', 'If a=6, b=8, then c=10'],
                            tags: ['geometry', 'triangle', 'pythagorean']
                        },
                        {
                            id: 'formula_tri_002',
                            title: 'Area of Triangle',
                            latex: 'A = \\frac{1}{2} \\times b \\times h',
                            description: 'Area equals half of base times height for any triangle.',
                            category: 'geometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['b=10cm, h=5cm: A = ½×10×5 = 25cm²'],
                            tags: ['geometry', 'triangle', 'area']
                        },
                        {
                            id: 'formula_tri_003',
                            title: "Heron's Formula",
                            latex: 'A = \\sqrt{s(s-a)(s-b)(s-c)}',
                            description: 'Area of a triangle using semi-perimeter s = (a+b+c)/2 when all sides are known.',
                            category: 'geometry',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Sides 3,4,5: s=6, A=√(6×3×2×1)=√36=6'],
                            tags: ['geometry', 'triangle', 'heron', 'area']
                        },
                        {
                            id: 'formula_tri_004',
                            title: 'Angle Sum of Triangle',
                            latex: '\\angle A + \\angle B + \\angle C = 180\\degree',
                            description: 'The sum of all interior angles of any triangle is always 180 degrees.',
                            category: 'geometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['If ∠A=50°, ∠B=60°, then ∠C=70°'],
                            tags: ['geometry', 'triangle', 'angles']
                        },
                        {
                            id: 'formula_tri_005',
                            title: 'Triangle Congruence - SSS',
                            latex: '\\triangle ABC \\cong \\triangle DEF \\text{ if } AB=DE, BC=EF, CA=FD',
                            description: 'Side-Side-Side congruence: triangles are congruent if all three sides match.',
                            category: 'geometry',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['Two triangles with sides 3,4,5 are congruent by SSS'],
                            tags: ['geometry', 'triangle', 'congruence']
                        },
                        {
                            id: 'formula_tri_006',
                            title: 'Triangle Similarity - AA',
                            latex: '\\triangle ABC \\sim \\triangle DEF \\text{ if } \\angle A=\\angle D, \\angle B=\\angle E',
                            description: 'Angle-Angle similarity: triangles are similar if two angles match.',
                            category: 'geometry',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['If two angles match, third automatically matches: AA→AAA'],
                            tags: ['geometry', 'triangle', 'similarity']
                        }
                    ]
                },
                chap_06: {
                    name: 'Statistics',
                    formulas: [
                        {
                            id: 'formula_stat_001',
                            title: 'Mean (Average)',
                            latex: '\\bar{x} = \\frac{\\sum_{i=1}^{n} x_i}{n}',
                            description: 'Arithmetic mean equals sum of all observations divided by number of observations.',
                            category: 'statistics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Data: 2,4,6,8,10 → mean = 30/5 = 6'],
                            tags: ['statistics', 'mean', 'average']
                        },
                        {
                            id: 'formula_stat_002',
                            title: 'Median (Odd n)',
                            latex: '\\text{Median} = x_{(n+1)/2}',
                            description: 'For odd number of observations, median is the middle value when sorted.',
                            category: 'statistics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Data: 3,5,7,9,11 → n=5 → median = 7 (3rd value)'],
                            tags: ['statistics', 'median']
                        },
                        {
                            id: 'formula_stat_003',
                            title: 'Median (Even n)',
                            latex: '\\text{Median} = \\frac{x_{n/2} + x_{(n/2)+1}}{2}',
                            description: 'For even number of observations, median is average of two middle values.',
                            category: 'statistics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Data: 2,4,6,8 → median = (4+6)/2 = 5'],
                            tags: ['statistics', 'median']
                        },
                        {
                            id: 'formula_stat_004',
                            title: 'Mode',
                            latex: '\\text{Mode} = \\text{value with highest frequency}',
                            description: 'Mode is the value that appears most frequently in a data set.',
                            category: 'statistics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Data: 1,2,2,2,3,4 → mode = 2'],
                            tags: ['statistics', 'mode']
                        },
                        {
                            id: 'formula_stat_005',
                            title: 'Range',
                            latex: 'R = x_{max} - x_{min}',
                            description: 'Range is the difference between the maximum and minimum values.',
                            category: 'statistics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Data: 10,20,30,40,50 → range = 50-10 = 40'],
                            tags: ['statistics', 'range']
                        },
                        {
                            id: 'formula_stat_006',
                            title: 'Standard Deviation',
                            latex: '\\sigma = \\sqrt{\\frac{\\sum (x_i - \\bar{x})^2}{n}}',
                            description: 'Standard deviation measures the spread of data around the mean.',
                            category: 'statistics',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Data: 2,4,6 → mean=4, σ=√((4+0+4)/3) = √(8/3) ≈ 1.63'],
                            tags: ['statistics', 'standard-deviation', 'spread']
                        }
                    ]
                },
                chap_07: {
                    name: 'Probability',
                    formulas: [
                        {
                            id: 'formula_prob_001',
                            title: 'Classical Probability',
                            latex: 'P(E) = \\frac{\\text{Number of favorable outcomes}}{\\text{Total number of outcomes}}',
                            description: 'Probability of an event equals favorable outcomes divided by total possible outcomes.',
                            category: 'probability',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Coin toss: P(heads) = 1/2', 'Die roll: P(6) = 1/6'],
                            tags: ['probability', 'classical']
                        },
                        {
                            id: 'formula_prob_002',
                            title: 'Probability Range',
                            latex: '0 \\leq P(E) \\leq 1',
                            description: 'Probability of any event is always between 0 (impossible) and 1 (certain).',
                            category: 'probability',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['P(sun rising) = 1', 'P(rolling 7 on die) = 0'],
                            tags: ['probability', 'axioms']
                        },
                        {
                            id: 'formula_prob_003',
                            title: 'Complement of Event',
                            latex: 'P(\\bar{E}) = 1 - P(E)',
                            description: 'Probability of an event NOT happening equals 1 minus probability of it happening.',
                            category: 'probability',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['P(not 6 on die) = 1 - 1/6 = 5/6'],
                            tags: ['probability', 'complement']
                        },
                        {
                            id: 'formula_prob_004',
                            title: 'Addition Rule (Mutually Exclusive)',
                            latex: 'P(A \\cup B) = P(A) + P(B)',
                            description: 'For mutually exclusive events, probability of A or B equals sum of individual probabilities.',
                            category: 'probability',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['P(2 or 5 on die) = 1/6 + 1/6 = 1/3'],
                            tags: ['probability', 'addition-rule']
                        },
                        {
                            id: 'formula_prob_005',
                            title: 'Addition Rule (General)',
                            latex: 'P(A \\cup B) = P(A) + P(B) - P(A \\cap B)',
                            description: 'For non-mutually exclusive events, subtract the overlap to avoid double counting.',
                            category: 'probability',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['P(king or heart from deck) = 4/52 + 13/52 - 1/52 = 16/52 = 4/13'],
                            tags: ['probability', 'addition-rule', 'inclusion-exclusion']
                        },
                        {
                            id: 'formula_prob_006',
                            title: 'Multiplication Rule (Independent)',
                            latex: 'P(A \\cap B) = P(A) \\times P(B)',
                            description: 'For independent events, probability of both A and B equals product of their probabilities.',
                            category: 'probability',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['P(heads twice) = ½ × ½ = ¼'],
                            tags: ['probability', 'multiplication-rule', 'independent']
                        }
                    ]
                }
            }
        },
        physics_001: {
            name: 'Physics',
            chapters: {
                chap_01: {
                    name: 'Motion & Kinematics',
                    formulas: [
                        {
                            id: 'formula_phys_001',
                            title: 'Equation of Motion - Displacement',
                            latex: 's = ut + \\frac{1}{2}at^2',
                            description: 'Displacement under constant acceleration. u=initial velocity, a=acceleration, t=time',
                            category: 'kinematics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10', 'IN_icse_9', 'IN_msbshse_9'],
                            examples: ['u=0, a=10m/s², t=2s: s = ½×10×4 = 20m'],
                            tags: ['physics', 'motion', 'kinematics', 'displacement']
                        },
                        {
                            id: 'formula_phys_002',
                            title: 'Equation of Motion - Velocity',
                            latex: 'v = u + at',
                            description: 'Final velocity under constant acceleration.',
                            category: 'kinematics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['u=0, a=10m/s², t=2s: v = 20m/s'],
                            tags: ['physics', 'motion', 'velocity']
                        },
                        {
                            id: 'formula_phys_003',
                            title: 'Third Equation of Motion',
                            latex: 'v^2 = u^2 + 2as',
                            description: 'Relates velocity, acceleration, and displacement without time.',
                            category: 'kinematics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['u=0, a=5m/s², s=20m: v² = 200 → v ≈ 14.14 m/s'],
                            tags: ['physics', 'motion', 'kinematic-equations']
                        },
                        {
                            id: 'formula_phys_004',
                            title: 'Average Velocity',
                            latex: 'v_{avg} = \\frac{u + v}{2}',
                            description: 'Average of initial and final velocity under uniform acceleration.',
                            category: 'kinematics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['u=0, v=20: v_avg = 10 m/s'],
                            tags: ['physics', 'motion', 'velocity']
                        },
                        {
                            id: 'formula_phys_005',
                            title: 'Relative Velocity',
                            latex: 'v_{AB} = v_A - v_B',
                            description: 'Relative velocity of object A with respect to object B.',
                            category: 'kinematics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Car A at 60km/h, Car B at 40km/h same direction: V_AB = 20km/h'],
                            tags: ['physics', 'motion', 'relative-velocity']
                        }
                    ]
                },
                chap_02: {
                    name: 'Forces & Newton\'s Laws',
                    formulas: [
                        {
                            id: 'formula_phys_006',
                            title: 'Newton\'s Second Law',
                            latex: 'F = ma',
                            description: 'Force equals mass times acceleration. F in Newtons, m in kg, a in m/s²',
                            category: 'dynamics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10', 'IN_msbshse_9'],
                            examples: ['m=5kg, a=2m/s² → F = 5×2 = 10N'],
                            tags: ['physics', 'force', 'newton-laws']
                        },
                        {
                            id: 'formula_phys_007',
                            title: 'Momentum',
                            latex: 'p = mv',
                            description: 'Momentum is the product of mass and velocity.',
                            category: 'dynamics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['m=10kg, v=5m/s → p = 50 kg·m/s'],
                            tags: ['physics', 'momentum']
                        },
                        {
                            id: 'formula_phys_008',
                            title: 'Impulse',
                            latex: 'J = F \\cdot \\Delta t = \\Delta p',
                            description: 'Impulse equals force times time, equals change in momentum.',
                            category: 'dynamics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['F=10N, t=2s → J = 20 N·s = Δp'],
                            tags: ['physics', 'impulse', 'momentum']
                        },
                        {
                            id: 'formula_phys_009',
                            title: 'Conservation of Momentum',
                            latex: 'm_1u_1 + m_2u_2 = m_1v_1 + m_2v_2',
                            description: 'Total momentum before = total momentum after in isolated systems.',
                            category: 'dynamics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['2kg at 3m/s hits 1kg at rest: 2×3 = 2×1 + 1×4 → 6 = 6 ✓'],
                            tags: ['physics', 'momentum', 'conservation']
                        },
                        {
                            id: 'formula_phys_010',
                            title: 'Force of Friction',
                            latex: 'f = \\mu N',
                            description: 'Frictional force equals coefficient of friction times normal reaction.',
                            category: 'dynamics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['μ=0.5, N=20N → f = 10N'],
                            tags: ['physics', 'friction', 'force']
                        },
                        {
                            id: 'formula_phys_011',
                            title: 'Newton\'s Law of Gravitation',
                            latex: 'F = G\\frac{m_1 m_2}{r^2}',
                            description: 'Gravitational force between two masses is proportional to product of masses and inversely proportional to square of distance.',
                            category: 'gravitation',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['G=6.67×10⁻¹¹, m₁=m₂=1kg, r=1m: F=6.67×10⁻¹¹ N'],
                            tags: ['physics', 'gravitation', 'force']
                        }
                    ]
                },
                chap_03: {
                    name: 'Gravitation',
                    formulas: [
                        {
                            id: 'formula_grav_001',
                            title: 'Acceleration Due to Gravity',
                            latex: 'g = \\frac{GM}{R^2}',
                            description: 'Gravity at surface of a planet depends on its mass and radius.',
                            category: 'gravitation',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['Earth: M=6×10²⁴kg, R=6.4×10⁶m → g=9.8 m/s²'],
                            tags: ['physics', 'gravitation', 'gravity']
                        },
                        {
                            id: 'formula_grav_002',
                            title: 'Weight',
                            latex: 'W = mg',
                            description: 'Weight is mass times acceleration due to gravity.',
                            category: 'gravitation',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['m=70kg, g=9.8 → W = 686 N'],
                            tags: ['physics', 'gravitation', 'weight']
                        },
                        {
                            id: 'formula_grav_003',
                            title: 'Gravitational Potential Energy',
                            latex: 'U = -\\frac{GMm}{r}',
                            description: 'Gravitational potential energy of two masses separated by distance r.',
                            category: 'gravitation',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Near Earth surface: U = mgh (approximation)'],
                            tags: ['physics', 'gravitation', 'potential-energy']
                        },
                        {
                            id: 'formula_grav_004',
                            title: 'Escape Velocity',
                            latex: 'v_e = \\sqrt{\\frac{2GM}{R}}',
                            description: 'Minimum velocity needed to escape a planet\'s gravitational pull.',
                            category: 'gravitation',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Earth: v_e = √(2×6.67×10⁻¹¹×6×10²⁴/6.4×10⁶) ≈ 11.2 km/s'],
                            tags: ['physics', 'gravitation', 'escape-velocity']
                        },
                        {
                            id: 'formula_grav_005',
                            title: 'Kepler\'s Third Law',
                            latex: 'T^2 \\propto a^3',
                            description: 'Square of orbital period is proportional to cube of semi-major axis.',
                            category: 'gravitation',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Earth: T=1yr, a=1AU. Mars: T≈1.88yr, a≈1.52AU'],
                            tags: ['physics', 'gravitation', 'kepler', 'orbital']
                        }
                    ]
                },
                chap_04: {
                    name: 'Work, Energy & Power',
                    formulas: [
                        {
                            id: 'formula_work_001',
                            title: 'Work Done',
                            latex: 'W = F \\cdot d \\cos\\theta',
                            description: 'Work equals force times displacement times cosine of angle between them.',
                            category: 'work-energy',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['F=10N, d=5m, θ=0°: W=50J'],
                            tags: ['physics', 'work', 'energy']
                        },
                        {
                            id: 'formula_work_002',
                            title: 'Kinetic Energy',
                            latex: 'KE = \\frac{1}{2}mv^2',
                            description: 'Energy of a body in motion depends on mass and square of velocity.',
                            category: 'work-energy',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['m=10kg, v=5m/s: KE = ½×10×25 = 125J'],
                            tags: ['physics', 'energy', 'kinetic-energy']
                        },
                        {
                            id: 'formula_work_003',
                            title: 'Potential Energy',
                            latex: 'PE = mgh',
                            description: 'Energy due to position in a gravitational field.',
                            category: 'work-energy',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['m=5kg, h=10m: PE = 5×9.8×10 = 490J'],
                            tags: ['physics', 'energy', 'potential-energy']
                        },
                        {
                            id: 'formula_work_004',
                            title: 'Power',
                            latex: 'P = \\frac{W}{t}',
                            description: 'Rate of doing work. Measured in Watts (J/s).',
                            category: 'work-energy',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['W=100J, t=5s: P = 20W'],
                            tags: ['physics', 'power']
                        },
                        {
                            id: 'formula_work_005',
                            title: 'Conservation of Mechanical Energy',
                            latex: 'KE_i + PE_i = KE_f + PE_f',
                            description: 'Total mechanical energy remains constant in the absence of non-conservative forces.',
                            category: 'work-energy',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Object dropped from height h: ½mv² = mgh at impact'],
                            tags: ['physics', 'energy', 'conservation']
                        }
                    ]
                },
                chap_05: {
                    name: 'Sound',
                    formulas: [
                        {
                            id: 'formula_sound_001',
                            title: 'Speed of Sound',
                            latex: 'v = f\\lambda',
                            description: 'Speed of sound equals frequency times wavelength.',
                            category: 'waves',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['f=440Hz, λ=0.78m: v=440×0.78≈343 m/s'],
                            tags: ['physics', 'sound', 'waves', 'speed']
                        },
                        {
                            id: 'formula_sound_002',
                            title: 'Frequency and Period',
                            latex: 'f = \\frac{1}{T}',
                            description: 'Frequency is the reciprocal of the time period of a wave.',
                            category: 'waves',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['T=0.02s → f=50Hz'],
                            tags: ['physics', 'sound', 'frequency', 'period']
                        },
                        {
                            id: 'formula_sound_003',
                            title: 'Amplitude and Loudness',
                            latex: 'L \\propto A^2',
                            description: 'Loudness (intensity) of sound is proportional to the square of amplitude.',
                            category: 'waves',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['Doubling amplitude → 4× louder'],
                            tags: ['physics', 'sound', 'amplitude', 'loudness']
                        },
                        {
                            id: 'formula_sound_004',
                            title: 'Echo Distance',
                            latex: 'd = \\frac{v \\times t}{2}',
                            description: 'Distance to reflecting surface equals speed times total time divided by 2.',
                            category: 'waves',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['v=343m/s, t=0.5s: d=343×0.5/2=85.75m'],
                            tags: ['physics', 'sound', 'echo']
                        },
                        {
                            id: 'formula_sound_005',
                            title: 'Doppler Effect (Approaching)',
                            latex: "f' = f\\frac{v}{v - v_s}",
                            description: 'Observed frequency when source moves toward stationary observer. v=speed of sound, vs=source speed.',
                            category: 'waves',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['f=500Hz, vs=30m/s, v=343m/s: f\' = 500×343/(343-30) ≈ 548Hz'],
                            tags: ['physics', 'sound', 'doppler-effect']
                        },
                        {
                            id: 'formula_sound_006',
                            title: 'Doppler Effect (Receding)',
                            latex: "f' = f\\frac{v}{v + v_s}",
                            description: 'Observed frequency when source moves away from stationary observer.',
                            category: 'waves',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['f=500Hz, vs=30m/s: f\' = 500×343/(343+30) ≈ 460Hz'],
                            tags: ['physics', 'sound', 'doppler-effect']
                        }
                    ]
                }
            }
        },
        chemistry_001: {
            name: 'Chemistry',
            chapters: {
                chap_01: {
                    name: 'Atomic Structure & Quantum',
                    formulas: [
                        {
                            id: 'formula_chem_001',
                            title: 'Energy of Photon',
                            latex: 'E = h\\nu = \\frac{hc}{\\lambda}',
                            description: 'Energy of electromagnetic radiation. h=Planck constant (6.626×10⁻³⁴ J·s), ν=frequency, λ=wavelength.',
                            category: 'quantum',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11', 'IN_cbse_12'],
                            examples: ['λ≈500nm: E = (6.626×10⁻³⁴×3×10⁸)/500×10⁻⁹ ≈ 3.98×10⁻¹⁹ J'],
                            tags: ['chemistry', 'quantum', 'photon', 'energy']
                        },
                        {
                            id: 'formula_chem_002',
                            title: 'de Broglie Wavelength',
                            latex: '\\lambda = \\frac{h}{mv}',
                            description: 'Wavelength of a particle with mass m moving at velocity v.',
                            category: 'quantum',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Electron: m=9.1×10⁻³¹kg, v=10⁶m/s: λ≈7.3×10⁻¹⁰m'],
                            tags: ['chemistry', 'quantum', 'de-broglie']
                        },
                        {
                            id: 'formula_chem_003',
                            title: 'Bohr\'s Radius',
                            latex: 'r_n = 0.529 \\times n^2 \\text{ Å}',
                            description: 'Radius of nth orbit in hydrogen atom.',
                            category: 'atomic-structure',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['n=1: r₁=0.529Å, n=2: r₂=2.116Å'],
                            tags: ['chemistry', 'atomic-structure', 'bohr']
                        },
                        {
                            id: 'formula_chem_004',
                            title: 'Energy of Hydrogen Orbit',
                            latex: 'E_n = -\\frac{13.6}{n^2} \\text{ eV}',
                            description: 'Energy of electron in nth orbit of hydrogen atom.',
                            category: 'atomic-structure',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['n=1: E₁=-13.6eV, n=2: E₂=-3.4eV'],
                            tags: ['chemistry', 'atomic-structure', 'energy-levels']
                        },
                        {
                            id: 'formula_chem_005',
                            title: 'Rydberg Formula',
                            latex: '\\frac{1}{\\lambda} = R_H\\left(\\frac{1}{n_1^2} - \\frac{1}{n_2^2}\\right)',
                            description: 'Wavelength of spectral lines in hydrogen spectrum.',
                            category: 'atomic-structure',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Balmer series: n₁=2, n₂=3,4,5... gives visible lines'],
                            tags: ['chemistry', 'atomic-structure', 'spectrum']
                        }
                    ]
                },
                chap_02: {
                    name: 'Chemical Bonding',
                    formulas: [
                        {
                            id: 'formula_cb_001',
                            title: 'Octet Rule',
                            latex: '\\text{Atoms gain/lose/share e}^- \\text{ to achieve } 1s^2 2s^2 2p^6',
                            description: 'Atoms tend to bond to achieve 8 valence electrons (noble gas configuration).',
                            category: 'bonding',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Na (2,8,1) loses 1e⁻ → Na⁺ (2,8) octet'],
                            tags: ['chemistry', 'bonding', 'octet-rule']
                        },
                        {
                            id: 'formula_cb_002',
                            title: 'Ionic Bond Energy',
                            latex: 'E \\propto \\frac{q_1 q_2}{r}',
                            description: 'Ionic bond energy is proportional to product of charges and inversely proportional to distance.',
                            category: 'bonding',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Na⁺Cl⁻: high lattice energy due to +1 and -1 charges'],
                            tags: ['chemistry', 'bonding', 'ionic']
                        },
                        {
                            id: 'formula_cb_003',
                            title: 'Covalent Bond Order',
                            latex: '\\text{Bond Order} = \\frac{\\text{ bonding e}^- - \\text{ antibonding e}^-}{2}',
                            description: 'Bond order indicates bond strength and stability. Higher value = stronger bond.',
                            category: 'bonding',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['O₂: BO = (10-6)/2 = 2 (double bond)'],
                            tags: ['chemistry', 'bonding', 'covalent', 'bond-order']
                        },
                        {
                            id: 'formula_cb_004',
                            title: 'Electronegativity Difference',
                            latex: '\\Delta EN = |EN_A - EN_B|',
                            description: 'Difference in electronegativity determines bond type: >1.7 ionic, <1.7 covalent.',
                            category: 'bonding',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Na(0.9) - Cl(3.0): ΔEN=2.1 → ionic bond'],
                            tags: ['chemistry', 'bonding', 'electronegativity']
                        },
                        {
                            id: 'formula_cb_005',
                            title: 'Lewis Dot Structure Rule',
                            latex: 'V + S - C = N',
                            description: 'Total valence electrons (V) + subtracted (S) - charge (C) = needed electrons (N) for Lewis structure.',
                            category: 'bonding',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['CO₂: V=4+12=16, N=4+16=20, 16-20=-4 → 2 double bonds'],
                            tags: ['chemistry', 'bonding', 'lewis-structures']
                        }
                    ]
                },
                chap_03: {
                    name: 'Periodic Table',
                    formulas: [
                        {
                            id: 'formula_pt_001',
                            title: 'Periodic Trend - Atomic Radius',
                            latex: 'r \\downarrow \\text{ across period}, r \\uparrow \\text{ down group}',
                            description: 'Atomic radius decreases left to right (increasing nuclear charge) and increases down a group (more shells).',
                            category: 'periodic-trends',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['Li>Be>B>C>N>O>F (decreases across), Li<Na<K<Rb<Cs (increases down)'],
                            tags: ['chemistry', 'periodic-table', 'atomic-radius']
                        },
                        {
                            id: 'formula_pt_002',
                            title: 'Periodic Trend - Ionization Energy',
                            latex: 'IE \\uparrow \\text{ across period}, IE \\downarrow \\text{ down group}',
                            description: 'Ionization energy increases across a period and decreases down a group.',
                            category: 'periodic-trends',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['He (2372 kJ/mol) > Ne (2080) > Ar (1520)'],
                            tags: ['chemistry', 'periodic-table', 'ionization-energy']
                        },
                        {
                            id: 'formula_pt_003',
                            title: 'Periodic Trend - Electronegativity',
                            latex: 'EN \\uparrow \\text{ across period}, EN \\downarrow \\text{ down group}',
                            description: 'Electronegativity increases left to right and decreases top to bottom.',
                            category: 'periodic-trends',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['F(4.0) > O(3.5) > N(3.0) > C(2.5)'],
                            tags: ['chemistry', 'periodic-table', 'electronegativity']
                        },
                        {
                            id: 'formula_pt_004',
                            title: 'Effective Nuclear Charge',
                            latex: 'Z_{eff} = Z - S',
                            description: 'Effective nuclear charge equals actual nuclear charge minus shielding constant.',
                            category: 'periodic-trends',
                            difficulty: 'hard',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['Li: Z=3, S≈1.7, Zeff≈1.3; F: Z=9, S≈4.8, Zeff≈4.2'],
                            tags: ['chemistry', 'periodic-table', 'nuclear-charge']
                        },
                        {
                            id: 'formula_pt_005',
                            title: 'Mendeleev\'s Periodic Law',
                            latex: '\\text{Properties} \\propto \\text{Atomic Mass (recurring pattern)}',
                            description: 'Elements arranged by atomic mass show recurring (periodic) properties.',
                            category: 'periodic-table',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['Groups have similar properties: alkali metals, halogens, noble gases'],
                            tags: ['chemistry', 'periodic-table', 'mendeleev']
                        }
                    ]
                },
                chap_04: {
                    name: 'Chemical Reactions & Stoichiometry',
                    formulas: [
                        {
                            id: 'formula_chem_006',
                            title: 'Molar Mass',
                            latex: 'M = \\frac{m}{n}',
                            description: 'Molar mass equals mass divided by number of moles.',
                            category: 'stoichiometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['5g of substance = 0.1 mol → M = 50 g/mol'],
                            tags: ['chemistry', 'moles', 'molar-mass']
                        },
                        {
                            id: 'formula_chem_007',
                            title: 'Avogadro\'s Number',
                            latex: 'N_A = 6.022 \\times 10^{23} \\text{ mol}^{-1}',
                            description: 'Number of atoms/molecules in one mole of any substance.',
                            category: 'stoichiometry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['1 mole of Carbon = 6.022×10²³ atoms = 12g'],
                            tags: ['chemistry', 'moles', 'avogadro']
                        },
                        {
                            id: 'formula_chem_008',
                            title: 'Ideal Gas Law',
                            latex: 'PV = nRT',
                            description: 'Relates pressure, volume, moles, gas constant, and temperature.',
                            category: 'gases',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['1 mol at STP: V = nRT/P = 22.4 L'],
                            tags: ['chemistry', 'gases', 'ideal-gas']
                        },
                        {
                            id: 'formula_chem_009',
                            title: 'Molarity Equation',
                            latex: 'M = \\frac{n}{V(L)}',
                            description: 'Molarity is moles of solute per liter of solution.',
                            category: 'solutions',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11', 'IN_cbse_12'],
                            examples: ['5 moles in 500mL → M = 5/0.5 = 10 M'],
                            tags: ['chemistry', 'concentration', 'solutions']
                        },
                        {
                            id: 'formula_chem_010',
                            title: 'Percentage Composition',
                            latex: '\\% \\text{ element} = \\frac{\\text{mass of element}}{\\text{molar mass}} \\times 100\\%',
                            description: 'Mass percentage of an element in a compound.',
                            category: 'stoichiometry',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['H₂O: H% = 2/18×100 = 11.11%, O% = 16/18×100 = 88.89%'],
                            tags: ['chemistry', 'stoichiometry', 'composition']
                        }
                    ]
                },
                chap_05: {
                    name: 'Acids, Bases & Salts',
                    formulas: [
                        {
                            id: 'formula_chem_011',
                            title: 'pH Scale',
                            latex: 'pH = -\\log[H^+]',
                            description: 'Negative logarithm of hydrogen ion concentration.',
                            category: 'acids-bases',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['[H⁺]=10⁻³ M: pH = 3 (acidic)'],
                            tags: ['chemistry', 'acids-bases', 'pH']
                        },
                        {
                            id: 'formula_chem_012',
                            title: 'pOH',
                            latex: 'pOH = -\\log[OH^-]',
                            description: 'Negative logarithm of hydroxide ion concentration.',
                            category: 'acids-bases',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['[OH⁻]=10⁻⁴ M: pOH = 4'],
                            tags: ['chemistry', 'acids-bases', 'pOH']
                        },
                        {
                            id: 'formula_chem_013',
                            title: 'pH + pOH Relation',
                            latex: 'pH + pOH = 14',
                            description: 'Sum of pH and pOH at 25°C always equals 14.',
                            category: 'acids-bases',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['pH=3 → pOH=11 → [OH⁻]=10⁻¹¹ M'],
                            tags: ['chemistry', 'acids-bases', 'pH', 'pOH']
                        },
                        {
                            id: 'formula_chem_014',
                            title: 'Neutralization Reaction',
                            latex: 'H^+ + OH^- \\rightarrow H_2O',
                            description: 'Hydrogen ions combine with hydroxide ions to form water.',
                            category: 'acids-bases',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['HCl + NaOH → NaCl + H₂O'],
                            tags: ['chemistry', 'acids-bases', 'neutralization']
                        }
                    ]
                }
            }
        },
        biology_001: {
            name: 'Biology',
            chapters: {
                chap_01: {
                    name: 'Cell Biology & Genetics',
                    formulas: [
                        {
                            id: 'formula_bio_001',
                            title: 'Hardy-Weinberg Equation',
                            latex: 'p^2 + 2pq + q^2 = 1',
                            description: 'Describes allele frequencies in a population at equilibrium. p=frequency of dominant allele, q=frequency of recessive allele.',
                            category: 'genetics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_12'],
                            examples: ['p=0.7, q=0.3: freq AA=0.49, Aa=0.42, aa=0.09'],
                            tags: ['biology', 'genetics', 'population', 'evolution']
                        },
                        {
                            id: 'formula_bio_002',
                            title: 'Cell Division - Mitotic Index',
                            latex: '\\text{Mitotic Index} = \\frac{\\text{# cells in mitosis}}{\\text{Total # cells}} \\times 100\\%',
                            description: 'Percentage of cells undergoing mitosis at a given time.',
                            category: 'cell-biology',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['50 out of 1000 cells dividing: MI = 5%'],
                            tags: ['biology', 'cell-division', 'mitosis']
                        },
                        {
                            id: 'formula_bio_003',
                            title: 'Cell Cycle Phases',
                            latex: 'G_1 \\rightarrow S \\rightarrow G_2 \\rightarrow M',
                            description: 'Order of cell cycle: Gap 1 → Synthesis → Gap 2 → Mitosis.',
                            category: 'cell-biology',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_11'],
                            examples: ['Interphase (G₁, S, G₂) = 90% of cycle, M phase = 10%'],
                            tags: ['biology', 'cell-division', 'cell-cycle']
                        },
                        {
                            id: 'formula_bio_004',
                            title: 'Mitosis - Diploid Result',
                            latex: '2n \\rightarrow 2n',
                            description: 'Mitosis produces two diploid daughter cells from one diploid parent (identical).',
                            category: 'cell-biology',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Human cell: 2n=46 → each daughter has 46 chromosomes'],
                            tags: ['biology', 'cell-division', 'mitosis']
                        },
                        {
                            id: 'formula_bio_005',
                            title: 'Meiosis - Haploid Result',
                            latex: '2n \\rightarrow n',
                            description: 'Meiosis reduces chromosome number by half, producing four haploid cells.',
                            category: 'cell-biology',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['Human germ cell: 2n=46 → 4 gametes each n=23'],
                            tags: ['biology', 'cell-division', 'meiosis']
                        },
                        {
                            id: 'formula_bio_006',
                            title: 'Mendel\'s Law of Segregation',
                            latex: '\\text{Alleles separate: } Aa \\rightarrow A + a',
                            description: 'Each parent contributes one allele per gene; alleles segregate during gamete formation.',
                            category: 'genetics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_12'],
                            examples: ['Punnett square: Aa×Aa gives AA:Aa:aa = 1:2:1'],
                            tags: ['biology', 'genetics', 'mendel']
                        }
                    ]
                },
                chap_02: {
                    name: 'Tissues',
                    formulas: [
                        {
                            id: 'formula_bio_007',
                            title: 'Meristematic Tissue Types',
                            latex: '\\text{Apical} + \\text{Lateral} + \\text{Intercalary}',
                            description: 'Three types of meristematic tissue responsible for plant growth.',
                            category: 'plant-tissues',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['Apical: tip growth, Lateral: girth growth, Intercalary: internode growth'],
                            tags: ['biology', 'tissues', 'meristem']
                        },
                        {
                            id: 'formula_bio_008',
                            title: 'Permanent Tissue Classification',
                            latex: '\\text{Simple} + \\text{Complex}',
                            description: 'Permanent tissues classified as Simple (one cell type) and Complex (multiple cell types).',
                            category: 'plant-tissues',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9'],
                            examples: ['Simple: parenchyma, collenchyma, sclerenchyma. Complex: xylem, phloem'],
                            tags: ['biology', 'tissues', 'plant-anatomy']
                        }
                    ]
                },
                chap_03: {
                    name: 'Life Processes',
                    formulas: [
                        {
                            id: 'formula_bio_009',
                            title: 'Photosynthesis',
                            latex: '6CO_2 + 6H_2O \\xrightarrow{\\text{sunlight}} C_6H_{12}O_6 + 6O_2',
                            description: 'Plants convert carbon dioxide and water into glucose and oxygen using sunlight.',
                            category: 'plant-physiology',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['One tree produces ~260 lbs of O₂ per year'],
                            tags: ['biology', 'photosynthesis', 'plants']
                        },
                        {
                            id: 'formula_bio_010',
                            title: 'Aerobic Respiration',
                            latex: 'C_6H_{12}O_6 + 6O_2 \\rightarrow 6CO_2 + 6H_2O + \\text{Energy}',
                            description: 'Glucose broken down in the presence of oxygen to release energy (36-38 ATP).',
                            category: 'human-physiology',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10'],
                            examples: ['1 glucose → 36-38 ATP molecules'],
                            tags: ['biology', 'respiration', 'energy']
                        },
                        {
                            id: 'formula_bio_011',
                            title: 'ATP Energy Release',
                            latex: 'ATP \\rightarrow ADP + P_i + \\text{Energy}',
                            description: 'Adenosine triphosphate releases energy (~30.6 kJ/mol) by losing a phosphate group.',
                            category: 'biochemistry',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11'],
                            examples: ['ATP hydrolysis fuels muscle contraction, active transport, and biosynthesis'],
                            tags: ['biology', 'biochemistry', 'ATP', 'energy']
                        },
                        {
                            id: 'formula_bio_012',
                            title: 'Human Heart Rate - Cardiac Output',
                            latex: 'CO = HR \\times SV',
                            description: 'Cardiac output equals heart rate times stroke volume.',
                            category: 'human-physiology',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['HR=72 bpm, SV=70mL: CO = 5040 mL/min ≈ 5 L/min'],
                            tags: ['biology', 'human-physiology', 'heart']
                        }
                    ]
                },
                chap_04: {
                    name: 'Heredity & Evolution',
                    formulas: [
                        {
                            id: 'formula_bio_013',
                            title: 'DNA Base Pairing',
                            latex: 'A = T, \\; G \\equiv C',
                            description: 'Adenine pairs with Thymine (2 H-bonds), Guanine pairs with Cytosine (3 H-bonds).',
                            category: 'genetics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_12'],
                            examples: ['DNA with 30% A has 30% T, 20% G, 20% C'],
                            tags: ['biology', 'genetics', 'DNA']
                        },
                        {
                            id: 'formula_bio_014',
                            title: 'Central Dogma of Biology',
                            latex: '\\text{DNA} \\xrightarrow{\\text{transcription}} \\text{mRNA} \\xrightarrow{\\text{translation}} \\text{Protein}',
                            description: 'Genetic information flows from DNA to RNA to protein.',
                            category: 'genetics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_12'],
                            examples: ['Gene → mRNA → amino acid chain → functional protein'],
                            tags: ['biology', 'genetics', 'central-dogma']
                        },
                        {
                            id: 'formula_bio_015',
                            title: 'Chargaff\'s Rule',
                            latex: '\\%A = \\%T, \\; \\%G = \\%C, \\; \\%A + \\%G = \\%T + \\%C = 50\\%',
                            description: 'In double-stranded DNA, purine bases equal pyrimidine bases.',
                            category: 'genetics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_12'],
                            examples: ['If A=22%, then T=22%, G=C=28%'],
                            tags: ['biology', 'genetics', 'DNA', 'chargaff']
                        }
                    ]
                }
            }
        }
    };

    let totalFormulas = 0;
    const flatFormulas = [];

    for (const [subjectId, subjectData] of Object.entries(formulaData)) {
        console.log(`\n${subjectData.name}`);

        for (const [chapterId, chapterData] of Object.entries(subjectData.chapters)) {
            console.log(`   ${chapterData.name}`);

            const chapterRef = db.collection('subjects').doc(subjectId).collection('chapters').doc(chapterId);

            const batchSize = 100;
            let batch = db.batch();
            let operationCount = 0;

            for (const formula of chapterData.formulas) {
                const formulaRef = chapterRef.collection('formulas').doc(formula.id);
                batch.set(formulaRef, {
                    ...formula,
                    localized: buildLocalizedFields(formula),
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp()
                });

                flatFormulas.push({
                    id: formula.id,
                    title: formula.title,
                    topic: chapterData.name,
                    published: true
                });

                operationCount++;
                totalFormulas++;

                if (operationCount === batchSize) {
                    await batch.commit();
                    batch = db.batch();
                    operationCount = 0;
                }

                console.log(`      \u2713 ${formula.title}`);
            }

            if (operationCount > 0) {
                await batch.commit();
            }
        }
    }

    console.log(`\nWriting ${flatFormulas.length} formulas to flat collection...`);
    const flatBatch = db.batch();
    for (const entry of flatFormulas) {
        const ref = db.collection('formulas').doc(entry.id);
        flatBatch.set(ref, {
            id: entry.id,
            title: entry.title,
            topic: entry.topic,
            published: entry.published,
            localized: buildLocalizedFields(entry),
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        }, { merge: true });
    }
    await flatBatch.commit();

    console.log(`Seeded ${totalFormulas} formulas successfully!\n`);
}

seedFormulas().catch(err => {
    console.error('Seeding failed:', err.message);
    process.exit(1);
});
