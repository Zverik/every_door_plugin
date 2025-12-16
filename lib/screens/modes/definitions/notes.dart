import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/models/note.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/plugins/interface.dart';
import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class NotesModeDefinition extends BaseModeDefinition {
  List<BaseNote> notes = [];

  NotesModeDefinition.fromPlugin(EveryDoorApp app);

  @override
  MultiIcon getIcon(BuildContext context, bool outlined) => MultiIcon();

  @override
  Future<void> updateNearest(LatLngBounds bounds) async {
  }

  @override
  void updateFromJson(Map<String, dynamic> data, Plugin plugin) {
  }
}
