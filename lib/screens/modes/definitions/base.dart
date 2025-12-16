import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/helpers/tags/element_kind.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/imagery.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/widgets/map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show LatLngBounds;

abstract class BaseModeDefinition extends ChangeNotifier {
  String get name;

  MultiIcon getIcon(BuildContext context, bool outlined);

  bool isOurKind(OsmChange element) => false;

  Iterable<Imagery> get overlays;
  Iterable<MapButton> get buttons;

  void addMapButton(MapButton button) {
  }

  void removeMapButton(String id) {
  }

  void addOverlay(Imagery imagery) {
  }

  Future<List<OsmChange>> getNearestChanges(LatLngBounds bounds,
      {int maxCount = 200, bool filter = true}) async => [];

  Future<void> updateNearest(LatLngBounds bounds);

  void updateFromJson(Map<String, dynamic> data, Plugin plugin);

  List<ElementKindImpl>? parseKinds(dynamic data) => null;

  List<Widget> mapLayers() => [];
}
