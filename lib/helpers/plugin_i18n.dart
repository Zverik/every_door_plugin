import 'package:flutter/material.dart';

/// Localizations wrapper for passing to various parts of code that need
/// only small parts of the metadata tree. For example, a tree preset
/// would need "preset.tree" branch for translations. This class allows
/// to hide the context.
abstract class PluginLocalizationsBranch {
  String translateCtx(
    BuildContext context,
    String key, {
    Map<String, dynamic>? args,
  });

  String translate(Locale locale, String key, {Map<String, dynamic>? args});

  List<String> translateList(Locale locale, String key);
}

class PluginLocalizations {
  String translate(
    Locale locale,
    String key, {
    Map<String, dynamic>? args,
    Map<String, dynamic>? data,
  }) => key;

  List<String> translateList(
    Locale locale,
    String key, {
    Map<String, dynamic>? data,
  }) => [];

  String translateN(
    Locale locale,
    String key,
    int count, {
    Map<String, dynamic>? args,
    Map<String, dynamic>? data,
  }) => key;
}
