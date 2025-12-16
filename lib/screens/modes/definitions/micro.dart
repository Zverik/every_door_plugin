import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/helpers/legend.dart';
import 'package:every_door_plugin/plugins/interface.dart';
import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract class MicromappingModeDefinition extends BaseModeDefinition {
  static const kMicroStuffInList = 24;

  List<OsmChange> nearestPOI = [];
  List<LatLng> otherPOI = [];
  bool enableZoomingIn = true;
  LegendController legend = LegendController();

  MicromappingModeDefinition.fromPlugin(EveryDoorApp app);

  @override
  MultiIcon getIcon(BuildContext context, bool outlined) => MultiIcon();

  void updateLegend(BuildContext context) {
  }

  @override
  bool isOurKind(OsmChange element) => false;

  @override
  updateNearest(LatLngBounds bounds) async {
  }

  void openEditor(BuildContext context, LatLng location) async {
  }

  @override
  void updateFromJson(Map<String, dynamic> data, Plugin plugin) {
  }

  Widget buildMarker(int index, OsmChange element, bool isZoomedIn) => Container();
}
