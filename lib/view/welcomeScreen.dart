import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration/registration_view.dart';
import 'package:dorak_business/view/OTP/OTPLogin_view.dart';

class Language {
  final String name;
  final String code;
  final bool isRTL;
  final Map<String, String> translations;

  Language(this.name, this.code, this.translations, {this.isRTL = false});
}

class OnboardingItem {
  final String titleKey;
  final String descriptionKey;
  final Widget Function(BuildContext, String Function(String)) contentBuilder;

  OnboardingItem({
    required this.titleKey,
    required this.descriptionKey,
    required this.contentBuilder,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  int _currentLanguageIndex = 0;

  final List<Language> _languages = [
    Language('English', 'en', {
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
    Language(
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
    Language(
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

  Language get currentLanguage => _languages[_currentLanguageIndex];

  String getText(String key) => currentLanguage.translations[key] ?? key;

  late final List<OnboardingItem> _pages;

  static const String _languageCodeKey = 'en';

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _initializePages();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageCodeKey);

      if (savedLanguageCode != null) {
        final savedLanguageIndex = _languages.indexWhere(
                (lang) => lang.code == savedLanguageCode
        );

        if (savedLanguageIndex != -1) {
          setState(() {
            _currentLanguageIndex = savedLanguageIndex;
          });
        }
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }


  void _initializePages() {
    _pages = [
      OnboardingItem(
        titleKey: 'trackEarnings',
        descriptionKey: 'earningsDesc',
        contentBuilder: (context, getText) => _buildEarningsChart(),
      ),
      OnboardingItem(
        titleKey: 'manageBookings',
        descriptionKey: 'bookingsDesc',
        contentBuilder: (context, getText) => _buildTeamList(),
      ),
      OnboardingItem(
        titleKey: 'dataPriority',
        descriptionKey: 'dataDesc',
        contentBuilder: (context, getText) => _buildStatistics(getText),
      ),
      OnboardingItem(
        titleKey: 'manageEffortlessly',
        descriptionKey: 'effortlessDesc',
        contentBuilder: (context, getText) => _buildBookingStatuses(getText),
      ),
    ];
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: Colors.blue.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          getText('selectLanguage'),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ..._languages
                        .map((language) => _buildLanguageOption(language)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(Language language) {
    final isSelected = language.code == currentLanguage.code;
    return InkWell(
      onTap: () async {
        setState(() {
          _currentLanguageIndex = _languages.indexOf(language);
        });
        await _saveLanguagePreference(language.code);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue.shade300 : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
                ),
              ),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.language,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              language.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => Container(
                width: 60,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 60,
                      height: (index + 1) * 40.0,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  getText('monthlyPayment'),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₪200',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamList() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team Member ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Service ${index + 1}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatistics(String Function(String) getText) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatRow([
            _buildStatCard(
              title: getText('earnings'),
              value: '₪100k',
              icon: Icons.attach_money,
            ),
            _buildStatCard(
              title: getText('bookings'),
              value: '250',
              icon: Icons.calendar_today,
            ),
          ]),
          const SizedBox(height: 16),
          _buildStatRow([
            _buildStatCard(
              title: getText('teamMembers'),
              value: '15',
              icon: Icons.people,
            ),
            /*_buildStatCard(
              title: '',
              value: '',
              icon: Icons.shield_outlined,
              isIcon: true,
            ),*/
          ]),
        ],
      ),
    );
  }

  Widget _buildStatRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((child) => Expanded(child: child)).toList(),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    bool isIcon = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (isIcon)
            Icon(
              icon,
              size: 32,
              color: Colors.orange.shade400,
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingStatuses(String Function(String) getText) {
    final statuses = [
      (getText('confirmed'), Colors.green),
      (getText('pending'), Colors.orange),
      (getText('rejected'), Colors.red),
    ];

    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final (status, color) = statuses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          currentLanguage.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade500,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getText(_pages[index].titleKey),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                getText(_pages[index].descriptionKey),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: _pages[index]
                                    .contentBuilder(context, getText),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showLanguageBottomSheet,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      currentLanguage.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerificationPage(languageCode: currentLanguage.code)));
              // Handle skip
            },
            child: Text(
              getText('skip'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(_currentPage == index ? 0.9 : 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationView(languageCode: currentLanguage.code)));
                  // Navigate to main app
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _currentPage < _pages.length - 1
                    ? getText('next')
                    : getText('getStarted'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
