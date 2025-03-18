import 'package:flutter/material.dart';
import 'package:dorak_business/viewModel/welcome/welcome_viewmodel.dart';
import 'package:dorak_business/model/welcome/language_model.dart';

class LanguageBottomSheet extends StatelessWidget {
  final WelcomeViewModel viewModel;

  const LanguageBottomSheet({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
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
                      viewModel.getText('selectLanguage'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...viewModel.languages.map(
                  (language) => _buildLanguageOption(context, language),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, LanguageModel language) {
    final isSelected = language.code == viewModel.currentLanguage.code;
    return InkWell(
      onTap: () {
        viewModel.setLanguage(viewModel.languages.indexOf(language));
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
}
