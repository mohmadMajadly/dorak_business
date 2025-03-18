import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';

class GenderSelector extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;

  const GenderSelector({
    super.key,
    required this.viewModel,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: language.textDirection == TextDirection.rtl
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            viewModel.getLocalizedText('gender'),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption('male', Icons.male),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderOption('female', Icons.female),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final bool isSelected = viewModel.state.selectedGender == gender;

    return InkWell(
      onTap: () => viewModel.setGender(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? viewModel.gradientColors[0].withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? viewModel.gradientColors[0] : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? viewModel.gradientColors[0] : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              viewModel.getLocalizedText(gender),
              style: TextStyle(
                color: isSelected ? viewModel.gradientColors[0] : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

