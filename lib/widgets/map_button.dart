import 'package:every_door_plugin/helpers/multi_icon.dart';
import 'package:flutter/material.dart';

class OverlayButtonWidget extends StatelessWidget {
  /// Padding for the button.
  final EdgeInsets? padding;

  /// To which corner of the map should the button be aligned.
  final Alignment alignment;

  /// Function to call when the button is pressed.
  final void Function(BuildContext) onPressed;

  /// Function to call on long tap.
  final void Function(BuildContext)? onLongPressed;

  /// Icon to display.
  final IconData icon;

  /// Set to false to hide the button.
  final bool enabled;

  /// Tooltip and semantics message.
  final String? tooltip;

  /// Add safe area to the bottom padding. Enable when the map is full-screen.
  final bool safeBottom;

  /// Add safe area to the right side padding.
  final bool safeRight;

  const OverlayButtonWidget({
    super.key,
    required this.alignment,
    this.padding,
    required this.onPressed,
    this.onLongPressed,
    required this.icon,
    this.enabled = true,
    this.tooltip,
    this.safeBottom = false,
    this.safeRight = false,
  });

  @override
  Widget build(BuildContext context) => Container();
}

class MapButtonColumn extends StatelessWidget {
  /// Padding for the button.
  final EdgeInsets? padding;

  /// To which corner of the map should the button be aligned.
  final Alignment alignment;

  /// Add safe area to the bottom padding. Enable when the map is full-screen.
  final bool safeBottom;

  /// Add safe area to the right side padding.
  final bool safeRight;

  /// Enclosed button.
  final List<MapButton> buttons;

  const MapButtonColumn({
    super.key,
    required this.buttons,
    required this.alignment,
    this.padding,
    this.safeBottom = false,
    this.safeRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MapButton extends StatelessWidget {
  /// An optional identifier to refer this button later.
  final String? id;

  /// Function to call when the button is pressed.
  final void Function(BuildContext) onPressed;

  /// Function to call on long tap.
  final void Function(BuildContext)? onLongPressed;

  /// Icon to display.
  final MultiIcon? icon;

  /// Widget to display when there's no icon.
  final Widget? child;

  /// Set to false to hide the button.
  final bool enabled;

  /// Tooltip and semantics message.
  final String? tooltip;

  const MapButton({
    super.key,
    this.id,
    required this.onPressed,
    this.onLongPressed,
    this.icon,
    this.child,
    this.enabled = true,
    this.tooltip,
  }) : assert(icon != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
