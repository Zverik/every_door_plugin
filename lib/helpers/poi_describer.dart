import 'package:every_door_plugin/models/amenity.dart';
import 'package:every_door_plugin/models/located.dart';
import 'package:flutter/material.dart';

/// Description generator for POI tiles. Instances of this interface
/// are passed to [PoiTile] so it can provide all the information
/// needed to assess the correctness of the data.
abstract class PoiDescriber {
  TextSpan describe(Located element);
}

/// Simple describer returns the [OsmChange.typeAndName] and nothing else.
/// It will be crossed out if disused.
class SimpleDescriber implements PoiDescriber {
  @override
  TextSpan describe(Located element) {
    return TextSpan(text: '???');
  }
}
