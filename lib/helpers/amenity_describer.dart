import 'package:every_door_plugin/helpers/poi_describer.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/located.dart';
import 'package:flutter/material.dart' show TextSpan;

/// Amenity indicator controls the information present in a POI tile.
/// Used by [AmenityDescriber] to build a tile content.
/// It usually returns a single icon for a missing property, and
/// maybe some more information when the property is present.
abstract class AmenityIndicator {
  /// Whether this indicator is useful for this object.
  bool applies(OsmChange amenity) => true;

  /// Returns an icon for when a property is missing.
  String? whenMissing(OsmChange amenity) => null;

  /// Returns an icon and maybe an abridged value for a property.
  String? whenPresent(OsmChange amenity) => null;
}

/// Describes an [OsmChange] object by calling [AmenityIndicator]s.
/// Without a single indicator added it just prints [OsmChange.typeAndName].
class AmenityDescriber implements PoiDescriber {
  /// A list of indicators with string keys.
  /// Keys do not matter, they are here only to allow
  /// for predictable modification by plugins.
  final Map<String, AmenityIndicator> indicators = {};

  @override
  TextSpan describe(Located element) {
    return TextSpan(text: '???');
  }
}
