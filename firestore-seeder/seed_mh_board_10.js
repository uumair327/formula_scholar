const path = require('path');
const admin = require('firebase-admin');

const serviceAccountPath = process.argv[2] || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

if (!serviceAccountPath) {
  throw new Error(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.'
  );
}

const serviceAccount = require(path.resolve(serviceAccountPath));

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

const db = admin.firestore();
const { buildLocalizedSubjectFields, buildLocalizedChapterFields } = require('./seed_locale_helpers');

async function seedMhBoard10() {
  console.log('Seeding Maharashtra Board 10th Standard Data...');

  const batch = db.batch();

  const masteryTools = [
    {
      id: 'practice_quiz',
      label: 'Practice Quiz',
      iconName: 'helpCircle',
      category: 'assessment',
      isEnabled: true,
      displayOrder: 2,
      routeName: 'practice',
    },
    {
      id: 'flashcards',
      label: 'Flashcards',
      iconName: 'creditCard',
      category: 'quick_reference',
      isEnabled: true,
      displayOrder: 2,
      routeName: 'flashcards',
    },
    {
      id: 'cheat_sheets',
      label: 'Cheat Sheets',
      iconName: 'fileText',
      category: 'quick_reference',
      isEnabled: true,
      displayOrder: 3,
      routeName: 'cheatSheet',
    },
    {
      id: 'visualizer_3d',
      label: 'Visualizer 3D',
      iconName: 'box',
      category: 'visual_learning',
      isEnabled: true,
      displayOrder: 4,
    },
  ];

  function addMasteryTools(subjectRef) {
    for (const tool of masteryTools) {
      batch.set(subjectRef.collection('mastery_tools').doc(tool.id), tool);
    }
  }

  const subjects = [
    {
      id: 'mh_algebra_10',
      data: {
        name: 'Algebra',
        description: 'Maharashtra Board Class 10 Algebra',
        category: 'Mathematics',
        iconName: 'calculator',
        colorValue: 0xFF3B82F6,
        badgeText: 'MH Board 10th',
        subtitle: 'Linear Equations, Quadratic Equations & More.',
        unitCount: 6,
        formulaCount: 6,
        isFeatured: true,
        boardId: 'msbshse',
        gradeId: 'class_10',
        audiences: ['msbshse_10', 'IN_msbshse_10', 'msbshse_class_10'],
        isGeneralContent: false,
        translations: {
          'mr-IN': {
            name: 'बीजगणित',
            description: 'महाराष्ट्र बोर्ड इयत्ता १० वी बीजगणित',
            subtitle: 'रेषीय समीकरणे, वर्गसमीकरणे आणि बरेच काही.',
            badgeText: 'महाराष्ट्र बोर्ड इयत्ता १० वी'
          },
          'ur-IN': {
            name: 'الجبرا',
            description: 'مہاراشٹر بورڈ دہم الجبرا',
            subtitle: 'دو متغیر خطی مساواتیں، دو درجی مساواتیں اور مزید۔',
            badgeText: 'مہاراشٹر بورڈ دہم'
          },
          'ar-IN': {
            name: 'الجبر',
            description: 'الجبر للصف العاشر لمجلس ماهاراشترا',
            subtitle: 'المعادلات الخطية والمعادلات التربيعية والمزيد.',
            badgeText: 'مجلس ماهاراشترا دہم'
          }
        }
      },
      chapters: [
        {
          id: 'chap_01',
          name: 'Linear Equations in Two Variables',
          translations: {
            'mr-IN': { name: 'दोन चलांमधील रेषीय समीकरणे' },
            'ur-IN': { name: 'دو متغیر خطی مساواتیں' },
            'ar-IN': { name: 'المعادلات الخطية في متغيرين' }
          }
        },
        {
          id: 'chap_02',
          name: 'Quadratic Equations',
          translations: {
            'mr-IN': { name: 'वर्गसमीकरणे' },
            'ur-IN': { name: 'دو درجی مساواتیں' },
            'ar-IN': { name: 'المعادلات التربيعية' }
          }
        },
        {
          id: 'chap_03',
          name: 'Arithmetic Progression',
          translations: {
            'mr-IN': { name: 'अंकगणिती श्रेढी' },
            'ur-IN': { name: 'حسابی تصاعد' },
            'ar-IN': { name: 'المتوالية الحسابية' }
          }
        },
        {
          id: 'chap_04',
          name: 'Financial Planning',
          translations: {
            'mr-IN': { name: 'अर्थनियोजन' },
            'ur-IN': { name: 'مالیاتی منصوبہ بندی' },
            'ar-IN': { name: 'التخطيط المالي' }
          }
        },
        {
          id: 'chap_05',
          name: 'Probability',
          translations: {
            'mr-IN': { name: 'संभाव्यता' },
            'ur-IN': { name: 'احتمال' },
            'ar-IN': { name: 'الاحتمالات' }
          }
        },
        {
          id: 'chap_06',
          name: 'Statistics',
          translations: {
            'mr-IN': { name: 'सांख्यिकी' },
            'ur-IN': { name: 'شماریات' },
            'ar-IN': { name: 'الإحصاء' }
          }
        }
      ]
    },
    {
      id: 'mh_geometry_10',
      data: {
        name: 'Geometry',
        description: 'Maharashtra Board Class 10 Geometry',
        category: 'Mathematics',
        iconName: 'triangle',
        colorValue: 0xFF10B981,
        badgeText: 'MH Board 10th',
        subtitle: 'Similarity, Pythagoras, Trigonometry & More.',
        unitCount: 7,
        formulaCount: 7,
        isFeatured: true,
        boardId: 'msbshse',
        gradeId: 'class_10',
        audiences: ['msbshse_10', 'IN_msbshse_10', 'msbshse_class_10'],
        isGeneralContent: false,
        translations: {
          'mr-IN': {
            name: 'भूमिती',
            description: 'महाराष्ट्र बोर्ड इयत्ता १० वी भूमिती',
            subtitle: 'समरूपता, पायथागोरसचे प्रमेय, त्रिकोणमिती आणि बरेच काही.',
            badgeText: 'महाराष्ट्र बोर्ड इयत्ता १० वी'
          },
          'ur-IN': {
            name: 'ہندسیہ',
            description: 'مہاراشٹر بورڈ دہم ہندسیہ',
            subtitle: 'شبیہہ، فیثاغورث، علم مثلث اور مزید۔',
            badgeText: 'مہاراشٹر بورڈ دہم'
          },
          'ar-IN': {
            name: 'الهندسة',
            description: 'الهندسة للصف العاشر لمجلس ماهاراشترا',
            subtitle: 'التشابه، مبرهنة فيثاغورس، علم المثلثات والمزيد.',
            badgeText: 'مجلس ماهاراشترا دہم'
          }
        }
      },
      chapters: [
        {
          id: 'chap_01',
          name: 'Similarity',
          translations: {
            'mr-IN': { name: 'समरूपता' },
            'ur-IN': { name: 'شبیہہ' },
            'ar-IN': { name: 'التشابه' }
          }
        },
        {
          id: 'chap_02',
          name: 'Pythagoras Theorem',
          translations: {
            'mr-IN': { name: 'पायथागोरसचे प्रमेय' },
            'ur-IN': { name: 'مسئلہ فیثागोरस' },
            'ar-IN': { name: 'مبرهنة فيثاغورس' }
          }
        },
        {
          id: 'chap_03',
          name: 'Circle',
          translations: {
            'mr-IN': { name: 'वर्तुळ' },
            'ur-IN': { name: 'دائرہ' },
            'ar-IN': { name: 'الدائرة' }
          }
        },
        {
          id: 'chap_04',
          name: 'Geometric Constructions',
          translations: {
            'mr-IN': { name: 'भौमितिक रचना' },
            'ur-IN': { name: 'ہندسی تعمیراٹ' },
            'ar-IN': { name: 'الإنشاءات الهندسية' }
          }
        },
        {
          id: 'chap_05',
          name: 'Co-ordinate Geometry',
          translations: {
            'mr-IN': { name: 'निर्देशक भूमिती' },
            'ur-IN': { name: 'محدد ہندسیہ' },
            'ar-IN': { name: 'الهندسة الإحداثية' }
          }
        },
        {
          id: 'chap_06',
          name: 'Trigonometry',
          translations: {
            'mr-IN': { name: 'त्रिकोणमिती' },
            'ur-IN': { name: 'علم مثلث' },
            'ar-IN': { name: 'علم المثلثات' }
          }
        },
        {
          id: 'chap_07',
          name: 'Mensuration',
          translations: {
            'mr-IN': { name: 'महत्त्वमापन' },
            'ur-IN': { name: 'پیمائش' },
            'ar-IN': { name: 'حساب القياس' }
          }
        }
      ]
    },
    {
      id: 'mh_sci1_10',
      data: {
        name: 'Sci Part 1',
        description: 'Maharashtra Board Class 10 Science Part 1',
        category: 'Science',
        iconName: 'rocket',
        colorValue: 0xFF8B5CF6,
        badgeText: 'MH Board 10th',
        subtitle: 'Physics and Chemistry concepts.',
        unitCount: 10,
        formulaCount: 10,
        isFeatured: true,
        boardId: 'msbshse',
        gradeId: 'class_10',
        audiences: ['msbshse_10', 'IN_msbshse_10', 'msbshse_class_10'],
        isGeneralContent: false,
        translations: {
          'mr-IN': {
            name: 'विज्ञान भाग १',
            description: 'महाराष्ट्र बोर्ड इयत्ता १० वी विज्ञान भाग १',
            subtitle: 'भौतिकशास्त्र आणि रसायनशास्त्राच्या संकल्पना.',
            badgeText: 'महाराष्ट्र बोर्ड इयत्ता १० वी'
          },
          'ur-IN': {
            name: 'سائنس حصہ ۱',
            description: 'مہاراشٹر بورڈ دہم سائنس حصہ اول',
            subtitle: 'طبیعیات اور کیمیا کے تصورات۔',
            badgeText: 'مہاراشٹر بورڈ دہم'
          },
          'ar-IN': {
            name: 'العلوم الجزء 1',
            description: 'العلوم الجزء 1 للصف العاشر لمجلس ماهاراشترا',
            subtitle: 'مفاهيم الفيزياء والكيمياء.',
            badgeText: 'مجلس ماهاراشترا دہم'
          }
        }
      },
      chapters: [
        {
          id: 'chap_01',
          name: 'Gravitation',
          translations: {
            'mr-IN': { name: 'गुरुत्वाकर्षण' },
            'ur-IN': { name: 'کشش ثقل' },
            'ar-IN': { name: 'الجاذبية' }
          }
        },
        {
          id: 'chap_02',
          name: 'Periodic Classification of Element',
          translations: {
            'mr-IN': { name: 'मूलद्रव्यांचे आवर्ती वर्गीकरण' },
            'ur-IN': { name: 'عناصر کی دوری جماعت بندی' },
            'ar-IN': { name: 'التصنيف الدروي للعناصر' }
          }
        },
        {
          id: 'chap_03',
          name: 'Chemical reactions and equations',
          translations: {
            'mr-IN': { name: 'रासायनिक अभिक्रिया आणि समीकरणे' },
            'ur-IN': { name: 'کیمیائی تعاملات اور مساواتیں' },
            'ar-IN': { name: 'التفاعلات والمعادلات الكيميائية' }
          }
        },
        {
          id: 'chap_04',
          name: 'Effects of electric current',
          translations: {
            'mr-IN': { name: 'विद्युत धारेचे परिणाम' },
            'ur-IN': { name: 'برقی رو کے اثرات' },
            'ar-IN': { name: 'تأثيرات التيار الكهربائي' }
          }
        },
        {
          id: 'chap_05',
          name: 'Heat',
          translations: {
            'mr-IN': { name: 'उष्णता' },
            'ur-IN': { name: 'حرارت' },
            'ar-IN': { name: 'الحرارة' }
          }
        },
        {
          id: 'chap_06',
          name: 'Refraction of light',
          translations: {
            'mr-IN': { name: 'प्रकाशाचे अपवर्तन' },
            'ur-IN': { name: 'نور का انعطاف' },
            'ar-IN': { name: 'انكسار الضوء' }
          }
        },
        {
          id: 'chap_07',
          name: 'Lenses',
          translations: {
            'mr-IN': { name: 'भिंगे आणि त्यांचे उपयोग' },
            'ur-IN': { name: 'عدسے' },
            'ar-IN': { name: 'العدسات' }
          }
        },
        {
          id: 'chap_08',
          name: 'Metallurgy',
          translations: {
            'mr-IN': { name: 'धातूविज्ञान' },
            'ur-IN': { name: 'دھات کاری' },
            'ar-IN': { name: 'علم الفلزات' }
          }
        },
        {
          id: 'chap_09',
          name: 'Carbon compounds',
          translations: {
            'mr-IN': { name: 'कर्बनी संयुगे' },
            'ur-IN': { name: 'کاربن کے مرکبات' },
            'ar-IN': { name: 'مركبات الكربون' }
          }
        },
        {
          id: 'chap_10',
          name: 'Space Missions',
          translations: {
            'mr-IN': { name: 'अवकाश मोहिमा' },
            'ur-IN': { name: 'خلائی مہمات' },
            'ar-IN': { name: 'البعثات الفضائية' }
          }
        }
      ]
    },
    {
      id: 'mh_sci2_10',
      data: {
        name: 'Sci Part 2',
        description: 'Maharashtra Board Class 10 Science Part 2',
        category: 'Science',
        iconName: 'microscope',
        colorValue: 0xFFEC4899,
        badgeText: 'MH Board 10th',
        subtitle: 'Biology and Environmental Science concepts.',
        unitCount: 10,
        formulaCount: 10,
        isFeatured: true,
        boardId: 'msbshse',
        gradeId: 'class_10',
        audiences: ['msbshse_10', 'IN_msbshse_10', 'msbshse_class_10'],
        isGeneralContent: false,
        translations: {
          'mr-IN': {
            name: 'विज्ञान भाग २',
            description: 'महाराष्ट्र बोर्ड इयत्ता १० वी विज्ञान भाग २',
            subtitle: 'जीवशास्त्र आणि पर्यावरण विज्ञानाच्या संकल्पना.',
            badgeText: 'महाराष्ट्र बोर्ड इयत्ता १० वी'
          },
          'ur-IN': {
            name: 'سائنس حصہ २',
            description: 'مہاراشٹر بورڈ دہم سائنس حصہ دوم',
            subtitle: 'حیاتیات اور ماحولیاتی سائنس کے تصورات۔',
            badgeText: 'مہاراشٹر بورڈ دہم'
          },
          'ar-IN': {
            name: 'العلوم الجزء 2',
            description: 'العلوم الجزء 2 للصف العاشر لمجلس ماهاراشترا',
            subtitle: 'مفاهيم علم الأحياء والعلوم البيئية.',
            badgeText: 'مجلس ماهاراشترا دہم'
          }
        }
      },
      chapters: [
        {
          id: 'chap_01',
          name: 'Heredity and Evolution',
          translations: {
            'mr-IN': { name: 'अनुवंशिकता व उत्क्रांती' },
            'ur-IN': { name: 'وراثت اور ارتقاء' },
            'ar-IN': { name: 'الوراثة والتطور' }
          }
        },
        {
          id: 'chap_02',
          name: 'Life Processes in Living Organisms Part -1',
          translations: {
            'mr-IN': { name: 'सजीवांतील जीवनप्रक्रिया भाग १' },
            'ur-IN': { name: 'جانداروں میں حیاتی افعال حصہ اول' },
            'ar-IN': { name: 'العمليات الحيوية في الكائنات الحية الجزء 1' }
          }
        },
        {
          id: 'chap_03',
          name: 'Life Processes in Living Organisms Part - 2',
          translations: {
            'mr-IN': { name: 'सजीवांतील जीवनप्रक्रिया भाग २' },
            'ur-IN': { name: 'جانداروں میں حیاتی افعال حصہ دوم' },
            'ar-IN': { name: 'العمليات الحيوية في الكائنات الحية الجزء 2' }
          }
        },
        {
          id: 'chap_04',
          name: 'Environmental management',
          translations: {
            'mr-IN': { name: 'पर्यावरणीय व्यवस्थापन' },
            'ur-IN': { name: 'ماحولیاتی انتظام' },
            'ar-IN': { name: 'الإدارة البيئية' }
          }
        },
        {
          id: 'chap_05',
          name: 'Towards Green Energy',
          translations: {
            'mr-IN': { name: 'हरित ऊर्जेच्या दिशेने' },
            'ur-IN': { name: 'سبز توانائی کی طرف' },
            'ar-IN': { name: 'نحو طاقة خضراء' }
          }
        },
        {
          id: 'chap_06',
          name: 'Animal Classification',
          translations: {
            'mr-IN': { name: 'प्राण्यांचे वर्गीकरण' },
            'ur-IN': { name: 'حیوانات کی جماعت بندی' },
            'ar-IN': { name: 'تصنيف الحيوانات' }
          }
        },
        {
          id: 'chap_07',
          name: 'Introduction to Microbiology',
          translations: {
            'mr-IN': { name: 'ओळख सूक्ष्मजीवशास्त्राची' },
            'ur-IN': { name: 'خرد حیاتیات کا تعارف' },
            'ar-IN': { name: 'مقدمة في علم الأحياء الدقيقة' }
          }
        },
        {
          id: 'chap_08',
          name: 'Cell Biology and Biotechnology',
          translations: {
            'mr-IN': { name: 'पेशीविज्ञान व जैवतंत्रज्ञान' },
            'ur-IN': { name: 'خلوی حیاتیات اور حیاتیاتی ٹیکنالوجی' },
            'ar-IN': { name: 'علم أحياء الخلية والتكنولوجيا الحيوية' }
          }
        },
        {
          id: 'chap_09',
          name: 'Social health',
          translations: {
            'mr-IN': { name: 'सामाजिक आरोग्य' },
            'ur-IN': { name: 'سماجی صحت' },
            'ar-IN': { name: 'الصحة الاجتماعية' }
          }
        },
        {
          id: 'chap_10',
          name: 'Disaster Management',
          translations: {
            'mr-IN': { name: 'आपत्ती व्यवस्थापन' },
            'ur-IN': { name: 'آفت کا انتظام' },
            'ar-IN': { name: 'إدارة الكوارث' }
          }
        }
      ]
    }
  ];

  for (const subject of subjects) {
    const subjectRef = db.collection('subjects').doc(subject.id);
    batch.set(subjectRef, {
      ...subject.data,
      localized: buildLocalizedSubjectFields(subject.data)
    });
    addMasteryTools(subjectRef);

    let formulaCounter = 1;
    for (const chapter of subject.chapters) {
      const chapterRef = subjectRef.collection('chapters').doc(chapter.id);
      const chapterDoc = {
        name: chapter.name,
        subtitle: `Important concepts for ${chapter.name}`,
        translations: chapter.translations || {}
      };
      batch.set(chapterRef, {
        ...chapterDoc,
        localized: buildLocalizedChapterFields(chapterDoc)
      });

      // Delete any pre-existing dummy short note / formula for the chapter to prevent clutter
      const formulaRef = chapterRef.collection('formulas').doc(`formula_${subject.id}_${formulaCounter}`);
      batch.delete(formulaRef);
      formulaCounter++;
    }
  }

  await batch.commit();
  console.log('Successfully seeded MH Board 10th Subjects, Chapters, and Notes! ✅');
}

seedMhBoard10().catch(console.error);
