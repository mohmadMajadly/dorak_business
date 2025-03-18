class LanguageModel {
  final String name;
  final String code;
  final bool isRTL;
  final Map<String, String> translations;

  LanguageModel(this.name, this.code, this.translations, {this.isRTL = false});

  static List<LanguageModel> getLanguages() {
    return [
      LanguageModel('English', 'en', {
        'trackEarnings': 'Track Your Earnings',
        'earningsDesc':
        'Boost productivity by effortlessly monitoring earnings, enabling smarter financial decisions.',
        'manageBookings': 'Manage Bookings With Team Members',
        'bookingsDesc':
        'Enhance productivity with easy team-based booking management, ensuring efficient collaboration.',
        'dataPriority': 'Your Data, Our Priority',
        'dataDesc': 'Your data\'s security is our core commitment.',
        'manageEffortlessly': 'Manage Bookings Effortlessly',
        'effortlessDesc':
        'Maximize productivity through seamless booking management, optimizing your workflow effortlessly.',
        'getStarted': 'Let\'s Get Started',
        'next': 'Next',
        'selectLanguage': 'Select Language',
        'earnings': 'Earnings',
        'bookings': 'Bookings',
        'teamMembers': 'Team members',
        'confirmed': 'Confirmed',
        'pending': 'Pending',
        'rejected': 'Rejected',
        'monthlyPayment': 'Monthly Payment',
        'skip': 'Skip',
      }),
      LanguageModel(
          'العربية',
          'ar',
          {
            'trackEarnings': 'تتبع أرباحك',
            'earningsDesc':
            'عزز الإنتاجية من خلال مراقبة الأرباح بسهولة، مما يتيح قرارات مالية أكثر ذكاءً.',
            'manageBookings': 'إدارة الحجوزات مع أعضاء الفريق',
            'bookingsDesc':
            'تعزيز الإنتاجية مع إدارة الحجوزات السهلة للفريق، مما يضمن تعاونًا فعالاً.',
            'dataPriority': 'بياناتك، أولويتنا',
            'dataDesc': 'أمان بياناتك هو التزامنا الأساسي.',
            'manageEffortlessly': 'إدارة الحجوزات بسهولة',
            'effortlessDesc':
            'تعظيم الإنتاجية من خلال إدارة الحجوزات السلسة، وتحسين سير العمل بسهولة.',
            'getStarted': 'هيا نبدأ',
            'next': 'التالي',
            'selectLanguage': 'اختر اللغة',
            'earnings': 'الأرباح',
            'bookings': 'الحجوزات',
            'teamMembers': 'أعضاء الفريق',
            'confirmed': 'مؤكد',
            'pending': 'قيد الانتظار',
            'rejected': 'مرفوض',
            'monthlyPayment': 'الدفع الشهري',
            'skip': 'تخطي',
          },
          isRTL: true),
      LanguageModel(
          'עברית',
          'he',
          {
            'trackEarnings': 'עקוב אחר הרווחים שלך',
            'earningsDesc':
            'הגבר את הפרודוקטיביות על ידי מעקב קל אחר רווחים, המאפשר החלטות פיננסיות חכמות יותר.',
            'manageBookings': 'נהל הזמנות עם חברי צוות',
            'bookingsDesc':
            'שפר את הפרודוקטיביות עם ניהול הזמנות קל לצוות, המבטיח שיתוף פעולה יעיל.',
            'dataPriority': 'הנתונים שלך, העדיפות שלנו',
            'dataDesc': 'אבטחת הנתונים שלך היא המחויבות המרכזית שלנו.',
            'manageEffortlessly': 'נהל הזמנות בקלות',
            'effortlessDesc':
            'מקסם את הפרודוקטיביות באמצעות ניהול הזמנות חלק, אופטימיזציה של זרימת העבודה בקלות.',
            'getStarted': 'בואו נתחיל',
            'next': 'הבא',
            'selectLanguage': 'בחר שפה',
            'earnings': 'רווחים',
            'bookings': 'הזמנות',
            'teamMembers': 'חברי צוות',
            'confirmed': 'מאושר',
            'pending': 'ממתין',
            'rejected': 'נדחה',
            'monthlyPayment': 'תשלום חודשי',
            'skip': 'דלג',
          },
          isRTL: true),
    ];
  }
}

