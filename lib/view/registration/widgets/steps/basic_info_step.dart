import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import '../shared/custom_text_field.dart';
import '../shared/navigation_buttons.dart';

class BasicInformationStep extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;

  const BasicInformationStep({
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
            controller: viewModel.fullNameController,
            label: viewModel.getLocalizedText('full_name'),
            textDirection: language.textDirection,
            onChanged: (_) => viewModel.validateForm(),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return viewModel.getLocalizedText('nameRequired');
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: viewModel.usernameController,
            label: viewModel.getLocalizedText('username'),
            textDirection: language.textDirection,
            onChanged: (value) => viewModel.checkUsernameAvailability(value, context),
            errorText: viewModel.state.errorMessage,
            isLoading: viewModel.state.isProcessing,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return viewModel.getLocalizedText('username_required');
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: viewModel.emailController,
            label: viewModel.getLocalizedText('email'),
            textDirection: language.textDirection,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => viewModel.validateForm(),
            validator: (value) {
              if (value?.isNotEmpty ?? false) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return viewModel.getLocalizedText('emailInvalid');
                }
              }
              return null;
            },
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

