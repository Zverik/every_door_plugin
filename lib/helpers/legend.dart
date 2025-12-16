import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:flutter/material.dart';

class LegendItem {
  final Color? color;
  final MultiIcon? icon;
  final String label;

  LegendItem({this.color, this.icon, required this.label});
  LegendItem.other(this.label)
      : color = kLegendOtherColor,
        icon = null;

  @override
  String toString() => 'LegendItem($color, $icon, "$label")';

  bool get isOther => color == kLegendOtherColor;
}

const kLegendOtherColor = Colors.black;
const kLegendNoColor = Colors.transparent;

class NamedColor extends Color {
  final String name;
  const NamedColor(this.name, super.value);
}

class PresetLabel {
  final String id;
  final String label;

  const PresetLabel(this.id, this.label);

  @override
  bool operator ==(Object other) =>
      other is PresetLabel && other.label == label && other.id == id;

  @override
  int get hashCode => Object.hash(id, label);
}

class LegendController extends ChangeNotifier {
  /// If false, does not add presets with icons defined to the legend. See
  /// [fixPreset] for adding icons.
  bool iconsInLegend = true;

  static const kLegendColors = [
    NamedColor('red', 0xfffd0f0b),
    NamedColor('teal', 0xff1dd798),
    NamedColor('yellow', 0xfffbc74e),
    NamedColor('magenta', 0xfff807e7),
    NamedColor('olive', 0xffc5bb0c),
    NamedColor('green', 0xffb9fb77),
    NamedColor('pink', 0xfff76492),
    NamedColor('cyan', 0xff15f5ed),
    NamedColor('purple', 0xffab3ded),
    NamedColor('orange', 0xfffd7d0b),
    NamedColor('darkblue', 0xff4e5aef), // needs to be all lowercase
    NamedColor('brown', 0xff9b7716),
  ];

  void fixPreset(String preset, {Color? color, MultiIcon? icon}) {
  }

  void resetFixes() {
  }

  /// Updates legend colors for [amenities]. The list should be ordered
  /// closest to farthest. The function tries to reuse colors.
  /// The [locale] is needed to translate labels.
  Future updateLegend(List<OsmChange> amenities,
      {Locale? locale, int maxItems = 6}) async {
  }

  List<LegendItem> get legend => const [];

  LegendItem? getLegendItem(OsmChange amenity) => null;
}
