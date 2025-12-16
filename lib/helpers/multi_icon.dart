import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class encapsulates monochrome icons.
/// It replaces IconData class, allowing for raster
/// and vector images. An image should be rectangular,
/// recommended dimensions are 256×256.
class MultiIcon {
  final String? tooltip;

  MultiIcon({
    IconData? fontIcon,
    String? emoji,
    Uint8List? imageData,
    Uint8List? svgData,
    Uint8List? siData,
    String? imageUrl,
    String? asset,
    this.tooltip,
  });

  MultiIcon withTooltip(String? tooltip) => this;

  Widget getWidget({
    BuildContext? context,
    double? size,
    Color? color,
    String? semanticLabel,
    bool icon = true,
    bool fixedSize = true,
  }) {
    return SizedBox(width: size, height: size);
  }

  @override
  String toString() {
    return 'MultiIcon(empty)';
  }
}
