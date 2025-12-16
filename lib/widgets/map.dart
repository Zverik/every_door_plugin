import 'package:every_door_plugin/widgets/map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

class CustomMapController {
  Function(Iterable<LatLng>)? zoomListener;
  MapController? mapController;
  GlobalKey? mapKey;

  void setLocation({LatLng? location, double? zoom}) {
    if (mapController != null) {
      mapController!.move(location ?? mapController!.camera.center,
          zoom ?? mapController!.camera.zoom);
    }
  }

  void zoomToFit(Iterable<LatLng> locations) {
    if (locations.isNotEmpty) {
      if (zoomListener != null) zoomListener!(locations);
    }
  }
}

/// General map widget for every map in Every Door. Encloses layer management,
/// interaction, additional buttons etc etc.
class CustomMap extends StatefulWidget {
  final void Function(LatLng, double Function(LatLng))? onTap;
  final CustomMapController? controller;
  final List<Widget> layers;
  final List<MapButton> buttons;
  final bool drawZoomButtons;

  /// When there is a floating button on the screen, zoom buttons
  /// need to be moved higher.
  final bool hasFloatingButton;
  final bool drawStandardButtons;
  final bool drawPinMarker;
  final bool faintWalkPath;
  final bool interactive;
  final bool track;
  final bool onlyOSM;
  final bool allowRotation;
  final bool updateState;
  final bool switchToNavigate;

  const CustomMap({
    super.key,
    this.onTap,
    this.controller,
    this.layers = const [],
    this.buttons = const [],
    this.drawZoomButtons = true,
    this.hasFloatingButton = false,
    this.drawStandardButtons = true,
    this.drawPinMarker = true,
    this.faintWalkPath = true,
    this.interactive = true,
    this.track = true,
    this.onlyOSM = false,
    this.allowRotation = true,
    this.switchToNavigate = true,
    this.updateState = false,
  });

  @override
  State createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
