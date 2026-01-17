import 'package:every_door_plugin/helpers/tags/element_kind.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class TypeChooserPage extends StatefulWidget {
  final LatLng? location;
  final bool launchEditor;
  final ElementKindImpl? kinds;
  final List<String> defaults;

  const TypeChooserPage({
    this.location,
    this.launchEditor = true,
    this.kinds,
    this.defaults = const [],
  });

  @override
  State createState() => throw UnimplementedError();
}
