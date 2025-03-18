import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import 'steps/basic_info_step.dart';
import 'steps/security_step.dart';
import 'steps/personal_details_step.dart';

class RegistrationStepContent extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage currentLanguage;

  const RegistrationStepContent({
    super.key,
    required this.viewModel,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: _buildCurrentStep(),
    );
  }

  Widget _buildCurrentStep() {
    switch (viewModel.state.currentStepIndex) {
      case 0:
        return BasicInformationStep(
          key: const ValueKey('basicInfo'),
          viewModel: viewModel,
          language: currentLanguage,
        );
      case 1:
        return SecurityInformationStep(
          key: const ValueKey('security'),
          viewModel: viewModel,
          language: currentLanguage,
        );
      case 2:
        return PersonalDetailsStep(
          key: const ValueKey('personalDetails'),
          viewModel: viewModel,
          language: currentLanguage,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}