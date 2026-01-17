import 'package:every_door_plugin/helpers/tags/element_kind.dart';
import 'package:every_door_plugin/models/amenity.dart';

/// This class contains age data for an amenity.
/// It is used for building a POI tile: the age flags control the checkmark
/// button, and the disused flag affects the tile style.
/// Use [from] to get the data from an [OsmChange] object, or fill directly.
class AmenityAgeData {
  /// Whether the object is "disused", that is, closed or obsolete.
  final bool isDisused;

  final bool showWarning;

  /// Whether the object is old and requires confirmation. Leave as null
  /// when the object does not need confirmation.
  final bool? isOld;

  /// Whether the original object before any modifications was old.
  /// If false, the checkmark button won't be tappable.
  final bool wasOld;

  AmenityAgeData({
    this.isDisused = false,
    this.showWarning = false,
    this.isOld,
    this.wasOld = false,
  });

  /// Get the information from [amenity].
  /// The [checkIntervals] maps [ElementKind] names to durations in days.
  /// It is expected to have at least the "amenity" key.
  static AmenityAgeData from(
    OsmChange amenity,
    Map<String, int> checkIntervals,
  ) {
    return AmenityAgeData(
      isDisused: amenity.isDisused,
      showWarning: false,
      isOld: null,
      wasOld: false,
    );
  }
}
