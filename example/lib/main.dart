import 'dart:convert' show json, utf8;

import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:every_door_plugin/plugins/every_door_plugin.dart';
import 'package:every_door_plugin/plugins/ext_overlay.dart';
import 'package:every_door_plugin/plugins/interface.dart';
import 'package:every_door_plugin/screens/modes/definitions/classic.dart';
import 'package:every_door_plugin/widgets/map_button.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:logging/logging.dart';

EveryDoorPlugin main() => PanoramaxDemoPlugin();

class PanoramaxDemoPlugin extends EveryDoorPlugin {
  static const kEndpoint = 'panoramax.openstreetmap.fr';
  bool apiFound = false;

  @override
  Future<void> install(EveryDoorApp app) async {
    app.logger.info("Installing plugin!");
    final apiResponse = await http.get(
      Uri.https(kEndpoint, '/api/configuration'),
    );
    if (apiResponse.statusCode == 200) {
      final response = json.decode(utf8.decode(apiResponse.bodyBytes));
      app.logger.info('API response ok, name: ${response["name"]["label"]}');
      apiFound = true;
    }

    // app.addMode(TestMode(app));

    app.events.onDownload((location) async {
      // TODO: download and put into the database.
      // final bounds = boundsFromRadius(location, 1000);
    });

    app.events.onModeCreated((mode) async {
      app.logger.info("Mode created: ${mode.name}");

      if (mode.name == 'micro') {
        mode.addMapButton(
          MapButton(
            icon: MultiIcon(emoji: 'P'),
            onPressed: (context) {
              app.providers.location = LatLng(59.409680, 24.631112);
            },
          ),
        );
      }
    });

    if (apiFound) {
      app.addOverlay(
        ExtOverlay(
          id: 'panoramax',
          build: (context, data) {
            if (data == null || data is! List) return Container();
            final photos = data as List<PanoramaxPhoto>;
            if (photos.isEmpty) return Container();
            return MarkerLayer(
              markers: [
                for (final photo in photos) buildMarker(app, context, photo),
              ],
            );
          },
          update: (bounds) async {
            return await queryPhotos(app.logger, bounds);
          },
        ),
      );
    }
  }

  Marker buildMarker(
    EveryDoorApp app,
    BuildContext context,
    PanoramaxPhoto photo,
  ) => Marker(
    point: photo.location,
    rotate: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final url = photo.thumbnailUrl; // photo.imageUrl ?? photo.thumbnailUrl;
        app.logger.info('tapped on a photo ${photo.id} with url $url');
        if (url == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Photo ${photo.id} has no image url')),
          );
        } else {
          await showModalBottomSheet(
            context: context,
            builder: (_) => SafeArea(child: Image.network(url)),
          );
        }
      },
      child: Text('📷', style: TextStyle(fontSize: 30.0)),
    ),
    height: 30,
    width: 30,
  );

  Future<List<PanoramaxPhoto>> queryPhotos(
    Logger log,
    LatLngBounds bounds,
  ) async {
    final response = await http.get(
      Uri.https(kEndpoint, '/api/search', {
        'bbox': [
          bounds.west,
          bounds.south,
          bounds.east,
          bounds.north,
        ].join(','),
        'limit': '40',
      }),
    );
    if (response.statusCode != 200) {
      log.warning('Got response ${response.statusCode} ${response.body}');
      return [];
    }
    final data = json.decode(utf8.decode(response.bodyBytes)) as Map;
    if (!data.containsKey('features')) return [];
    final result = <PanoramaxPhoto>[];
    for (final feature in data['features'] as List) {
      if (feature is Map) {
        try {
          result.add(PanoramaxPhoto.fromJson(feature));
        } on Exception catch (_) {
          log.warning('Failed to decode json: $feature');
        }
      }
    }
    log.info('Downloaded ${result.length} photos');
    return result;
  }

  @override
  Widget buildSettingsPane(EveryDoorApp app, BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Better icon'),
          value: app.preferences.getBool('better_icon') ?? false,
          onChanged: (bool value) async {
            await app.preferences.setBool('better_icon', value);
            app.repaint();
          },
        ),
      ],
    );
  }
}

class PanoramaxPhoto {
  final String id;
  final String? thumbnailUrl;
  final String? imageUrl;
  final bool ready;
  final LatLng location;

  PanoramaxPhoto({
    required this.id,
    this.thumbnailUrl,
    this.imageUrl,
    required this.location,
    required this.ready,
  });

  factory PanoramaxPhoto.fromJson(Map data) {
    final props = data['properties'] as Map;
    final thumbnail = props['geovisio:thumbnail'];
    final image = props['geovisio:image'];
    final coords = data['geometry']['coordinates'] as List;
    return PanoramaxPhoto(
      id: data['id'],
      ready: props['geovisio:status'] == 'ready',
      thumbnailUrl: thumbnail is String ? thumbnail : null,
      imageUrl: image is String ? image : null,
      location: LatLng(coords[1], coords[0]),
    );
  }
}

class TestMode extends ClassicModeDefinition {
  TestMode(EveryDoorApp app) : super.fromPlugin(app);

  @override
  MultiIcon getIcon(BuildContext context, bool outlined) =>
      MultiIcon(emoji: '⭐');

  @override
  String get name => 'test';

  @override
  bool isOurKind(OsmChange element) => true;
}
