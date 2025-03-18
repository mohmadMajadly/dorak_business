import 'package:flutter/services.dart';

class PhoneNumberFormatterUtility extends TextInputFormatter {
  final String numberFormat;

  PhoneNumberFormatterUtility({required this.numberFormat});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldTextValue,
      TextEditingValue newTextValue,
      ) {
    if (newTextValue.text.isEmpty) return newTextValue;

    final digitsOnly = newTextValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final formattedPhoneNumber = _formatPhoneNumberWithPattern(digitsOnly);

    return TextEditingValue(
      text: formattedPhoneNumber,
      selection: TextSelection.collapsed(offset: formattedPhoneNumber.length),
    );
  }

  String _formatPhoneNumberWithPattern(String digits) {
    var formattedNumber = '';
    var digitIndex = 0;

    for (var i = 0; i < numberFormat.length && digitIndex < digits.length; i++) {
      if (numberFormat[i] == 'X') {
        formattedNumber += digits[digitIndex];
        digitIndex++;
      } else {
        formattedNumber += numberFormat[i];
      }
    }

    return formattedNumber;
  }
}