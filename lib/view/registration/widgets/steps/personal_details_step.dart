import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import '../shared/navigation_buttons.dart';
import '../shared/date_of_birth_selector.dart';
import '../shared/gender_selector.dart';
import '../shared/terms_and_conditions.dart';

class PersonalDetailsStep extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;

  const PersonalDetailsStep({
    super.key,
    required this.viewModel,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: language.textDirection == TextDirection.ltr
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        DateOfBirthSelector(
          viewModel: viewModel,
          language: language,
        ),
        const SizedBox(height: 20),
        GenderSelector(
          viewModel: viewModel,
          language: language,
        ),
        const SizedBox(height: 20),
        TermsAndConditions(
          viewModel: viewModel,
          language: language,
        ),
        const SizedBox(height: 40),
        NavigationButtons(
          viewModel: viewModel,
          language: language,
          isLastStep: true,
        ),
      ],
    );
  }
}

