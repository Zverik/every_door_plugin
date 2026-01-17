import 'package:flutter/material.dart';

/// Field with multiple choices, presented in a row. It is a part of many
/// standard fields: combo, radio, checkbox.
class RadioField extends StatefulWidget {
  /// Which options — meaning tag values — are available.
  final List<String> options;

  /// Labels for options. If preset, they replace values in presentation.
  final List<String>? labels;

  /// Widget labels: for example, images. Has preference over [labels].
  /// Basically the latter are wrapped in [Text] and merged into a single list.
  final List<Widget>? widgetLabels;

  /// The currently present tag value. Can be empty of course. Can also contain
  /// several values joined by a semicolon ("yes;no").
  final String? value;

  /// Instead of [value], specify this when the field expects multiple values.
  /// See [multi].
  final List<String>? values;

  /// If set, the field will wrap at the edge of the screen. Otherwise it
  /// will be horizontally scrollable.
  final bool wrap;

  /// Whether to allow multi-selection.
  final bool multi;

  /// Whether to keep the order of options. If not set, and the options do not
  /// fit on the screen, when tapping one, it is moved to the front. This
  /// might be unwelcome, for example, with numeric options.
  final bool keepOrder;

  /// Keep the first options before all others. Use only for a fake first option,
  /// e.g. that launches a dialog. Warning: this implies the first option can never be a value.
  final bool keepFirst;

  /// A callback function for when the value (singular) changes. If multiple
  /// values can be chosen, they will be joined with a semicolon.
  final Function(String?)? onChange;

  /// A callback function for multiple changed values, if enabled.
  final Function(List<String>)? onMultiChange;

  /// Creates a widget. Only [options] are technically required, but you
  /// should also specify either of [value] or [values], and a callback
  /// function between [onChange] and [onMultiChange].
  const RadioField({
    required this.options,
    this.labels,
    this.widgetLabels,
    this.value,
    this.values,
    this.wrap = false,
    this.multi = false,
    this.keepFirst = false,
    this.keepOrder = false,
    this.onChange,
    this.onMultiChange,
  });

  @override
  State createState() => throw UnimplementedError();
}
