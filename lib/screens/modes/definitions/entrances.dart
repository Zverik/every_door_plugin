import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/helpers/tags/element_kind.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/plugins/interface.dart';
import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:every_door_plugin/widgets/entrance_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract class EntrancesModeDefinition extends BaseModeDefinition {
  List<OsmChange> nearest = [];
  LatLng? newLocation;

  EntrancesModeDefinition.fromPlugin(EveryDoorApp app);

  @override
  String get name => "entrances";

  @override
  MultiIcon getIcon(BuildContext context, bool outlined) => MultiIcon();

  ElementKindImpl getOurKind(OsmChange element) => ElementKind.entrance;

  @override
  bool isOurKind(OsmChange element) =>
      getOurKind(element) != ElementKind.unknown;

  @override
  Future<void> updateNearest(LatLngBounds bounds) async {
  }

  double get adjustZoomPrimary => 0.0;

  double get adjustZoomSecondary => 0.0;

  SizedMarker? buildMarker(OsmChange element);

  MultiIcon? getButton(BuildContext context, bool isPrimary);

  void openEditor({
    required BuildContext context,
    OsmChange? element,
    LatLng? location,
    bool? isPrimary,
  });

  Widget disambiguationLabel(BuildContext context, OsmChange element) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(element.typeAndName, style: TextStyle(fontSize: 20.0)),
    );
  }

  @override
  void updateFromJson(Map<String, dynamic> data, Plugin plugin) {
  }
}