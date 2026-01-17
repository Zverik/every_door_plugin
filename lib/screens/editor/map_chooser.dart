import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapChooserPage extends StatefulWidget {
  final LatLng? location;
  final bool creating;

  const MapChooserPage({
    this.location,
    this.creating = false,
  });

  @override
  State createState() => throw UnimplementedError();
}
