import 'package:latlong2/latlong.dart' show LatLng;

abstract class PluginProviders {
  /// Get the current location of the main screen.
  LatLng get location;

  /// Learn whether we're moving the map automatically with the user
  /// movement.
  bool get isTracking;

  /// Get the compass direction.
  double? get compass;

  /// Teleports the map to the given location.
  set location(LatLng value);

  /// Changes the map zoom level.
  set zoom(double value);

  // TODO: do we need watching?
}
