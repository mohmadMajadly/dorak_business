import 'package:flutter/material.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'action_button.dart';

class NavigationButtons extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;
  final bool isLastStep;

  const NavigationButtons({
    super.key,
    required this.viewModel,
    required this.language,
    this.isLastStep = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirstStep = viewModel.state.currentStepIndex == 0;
    final bool isLeftToRight =
        language.textDirection == TextDirection.ltr;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isLeftToRight) ...[
          if (!isFirstStep)
            ActionButton(
              viewModel: viewModel,
              isMainAction: true,
              isLastStep: isLastStep,
            ),
          if (isFirstStep)
            ActionButton(
              viewModel: viewModel,
              isMainAction: true,
              isLastStep: isLastStep,
            )
          else
            TextButton(
              onPressed: viewModel.moveToPreviousStep,
              child: Text(
                viewModel.getLocalizedText('back'),
                style: TextStyle(color: viewModel.gradientColors[0]),
              ),
            ),
        ] else ...[
          if (isFirstStep)
            ActionButton(
              viewModel: viewModel,
              isMainAction: true,
              isLastStep: isLastStep,
            )
          else
            TextButton(
              onPressed: viewModel.moveToPreviousStep,
              child: Text(
                viewModel.getLocalizedText('back'),
                style: TextStyle(color: viewModel.gradientColors[0]),
              ),
            ),
          if (!isFirstStep)
            ActionButton(
              viewModel: viewModel,
              isMainAction: true,
              isLastStep: isLastStep,
            ),
        ],
      ],
    );
  }
}
