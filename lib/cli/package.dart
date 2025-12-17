import 'dart:convert' show json;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:every_door_plugin/helpers/yaml_map.dart';
import 'package:every_door_plugin/plugins/bindings/every_door_eval.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:flutter_map_eval/flutter_map_eval.dart' as fme;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class Locations {
  Directory? staticPluginRoot;
  Directory? codeRoot;
  Directory? distRoot;
  File? pubspecYaml;

  Locations() {
    staticPluginRoot = _findStaticPluginRoot();
    pubspecYaml = _findPubspec();
    codeRoot = _findCodeRoot();
    if (codeRoot != null || staticPluginRoot != null) {
      distRoot = Directory(
        "${(pubspecYaml?.parent ?? codeRoot?.parent ?? staticPluginRoot!).path}/dist",
      );
    }
  }

  bool get isValid => distRoot != null;

  Directory? _findStaticPluginRoot() {
    if (File("plugin/plugin.yaml").existsSync()) return Directory("plugin");
    if (File("plugin.yaml").existsSync()) return Directory(".");
    if (Directory("plugin").existsSync()) return Directory("plugin");
    return null;
  }

  Directory? _findCodeRoot() {
    final pubspecParent = pubspecYaml == null
        ? null
        : "${pubspecYaml!.parent.path}/lib";
    if (pubspecParent != null &&
        File("$pubspecParent/main.dart").existsSync()) {
      return Directory(pubspecParent);
    }

    if (File("lib/main.dart").existsSync()) return Directory("lib");
    if (File("main.dart").existsSync()) return Directory(".");
    if (File("../lib/main.dart").existsSync()) return Directory("../lib");
    return null;
  }

  File? _findPubspec() {
    for (final path in ['.', '..']) {
      final f = File("$path/pubspec.yaml");
      if (f.existsSync()) return f;
    }
    return null;
  }

  File? get pluginYaml => staticPluginRoot == null
      ? null
      : File("${staticPluginRoot!.path}/plugin.yaml");

  File dist(String id, String version) =>
      File("${distRoot!.path}/${id}_$version.edp");

  @override
  String toString() =>
      'Locations(pubspec="${pubspecYaml?.path}", plugin="${staticPluginRoot?.path}", code="${codeRoot?.path}")';
}

class Packager {
  static final _logger = Logger("Packager");

  Future<Map<String, dynamic>> buildPluginYaml(Locations locations) async {
    Map<String, dynamic> result = {};

    // First read the provided file. It has the lowest priority.
    final pluginYamlFile = locations.pluginYaml;
    if (pluginYamlFile != null && await pluginYamlFile.exists()) {
      final data = loadYaml(await pluginYamlFile.readAsString());
      if (data is YamlMap) {
        result = data.toMap();
      }
    }

    final pubspecFile = locations.pubspecYaml;
    if (pubspecFile != null && await pubspecFile.exists()) {
      final data = loadYaml(await pubspecFile.readAsString());
      if (data is YamlMap) {
        final pubspec = data.toMap();

        // Overwrite metadata values with every_door section.
        final edPart = pubspec['every_door'];
        if (edPart != null && edPart is Map) {
          for (final entry in edPart.entries) {
            result[entry.key] = entry.value;
          }
        }

        // And now copy the main fields, which have the highest priority.
        result['id'] = pubspec['name'];
        if (pubspec.containsKey('description')) {
          result['name'] = pubspec['description'];
        }
        final versionMatch = RegExp(
          r'^\d+\.\d+',
        ).matchAsPrefix(pubspec['version']);
        if (versionMatch != null) {
          result['version'] = versionMatch.group(0)!;
        }
        if (pubspec.containsKey('homepage')) {
          result['homepage'] = pubspec['homepage'];
        }
      }
    }

    return result;
  }

  Future<void> loadBindings(Compiler compiler, String name) async {
    final packagePath = 'package:every_door_plugin/bindings/$name.json';
    final packageUri = await Isolate.resolvePackageUri(Uri.parse(packagePath));
    if (packageUri == null) {
      throw FileSystemException("Cannot find $packagePath");
    }
    final contents = await File(p.fromUri(packageUri)).readAsString();
    final data = json.decode(contents) as Map<String, dynamic>;

    for (final $class in (data['classes'] as List).cast<Map>()) {
      compiler.defineBridgeClass(BridgeClassDef.fromJson($class.cast()));
    }
    for (final $enum in (data['enums'] as List).cast<Map>()) {
      compiler.defineBridgeEnum(BridgeEnumDef.fromJson($enum.cast()));
    }
    for (final $source in (data['sources'] as List).cast<Map>()) {
      compiler.addSource(DartSource($source['uri'], $source['source']));
    }
    for (final $function in (data['functions'] as List).cast<Map>()) {
      compiler.defineBridgeTopLevelFunction(
        BridgeFunctionDeclaration.fromJson($function.cast()),
      );
    }
  }

  Future<Uint8List> compileCode(Locations locations) async {
    String packageName;
    final pubspecData = loadYaml(await locations.pubspecYaml!.readAsString());
    if (pubspecData is! YamlMap) {
      throw ArgumentError("Could not read pubspec.yaml");
    }
    packageName = pubspecData.toMap()['name'];

    final compiler = Compiler();
    compiler.addPlugin(flutterEvalPlugin);
    for (final p in fme.plugins) {
      compiler.addPlugin(p);
    }
    compiler.addPlugin(EveryDoorPlugin());
    // await loadBindings(compiler, 'flutter_eval');

    Map<String, String> addFiles(Directory dir) {
      final result = <String, String>{};
      if (!dir.existsSync()) return result;
      for (final file in dir.listSync()) {
        if (file is File && file.path.endsWith('.dart')) {
          final fileData = file.readAsStringSync();
          final rel = p
              .relative(file.path, from: locations.codeRoot!.path)
              .replaceAll('\\', '/');
          result[rel] = fileData;
        } else if (file is Directory) {
          result.addAll(addFiles(file));
        }
      }
      return result;
    }

    final data = {packageName: addFiles(locations.codeRoot!)};
    final program = compiler.compile(data);
    return program.write();
  }

  Future<void> run() async {
    final locations = Locations();
    if (!locations.isValid) {
      throw ArgumentError("Cannot find the plugin source");
    }

    final pluginData = await buildPluginYaml(locations);
    _logger.info('Found plugin "${pluginData['id']}" v${pluginData['version']}');

    final dist = locations.dist(pluginData['id'], pluginData['version']);
    if (dist.existsSync()) {
      _logger.info("Overwriting file ${dist.path}");
      await dist.delete();
    }

    final zipOutput = OutputFileStream(dist.path);
    final zip = ZipEncoder();
    zip.startEncode(zipOutput, level: DeflateLevel.defaultCompression);

    // Write the plugin.yaml.
    zip.add(ArchiveFile.string("plugin.yaml", YamlWriter().write(pluginData)));

    // Write the compiled code.
    if (locations.codeRoot != null && locations.pubspecYaml != null) {
      zip.add(ArchiveFile.bytes("plugin.evc", await compileCode(locations)));
    }

    // Write the rest of static files.
    if (locations.staticPluginRoot != null) {
      for (final f in locations.staticPluginRoot!.listSync(recursive: true)) {
        if (f is File) {
          if (p.isWithin(dist.parent.path, f.path)) continue;
          final path = p.relative(f.path, from: locations.staticPluginRoot!.path);
          if (path == 'plugin.yaml') continue;
          _logger.info('Adding $path');
          zip.add(ArchiveFile.bytes(path, await f.readAsBytes()));
        }
      }
    }

    zip.endEncode();
  }
}