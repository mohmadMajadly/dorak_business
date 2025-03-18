import 'package:flutter/material.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';

class ActionButton extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final bool isMainAction;
  final bool isLastStep;

  const ActionButton({
    super.key,
    required this.viewModel,
    required this.isMainAction,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: viewModel.state.isFormValid
            ? LinearGradient(
          colors: viewModel.gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
            : null,
        color: viewModel.state.isFormValid ? null : Colors.grey[300],
      ),
      child: ElevatedButton(
        onPressed: viewModel.state.isFormValid
            ? () {
          if (isLastStep) {
            viewModel.registerUser(context);
          } else {
            viewModel.moveToNextStep();
          }
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          viewModel.getLocalizedText(isLastStep ? 'create_account' : 'continue'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: viewModel.state.isFormValid ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
