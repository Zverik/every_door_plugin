import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/preset.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// An object editor page. Expects an OSM-like sourced object, that is,
/// an [OsmChange]. In particular, the object needs to have tags that
/// behave in accordance with OSM model, e.g. for lifecycle prefixes.
/// For editing [Located] you would need to create your own pages.
class PoiEditorPage extends StatefulWidget {
  /// The object to edit. Set to null and fill [preset] and [location]
  /// if creating a new one.
  final OsmChange? amenity;

  /// For new objects, a preset from which to fill the tags and get field list.
  /// Should be specified (for new objects). Needs to have both [Preset.addTags]
  /// and [Preset.fields] non-empty. When the preset type is [PresetType.nsi],
  /// the actual preset is detected based on [Preset.addTags].
  final Preset? preset;

  /// The location for a new object.
  final LatLng? location;

  /// Set to true if the object has been modified externally without saving
  /// to the internal database. For example, when the object has been edited
  /// in a bottom sheet, but then this editor page has been called with it.
  final bool isModified;

  const PoiEditorPage({
    this.amenity,
    this.preset,
    this.location,
    this.isModified = false,
  });

  @override
  State createState() => throw UnimplementedError();
}
