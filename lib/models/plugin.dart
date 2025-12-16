import 'dart:io';

import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/helpers/plugin_i18n.dart';
import 'package:every_door_plugin/models/version.dart';
import 'package:every_door_plugin/plugins/every_door_plugin.dart';
import 'package:flutter/material.dart';

final kApiVersion = PluginVersion('1.1');

/// Thrown only when loading a plugin. Prints the enclosed exception as well.
class PluginLoadException implements Exception {
  final String message;
  final Exception? parent;

  PluginLoadException(this.message, [this.parent]);

  @override
  String toString() {
    return parent == null ? message : "$message: $parent";
  }
}

/// Plugin metadata. Basically an identifier and a dictionary
/// from the bundled yaml file.
class PluginData {
  final String id;
  final Map<String, dynamic> data;
  final bool installed;
  final PluginVersion version;

  PluginData(this.id, this.data, {this.installed = true})
    : version = PluginVersion(data['version']);

  String get name => data['name'] ?? id;
  String get description => data['description'] ?? '';
  String? get author => data['author'];
  PluginVersionRange? get apiVersion =>
      data.containsKey('api') ? PluginVersionRange(data['api']) : null;

  Uri? get url =>
      data.containsKey('source') ? Uri.tryParse(data['source']) : null;
  Uri? get homepage =>
      data.containsKey('homepage') ? Uri.tryParse(data['homepage']) : null;

  MultiIcon? get icon => null;

  @override
  bool operator ==(Object other) => other is PluginData && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Plugin metadata. Same as [PluginData], but with added service methods
/// for retrieving localizations and assets. Data read from the plugin
/// metadata is final, but the [active] flag can be changed in runtime.
/// Same with [instance]: it is initialized when the plugin is made active,
/// and reset when it is disabled.
abstract class Plugin extends PluginData {
  bool active;
  EveryDoorPlugin? instance;
  final Directory directory;

  Plugin({
    required String id,
    required Map<String, dynamic> data,
    required this.directory,
  }) : active = false,
       super(id, data);

  String? get intro => data['intro'];

  @override
  MultiIcon? get icon =>
      data.containsKey('icon') ? loadIcon(data['icon']) : null;

  PluginLocalizationsBranch getLocalizationsBranch(String prefix);

  String translate(
    BuildContext context,
    String key, {
    Map<String, dynamic>? args,
  });

  File resolvePath(String name);

  Directory resolveDirectory(String name);

  MultiIcon loadIcon(String name, [String? tooltip]);

  Future<void> showIntro(BuildContext context) async {}
}
