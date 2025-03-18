import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import 'step_progress_indicator.dart';
import 'registration_step_content.dart';

class RegistrationScreen extends StatelessWidget {
  final String languageCode;

  const RegistrationScreen({
    super.key,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);
    final currentLanguage = ApplicationLanguage.fromLanguageCode(languageCode);

    return Directionality(
      textDirection: currentLanguage.textDirection,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: viewModel.gradientColors,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, viewModel, currentLanguage),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          StepProgressIndicator(
                            currentStep: viewModel.state.currentStepIndex,
                            totalSteps: 3,
                            gradientColors: viewModel.gradientColors,
                          ),
                          RegistrationStepContent(
                            viewModel: viewModel,
                            currentLanguage: currentLanguage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      RegistrationViewModel viewModel,
      ApplicationLanguage language,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.getLocalizedText('step_label')
                .replaceAll('{step}',
                (viewModel.state.currentStepIndex + 1).toString()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.getLocalizedText('create_account'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getStepDescription(viewModel),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepDescription(RegistrationViewModel viewModel) {
    switch (viewModel.state.currentStepIndex) {
      case 0:
        return viewModel.getLocalizedText('basic_info_desc');
      case 1:
        return viewModel.getLocalizedText('password_desc');
      case 2:
        return viewModel.getLocalizedText('details_desc');
      default:
        return '';
    }
  }
}
