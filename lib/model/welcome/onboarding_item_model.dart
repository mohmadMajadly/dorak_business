import 'package:flutter/material.dart';

class OnboardingItemModel {
  final String titleKey;
  final String descriptionKey;
  final Widget Function(BuildContext, String Function(String)) contentBuilder;

  OnboardingItemModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.contentBuilder,
  });
}