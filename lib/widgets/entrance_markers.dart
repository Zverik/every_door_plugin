import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SizedMarker {
  final Widget child;

  final double width;

  final double height;

  final bool rotate;

  final Alignment alignment;

  const SizedMarker({
    required this.child,
    required this.width,
    required this.height,
    this.rotate = false,
    this.alignment = Alignment.center,
  });

  Marker buildMarker({Key? key, required LatLng point}) {
    return Marker(
      key: key,
      point: point,
      width: width,
      height: height,
      rotate: rotate,
      child: child,
      alignment: alignment,
    );
  }
}

class BuildingMarker extends SizedMarker {
  BuildingMarker({bool isComplete = false, required String label})
    : super(
        width: 120.0,
        height: 60.0,
        rotate: true,
        child: Center(child: Container()),
      );
}

class AddressMarker extends SizedMarker {
  AddressMarker({required String label})
    : super(
        rotate: true,
        width: 90.0,
        height: 50.0,
        child: Center(child: Container()),
      );
}

class EntranceMarker extends SizedMarker {
  EntranceMarker({bool isComplete = false})
    : super(width: 50.0, height: 50.0, child: Center(child: Container()));
}

class IconMarker extends SizedMarker {
  IconMarker(MultiIcon icon)
    : super(
        width: 50.0,
        height: 50.0,
        child: Center(child: icon.getWidget(size: 30.0, icon: false)),
      );
}
