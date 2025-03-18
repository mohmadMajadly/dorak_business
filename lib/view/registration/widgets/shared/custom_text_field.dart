import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextDirection textDirection;
  final String? errorText;
  final bool isLoading;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    required this.textDirection,
    this.errorText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textDirection == TextDirection.ltr
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textDirection: textDirection,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: label,
              errorText: errorText,
              suffixIcon: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
                  : suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
        /*if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
              textDirection: textDirection,
            ),
          ),*/
      ],
    );
  }
}