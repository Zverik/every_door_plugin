import 'package:every_door_plugin/helpers/tags/element_kind.dart';
import 'package:every_door_plugin/models/amenity.dart';
import 'package:flutter/material.dart';

/// A container representing a button on the editor pane.
abstract class EditorButton {
  /// Returns true if the button should be displayed. Note that this
  /// should rely on a general property and not some easily changed state,
  /// for example, on an [ElementKind]. You can use the
  /// [MaterialButton.enabled] flag instead.
  bool shouldDisplay(OsmChange amenity);

  /// Builds the button. Properties to override are usually title, onPressed,
  /// color, and textColor.
  MaterialButton build(BuildContext context, OsmChange amenity);
}