// lib/viewmodels/welcome_view_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorak_business/model/welcome/language_model.dart';
import 'package:dorak_business/model/welcome/onboarding_item_model.dart';

class WelcomeViewModel extends ChangeNotifier {
  // Constants
  static const String _languageCodeKey = 'languageCode';

  // Controllers
  late PageController pageController;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  // State Variables
  int _currentPage = 0;
  int _currentLanguageIndex = 0;
  bool _isLoading = false;

  // Getters
  int get currentPage => _currentPage;
  int get currentLanguageIndex => _currentLanguageIndex;
  bool get isLoading => _isLoading;
  LanguageModel get currentLanguage => languages[_currentLanguageIndex];

  // Lists
  final List<LanguageModel> languages = LanguageModel.getLanguages();
  late List<OnboardingItemModel> pages;

  // Constructor
  WelcomeViewModel() {
    _initializeControllers();
    _initializePages();
    loadSavedLanguage();
  }

  // Initialization Methods
  void _initializeControllers() {
    pageController = PageController();
  }

  void initializeAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );
    animationController.forward();
  }

  void _initializePages() {
    pages = [
      OnboardingItemModel(
        titleKey: 'trackEarnings',
        descriptionKey: 'earningsDesc',
        contentBuilder: (context, getText) => buildEarningsChart(),
      ),
      OnboardingItemModel(
        titleKey: 'manageBookings',
        descriptionKey: 'bookingsDesc',
        contentBuilder: (context, getText) => buildTeamList(),
      ),
      OnboardingItemModel(
        titleKey: 'dataPriority',
        descriptionKey: 'dataDesc',
        contentBuilder: (context, getText) => buildStatistics(getText),
      ),
      OnboardingItemModel(
        titleKey: 'manageEffortlessly',
        descriptionKey: 'effortlessDesc',
        contentBuilder: (context, getText) => buildBookingStatuses(getText),
      ),
    ];
  }

  // Language Methods
  String getText(String key) => currentLanguage.translations[key] ?? key;

  Future<void> loadSavedLanguage() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('languageCode');

      if (savedLanguageCode != null) {
        final savedLanguageIndex = languages.indexWhere(
                (lang) => lang.code == savedLanguageCode
        );

        if (savedLanguageIndex != -1) {
          _currentLanguageIndex = savedLanguageIndex;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveLanguagePreference(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  Future<void> setLanguage(int index) async {
    _setLoading(true);
    try {
      _currentLanguageIndex = index;
      await saveLanguagePreference(currentLanguage.code);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Navigation Methods
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Loading State Method
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // UI Builder Methods
  Widget buildEarningsChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildChartBars(),
          const SizedBox(height: 20),
          _buildMonthlyPayment(),
        ],
      ),
    );
  }

  Widget _buildChartBars() {
    return Row(
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
    );
  }

  Widget _buildMonthlyPayment() {
    return Container(
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
    );
  }

  Widget buildTeamList() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => _buildTeamMemberCard(index),
      ),
    );
  }

  Widget _buildTeamMemberCard(int index) {
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
          _buildStatusBadge('Active'),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildStatistics(String Function(String) getText) {
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

  Widget buildBookingStatuses(String Function(String) getText) {
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
        itemBuilder: (context, index) => _buildStatusCard(statuses[index]),
      ),
    );
  }

  Widget _buildStatusCard((String, Color) statusData) {
    final (status, color) = statusData;
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
  }

  // Cleanup
  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }
}