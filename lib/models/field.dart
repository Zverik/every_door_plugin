// Copyright 2022-2025 Ilya Zverev
// This file is a part of Every Door, distributed under GPL v3 or later version.
// Refer to LICENSE file and https://www.gnu.org/licenses/gpl-3.0.html for details.
import 'dart:convert';

import 'package:country_coder/country_coder.dart';
import 'package:flutter/material.dart';
import 'package:every_door_plugin/models/amenity.dart';

/// Tag dependency definition. Basically a structure that defines
/// which tags and which values should or should not be preset in a tag list.
/// See https://github.com/ideditor/schema-builder/blob/main/README.md#prerequisitetag
class FieldPrerequisite {
  final String? key;
  final String? keyNot;
  final List<String>? values;
  final List<String>? valuesNot;

  const FieldPrerequisite({this.key, this.values, this.keyNot, this.valuesNot});

  bool matches(Map<String, String> tags) {
    if (keyNot != null) return !tags.containsKey(keyNot);
    if (key == null || !tags.containsKey(key)) return false;
    if (values != null) return values!.contains(tags[key]);
    if (valuesNot != null) return !valuesNot!.contains(tags[key]);
    return false;
  }

  factory FieldPrerequisite.fromJson(Map<String, dynamic> data) {
    final List<String> values = [];
    if (data.containsKey('values'))
      values.addAll(data['values']);
    else if (data.containsKey('value')) values.add(data['value']);

    final List<String> valuesNot = [];
    if (data.containsKey('valuesNot'))
      valuesNot.addAll(data['valuesNot']);
    else if (data.containsKey('valueNot')) valuesNot.add(data['valueNot']);

    return FieldPrerequisite(
      key: data['key'],
      keyNot: data['keyNot'],
      values: values.isNotEmpty ? values : null,
      valuesNot: valuesNot.isNotEmpty ? valuesNot : null,
    );
  }
}

/// Field definition. Each field type needs to subclass this one.
/// There are multiple examples in the `fields` directory.
abstract class PresetField {
  /// OSM tag key for this field. If the field does not use this
  /// attribute (or adds more keys, e.g. `contact:phone` for `phone`),
  /// do override the [hasRelevantKey] method.
  final String key;

  /// Field label to display alongside it. Can be overridden for
  /// a multi-line field in [buildWidgets].
  final String label;

  /// Icon for the field. Displayed only in the standard fields block
  /// in the full-page editor.
  final IconData? icon;

  /// Placeholder for text-based fields.
  final String? placeholder;

  /// Tag prerequisites for moving this field into the main block.
  /// If a field is in the "more fields" block, it's collapsed by default.
  /// When a prerequisite matches, it is moved to the main "fields" block.
  final FieldPrerequisite? prerequisite;

  /// Locations to determine whether to skip the field. It allows for
  /// country-specific fields.
  final LocationSet? locationSet;

  const PresetField({
    required this.key,
    required this.label,
    this.icon,
    this.placeholder,
    this.prerequisite,
    this.locationSet,
  });

  /// Builds a field-editing widget for the given [element].
  Widget buildWidget(OsmChange element);

  /// Tests whether the object has tags matching this field.
  /// The purpose is to check whether the field has a non-empty value.
  bool hasRelevantKey(Map<String, String> tags) => tags.containsKey(key);
}

class PresetFieldContext {
  late final String key;
  late final String label;
  late final String? placeholder;
  late final FieldPrerequisite? prerequisite;
  late final LocationSet? locationSet;

  PresetFieldContext(Map<String, dynamic> data) {
    key = data['key'];
    label = data['loc_label'] ?? data['label'] ?? data['name'] ?? key;
    placeholder = data['loc_placeholder'] ?? data['placeholder'];
    prerequisite = data.containsKey('prerequisiteTag')
        ? FieldPrerequisite.fromJson(data['prerequisiteTag'])
        : null;
    locationSet = data['locations'] == null
        ? null
        : LocationSet.fromJson(jsonDecode(data['locations']));
  }
}