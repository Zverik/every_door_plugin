// Copyright 2022-2025 Ilya Zverev
// This file is a part of Every Door, distributed under GPL v3 or later version.
// Refer to LICENSE file and https://www.gnu.org/licenses/gpl-3.0.html for details.
import 'package:every_door_plugin/models/amenity.dart';
import 'package:flutter/material.dart';
import 'package:every_door_plugin/models/field.dart';

class ComboOption {
  final String value;
  final String? label;
  final Widget? widget;

  const ComboOption(this.value, {this.label, this.widget});

  ComboOption withLabel(String label) {
    return ComboOption(value, label: label, widget: widget);
  }

  @override
  String toString() => '$value($label)';
}

enum ComboType {
  /// surface=asphalt / dirt / ...
  regular,

  /// building=yes (default) / apartments / ...
  type,

  /// cuisine=russian;pizza;coffee
  semi,

  /// currency:USD=yes + currency:EUR=yes
  multi,
}

const kComboMapping = <String, ComboType>{
  'combo': ComboType.regular,
  'typeCombo': ComboType.type,
  'multiCombo': ComboType.multi,
  'semiCombo': ComboType.semi,
};

class ComboPresetField extends PresetField {
  final ComboType type;
  final List<ComboOption> options;
  final bool customValues;
  final bool snakeCase;

  const ComboPresetField({
    required super.key,
    required super.label,
    super.icon,
    super.prerequisite,
    super.locationSet,
    required this.type,
    required this.options,
    this.customValues = true,
    this.snakeCase = true,
  });

  bool get isSingularValue {
    return type == ComboType.regular || type == ComboType.type;
  }

  @override
  Widget buildWidget(OsmChange element) => RadioComboField(this, element);

  @override
  bool hasRelevantKey(Map<String, String> tags) {
    if (type == ComboType.multi) {
      for (final k in tags.keys) if (k.startsWith(key)) return true;
      return false;
    }
    return tags.containsKey(key);
  }
}

class RadioComboField extends StatefulWidget {
  final ComboPresetField field;
  final OsmChange element;

  const RadioComboField(this.field, this.element);

  @override
  State createState() => throw UnimplementedError();
}