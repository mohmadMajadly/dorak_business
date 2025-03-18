import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/language_model.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';


class TermsAndConditions extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final ApplicationLanguage language;

  const TermsAndConditions({
    super.key,
    required this.viewModel,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: viewModel.state.hasAcceptedTerms,
            onChanged: (value) => viewModel.setTermsAcceptance(value ?? false),
            activeColor: viewModel.gradientColors[0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => _showTermsDialog(context),
            child: RichText(
              text: TextSpan(
                text: '${viewModel.getLocalizedText('terms_intro')} ',
                style: TextStyle(color: Colors.grey[600]),
                children: [
                  TextSpan(
                    text: viewModel.getLocalizedText('terms_and_conditions'),
                    style: TextStyle(
                      color: viewModel.gradientColors[0],
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(viewModel.getLocalizedText('termsAndConditions')),
          content: const SingleChildScrollView(
            child: Text('Your terms and conditions content here...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                viewModel.getLocalizedText('continue'),
                style: TextStyle(color: viewModel.gradientColors[0]),
              ),
            ),
          ],
        );
      },
    );
  }
}