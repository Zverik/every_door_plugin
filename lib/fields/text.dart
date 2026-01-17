// Copyright 2022-2025 Ilya Zverev
// This file is a part of Every Door, distributed under GPL v3 or later version.
// Refer to LICENSE file and https://www.gnu.org/licenses/gpl-3.0.html for details.
import 'package:every_door_plugin/models/amenity.dart';
import 'package:flutter/material.dart';
import 'package:every_door_plugin/models/field.dart';

enum TextFieldCapitalize { no, asName, sentence, all }

class TextPresetField extends PresetField {
  final TextInputType keyboardType;
  final TextFieldCapitalize capitalize;
  final int? maxLines;
  final bool showClearButton;

  const TextPresetField({
    required super.key,
    required super.label,
    super.icon,
    super.placeholder,
    super.prerequisite,
    super.locationSet,
    this.keyboardType = TextInputType.text,
    this.capitalize = TextFieldCapitalize.sentence,
    this.maxLines,
    this.showClearButton = false,
  });

  @override
  Widget buildWidget(OsmChange element) => TextInputField(this, element);
}

class TextInputField extends StatefulWidget {
  final TextPresetField field;
  final OsmChange element;

  const TextInputField(this.field, this.element);

  @override
  State createState() => throw UnimplementedError();
}
