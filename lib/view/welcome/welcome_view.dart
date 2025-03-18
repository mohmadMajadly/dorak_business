// lib/views/welcome_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorak_business/viewModel/welcome/welcome_viewmodel.dart';
import 'package:dorak_business/view/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/language_bottom_sheet.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with SingleTickerProviderStateMixin {
  late WelcomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = WelcomeViewModel();
    viewModel.initializeAnimation(this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<WelcomeViewModel>(
        builder: (context, viewModel, _) {
          return Directionality(
            textDirection: viewModel.currentLanguage.isRTL
                ? TextDirection.rtl
                : TextDirection.ltr,
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
                      _buildHeader(context, viewModel),
                      Expanded(
                        child: _buildPageView(context, viewModel),
                      ),
                      _buildFooter(context, viewModel),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WelcomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLanguageBottomSheet(context, viewModel),
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
                      viewModel.currentLanguage.name,
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
            onPressed: () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isOnboardingComplete', true);
              } finally {

              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    languageCode: viewModel.currentLanguage.code,
                  ),
                ),
              );
            },
            child: Text(
              viewModel.getText('skip'),
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

  void _showLanguageBottomSheet(BuildContext context, WelcomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => LanguageBottomSheet(viewModel: viewModel),
    );
  }

  Widget _buildPageView(BuildContext context, WelcomeViewModel viewModel) {
    return PageView.builder(
      controller: viewModel.pageController,
      onPageChanged: viewModel.setCurrentPage,
      itemCount: viewModel.pages.length,
      itemBuilder: (context, index) => _buildPage(context, viewModel, index),
    );
  }

  Widget _buildPage(BuildContext context, WelcomeViewModel viewModel, int index) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.getText(viewModel.pages[index].titleKey),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              viewModel.getText(viewModel.pages[index].descriptionKey),
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
              child: viewModel.pages[index].contentBuilder(
                context,
                viewModel.getText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WelcomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              viewModel.pages.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: viewModel.currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    viewModel.currentPage == index ? 0.9 : 0.4,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (viewModel.currentPage < viewModel.pages.length - 1) {
                  viewModel.nextPage();
                } else {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isOnboardingComplete', true);
                  } finally {

                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        languageCode: viewModel.currentLanguage.code,
                      ),
                    ),
                  );
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
                viewModel.currentPage < viewModel.pages.length - 1
                    ? viewModel.getText('next')
                    : viewModel.getText('getStarted'),
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
    viewModel.dispose();
    super.dispose();
  }
}