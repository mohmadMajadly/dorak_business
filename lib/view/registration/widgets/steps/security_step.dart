import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import '../shared/custom_text_field.dart';
import '../shared/navigation_buttons.dart';

class SecurityInformationStep extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;

  const SecurityInformationStep({
    super.key,
    required this.viewModel,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: language.textDirection == TextDirection.ltr
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          CustomTextField(
            controller: viewModel.passwordController,
            label: viewModel.getLocalizedText('password'),
            textDirection: language.textDirection,
            obscureText: viewModel.state.isPasswordHidden,
            errorText: viewModel.state.passwordErrorMessage,
            onChanged: (value) => viewModel.validatePassword(value),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.state.isPasswordHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
              onPressed: () => viewModel.togglePasswordVisibility(false),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: viewModel.confirmPasswordController,
            label: viewModel.getLocalizedText('confirm_password'),
            textDirection: language.textDirection,
            obscureText: viewModel.state.isConfirmPasswordHidden,
            errorText: viewModel.state.confirmPasswordErrorMessage,
            onChanged: (value) => viewModel.validateConfirmPassword(value),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.state.isConfirmPasswordHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
              onPressed: () => viewModel.togglePasswordVisibility(true),
            ),
          ),
          const SizedBox(height: 40),
          NavigationButtons(
            viewModel: viewModel,
            language: language,
          ),
        ],
      ),
    );
  }
}
