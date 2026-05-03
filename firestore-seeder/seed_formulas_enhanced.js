/**
 * Enhanced Production-Level Formula Seeder
 * Seeds comprehensive formula data across Mathematics, Physics, Chemistry, Biology
 * Includes proper audience targeting, LaTeX rendering, and multi-board support
 */

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

async function seedFormulas() {
    console.log('🔬 Seeding Production-Level Formulas...\n');

    // Define formula data organized by subject → chapter → formulas
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
                            category: 'algebraic',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_10', 'IN_cbse_11', 'IN_icse_10'],
                            examples: ['x² + 5x + 6 = 0 → x = -2, -3', '2x² - 3x - 5 = 0 → x = 2.5, -1'],
                            tags: ['algebra', 'quadratic', 'roots', 'discriminant']
                        },
                        {
                            id: 'formula_poly_002',
                            title: 'Difference of Squares',
                            latex: 'a^2 - b^2 = (a - b)(a + b)',
                            description: 'Fundamental factoring identity for difference of two squares.',
                            category: 'factorization',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_8', 'IN_cbse_9', 'IN_cbse_10'],
                            examples: ['9 - 4 = (3-2)(3+2) = 1×5', 'x² - 1 = (x-1)(x+1)'],
                            tags: ['algebra', 'factorization', 'squares']
                        },
                        {
                            id: 'formula_poly_003',
                            title: 'Perfect Square Trinomial',
                            latex: '(a \\pm b)^2 = a^2 \\pm 2ab + b^2',
                            description: 'Expansion of a binomial squared, useful for completing the square.',
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
                            category: 'factorization',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['8 + 27 = (2+3)(4-6+9) = 5×7 = 35', 'x³ + 1 = (x+1)(x²-x+1)'],
                            tags: ['algebra', 'cubes', 'factorization']
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
                            examples: ['If sin(θ)=3/5, then cos(θ)=4/5', 'Proof: sin²+cos²=(opp/hyp)²+(adj/hyp)²'],
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
                            title: 'Angle Sum Formula - Sine',
                            latex: '\\sin(A \\pm B) = \\sin A \\cos B \\pm \\cos A \\sin B',
                            description: 'Sine of sum/difference of two angles.',
                            category: 'compound-angle',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['sin(60+30) = sin90 = 1', 'sin(A-B) = sinAcosB - cosAsinB'],
                            tags: ['trigonometry', 'compound-angle', 'sum-formula']
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
                            audiences: ['IN_cbse_9', 'IN_cbse_10', 'IN_icse_9'],
                            examples: ['Object starts from rest (u=0): s = ½at²', 'If a=10m/s², t=2s: s = ½×10×4 = 20m'],
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
                            examples: ['u=0, a=10m/s², t=2s: v = 0 + 10×2 = 20m/s'],
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
                            examples: ['u=0, a=5m/s², s=20m: v² = 0 + 2×5×20 = 200 → v ≈ 14.14 m/s'],
                            tags: ['physics', 'motion', 'kinematic-equations']
                        }
                    ]
                },
                chap_02: {
                    name: 'Forces & Newton\'s Laws',
                    formulas: [
                        {
                            id: 'formula_phys_004',
                            title: 'Newton\'s Second Law',
                            latex: 'F = ma',
                            description: 'Force equals mass times acceleration. F in Newtons, m in kg, a in m/s²',
                            category: 'dynamics',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_9', 'IN_cbse_10'],
                            examples: ['m=5kg, a=2m/s² → F = 5×2 = 10N'],
                            tags: ['physics', 'force', 'newton-laws']
                        }
                    ]
                }
            }
        },
        chemistry_001: {
            name: 'Chemistry',
            chapters: {
                chap_01: {
                    name: 'Atomic Structure & Periodic Table',
                    formulas: [
                        {
                            id: 'formula_chem_001',
                            title: 'Energy of Photon',
                            latex: 'E = h\\nu = \\frac{hc}{\\lambda}',
                            description: 'Energy of electromagnetic radiation. h=Planck constant (6.626×10⁻³⁴ J·s), ν=frequency, λ=wavelength, c=speed of light',
                            category: 'quantum',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11', 'IN_cbse_12'],
                            examples: ['Visible light λ≈500nm: E = (6.626×10⁻³⁴ × 3×10⁸)/500×10⁻⁹ ≈ 3.98×10⁻¹⁹ J'],
                            tags: ['chemistry', 'quantum', 'photon', 'energy']
                        },
                        {
                            id: 'formula_chem_002',
                            title: 'Molarity Equation',
                            latex: 'M = \\frac{n}{V(L)}',
                            description: 'Molarity is moles of solute per liter of solution. M in mol/L, n in moles, V in liters',
                            category: 'solutions',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11', 'IN_cbse_12'],
                            examples: ['5 moles in 500mL (0.5L) → M = 5/0.5 = 10 M'],
                            tags: ['chemistry', 'concentration', 'solutions']
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
                            description: 'Describes allele frequencies in a population at equilibrium. p=frequency of dominant allele, q=frequency of recessive allele',
                            category: 'genetics',
                            difficulty: 'intermediate',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_12'],
                            examples: ['If p=0.7 (dominant), q=0.3 (recessive): freq of AA=0.49, Aa=0.42, aa=0.09'],
                            tags: ['biology', 'genetics', 'population', 'evolution']
                        },
                        {
                            id: 'formula_bio_002',
                            title: 'Cell Division - Mitotic Index',
                            latex: '\\text{Mitotic Index} = \\frac{\\text{# cells in mitosis}}{\\text{Total # cells}} \\times 100\\%',
                            description: 'Percentage of cells undergoing mitosis at a given time. Used to measure growth rate.',
                            category: 'cell-biology',
                            difficulty: 'easy',
                            isGeneralContent: true,
                            audiences: ['IN_cbse_11'],
                            examples: ['If 50 out of 1000 cells dividing: MI = (50/1000)×100 = 5%'],
                            tags: ['biology', 'cell-division', 'mitosis']
                        }
                    ]
                }
            }
        }
    };

    let totalFormulas = 0;

    for (const [subjectId, subjectData] of Object.entries(formulaData)) {
        console.log(`\n📚 ${subjectData.name}`);

        for (const [chapterId, chapterData] of Object.entries(subjectData.chapters)) {
            console.log(`   └─ ${chapterData.name}`);

            const chapterRef = db.collection('subjects').doc(subjectId).collection('chapters').doc(chapterId);

            // Batch operations for this chapter
            const batchSize = 100;
            let batch = db.batch();
            let operationCount = 0;

            for (const formula of chapterData.formulas) {
                const formulaRef = chapterRef.collection('formulas').doc(formula.id);
                batch.set(formulaRef, {
                    ...formula,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp()
                });

                operationCount++;
                totalFormulas++;

                // Commit batch every 100 operations
                if (operationCount === batchSize) {
                    await batch.commit();
                    batch = db.batch();
                    operationCount = 0;
                }

                console.log(`      ✓ ${formula.title}`);
            }

            // Commit remaining operations
            if (operationCount > 0) {
                await batch.commit();
            }
        }
    }

    console.log(`\n✅ Seeded ${totalFormulas} formulas successfully!\n`);
}

// Run seeder
seedFormulas().catch(err => {
    console.error('❌ Seeding failed:', err.message);
    process.exit(1);
});
