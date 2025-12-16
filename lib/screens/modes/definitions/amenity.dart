import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/plugins/interface.dart';
import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract class AmenityModeDefinition extends BaseModeDefinition {
  static const _kAmenitiesInList = 12;

  List<OsmChange> nearestPOI = [];
  List<LatLng> otherPOI = [];

  AmenityModeDefinition.fromPlugin(EveryDoorApp app);

  int get maxTileCount => _kAmenitiesInList;

  @override
  updateNearest(LatLngBounds bounds) async {
  }

  void openEditor(BuildContext context, LatLng location) async {
  }

  Widget buildMarker(int index, OsmChange element) => Container();

  bool isCountedOld(OsmChange element, int age) => false;

  @override
  void updateFromJson(Map<String, dynamic> data, Plugin plugin) {
  }
}
