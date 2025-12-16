import 'package:every_door_plugin/models/imagery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ExtOverlay extends Imagery {
  final Widget Function(BuildContext context, dynamic data) build;
  final int updateInMeters;
  final Future<dynamic> Function(LatLngBounds)? update;

  ExtOverlay({
    required super.id,
    super.attribution,
    this.updateInMeters = 0,
    required this.build,
    this.update,
  }) : super(overlay: true);

  @override
  Widget buildLayer({bool reset = false}) => Placeholder();
}