// lib/views/phone_verification_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dorak_business/viewModel/OTP/phone_verification_view_model.dart';
import 'package:dorak_business/utils/OTP/phone_number_formatter_utility.dart';
import 'widgets/success_dialog_widget.dart';
import 'widgets/failure_dialog_widget.dart';
import 'widgets/country_picker_dialog_widget.dart';

class PhoneVerificationView extends StatefulWidget {
  final String languageCode;

  const PhoneVerificationView({
    super.key,
    required this.languageCode,
  });

  @override
  State<PhoneVerificationView> createState() => _PhoneVerificationViewState();
}

class _PhoneVerificationViewState extends State<PhoneVerificationView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;
  late PhoneVerificationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PhoneVerificationViewModel(languageCode: widget.languageCode);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  void _handlePhoneSubmission() async {
    if (!viewModel.isPhoneNumberValid) return;

    final success = await viewModel.initiatePhoneVerification();
    if (success) {
      viewModel.setOneTimePasswordScreenVisibility(true);
    } else {
      _showErrorSnackBar(viewModel.errorMessage ??
          viewModel.languageConfiguration.translations['verificationFailed']!);
    }
  }

  Future<void> _handleOneTimePasswordSubmission() async {
    final oneTimePassword = viewModel.oneTimePasswordControllers
        .map((controller) => controller.text)
        .join();
    if (oneTimePassword.length != 6) return;

    final success = await viewModel.verifyOneTimePassword(oneTimePassword);

    if (success) {
      _showSuccessDialog();
    } else {
      _showFailureDialog();
    }
  }

  Future<void> _handleResendCode() async {
    final success = await viewModel.resendVerificationCode();

    if (success) {
      _showResendSuccessMessage();
    } else {
      _showResendFailureMessage();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showResendSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(viewModel
                  .languageConfiguration.translations['codeResentMessage']!),
            ],
          ),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showResendFailureMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  viewModel.errorMessage ??
                      viewModel.languageConfiguration
                          .translations['verificationFailed']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VerificationSuccessDialogWidget(
        languageConfiguration: viewModel.languageConfiguration,
        onContinuePressed: () {
          Navigator.of(context).pop();
          viewModel.setOneTimePasswordScreenVisibility(false);
        },
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VerificationFailureDialogWidget(
        languageConfiguration: viewModel.languageConfiguration,
        onRetryPressed: () {
          Navigator.of(context).pop();
          viewModel.clearOneTimePasswordFields();
          viewModel.oneTimePasswordFocusNodes[0].requestFocus();
        },
        onResendPressed: () {
          Navigator.of(context).pop();
          viewModel.clearOneTimePasswordFields();
          _handleResendCode();
        },
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Directionality(
        textDirection: viewModel.languageConfiguration.isRightToLeft
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: CountryPickerDialogWidget(
          languageConfiguration: viewModel.languageConfiguration,
          availableCountries: viewModel.availableCountries,
          selectedCountry: viewModel.selectedCountry,
          onCountrySelected: viewModel.updateSelectedCountry,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<PhoneVerificationViewModel>(
        builder: (context, viewModel, _) => Directionality(
          textDirection: viewModel.languageConfiguration.isRightToLeft
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FadeTransition(
                        opacity: fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            _buildNavigationHeader(),
                            const SizedBox(height: 36),
                            _buildHeaderIcon(),
                            const SizedBox(height: 60),
                            _buildTitleSection(),
                            const SizedBox(height: 40),
                            if (!viewModel.isOneTimePasswordScreenVisible)
                              _buildPhoneNumberInput()
                            else
                              _buildOneTimePasswordInput(),
                            const SizedBox(height: 40),
                            _buildActionButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Only show the full-screen loading when verifying the code
                if (viewModel.isVerifyingCode)
                  Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationHeader() {
    if (!viewModel.isOneTimePasswordScreenVisible) {
      return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios),
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return Align(
      alignment: viewModel.languageConfiguration.isRightToLeft
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () => viewModel.setOneTimePasswordScreenVisibility(false),
        icon: const Icon(Icons.edit),
        label: Text(
          viewModel.languageConfiguration.translations['changePhoneNumber']!,
        ),
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Center(
      child: Transform.translate(
        offset: Offset(0, slideAnimation.value),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100,
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Icon(
            viewModel.isOneTimePasswordScreenVisible
                ? Icons.lock_outline_rounded
                : Icons.phone_android,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.isOneTimePasswordScreenVisible
              ? viewModel
                  .languageConfiguration.translations['enterOneTimePassword']!
              : viewModel
                  .languageConfiguration.translations['verifyPhoneNumber']!,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1F71),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          viewModel.isOneTimePasswordScreenVisible
              ? viewModel
                  .languageConfiguration.translations['enterVerificationCode']!
              : viewModel.languageConfiguration
                  .translations['willSendVerificationCode']!,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.phoneNumberController,
        keyboardType: TextInputType.phone,
        onChanged: (_) => viewModel.validatePhoneNumber(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText:
              viewModel.languageConfiguration.translations['phoneNumberLabel'],
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 20,
          ),
          errorText: viewModel.errorMessage,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: InkWell(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModel.selectedCountry.countryDialingCode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          contentPadding: const EdgeInsets.all(24),
        ),
        inputFormatters: [
          PhoneNumberFormatterUtility(
            numberFormat: viewModel.selectedCountry.phoneNumberFormat,
          ),
        ],
        textDirection: TextDirection.ltr, // Always LTR for phone numbers
      ),
    );
  }

  Widget _buildOneTimePasswordInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: TextField(
                controller: viewModel.oneTimePasswordControllers[index],
                focusNode: viewModel.oneTimePasswordFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                enabled: !viewModel.isVerifyingCode,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    viewModel.oneTimePasswordFocusNodes[index + 1]
                        .requestFocus();
                  }
                  if (value.isEmpty && index > 0) {
                    viewModel.oneTimePasswordFocusNodes[index - 1]
                        .requestFocus();
                  }
                  if (index == 5 && value.isNotEmpty) {
                    _handleOneTimePasswordSubmission();
                  }
                },
                onTap: () {
                  final lastFilledIndex =
                      viewModel.findLastFilledOneTimePasswordDigit();
                  if (lastFilledIndex < 6) {
                    viewModel.oneTimePasswordFocusNodes[lastFilledIndex]
                        .requestFocus();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.languageConfiguration.translations['noCodeReceived']!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: viewModel.isResendingCode || viewModel.isVerifyingCode
                  ? null
                  : _handleResendCode,
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModel.languageConfiguration.translations['resendCode']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (viewModel.isResendingCode) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (!viewModel.isOneTimePasswordScreenVisible) {
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: viewModel.isSendingCode
              ? null
              : viewModel.isPhoneNumberValid
                  ? _handlePhoneSubmission
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: viewModel.isPhoneNumberValid ? 8 : 0,
            shadowColor: Colors.blue.shade200,
          ),
          child: viewModel.isSendingCode
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  viewModel.languageConfiguration
                      .translations['sendVerificationCode']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: viewModel.isPhoneNumberValid
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
