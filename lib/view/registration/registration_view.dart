import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorak_business/viewModel/registration/registration_viewmodel.dart';
import 'package:dorak_business/service/registration/authentication_service.dart';
import 'widgets/registration_screen.dart';

class RegistrationView extends StatelessWidget {
  final String languageCode;

  const RegistrationView({
    super.key,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationViewModel(
        AuthenticationServiceImplementation(),
        languageCode,
      ),
      child: RegistrationScreen(languageCode: languageCode),
    );
  }
}

