import 'package:every_door_plugin/plugins/interface.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

abstract class ClassicModeDefinition extends BaseModeDefinition {
  List<OsmChange> nearestPOI = [];

  ClassicModeDefinition.fromPlugin(EveryDoorApp plugin);

  @override
  void updateFromJson(Map<String, dynamic> data, Plugin plugin) {}

  @override
  updateNearest(LatLngBounds bounds) async {
  }

  void openEditor({
    required BuildContext context,
    OsmChange? element,
    LatLng? location,
  }) async {
  }

  Widget buildMarker(OsmChange element) => Container();
}
