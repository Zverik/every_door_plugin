import 'package:flutter/material.dart';

class NumberedMarker extends StatelessWidget {
  final int? index;
  final Color color;

  const NumberedMarker({super.key, this.index, this.color = Colors.white});

  @override
  Widget build(BuildContext context) => Container();
}

class ColoredMarker extends StatelessWidget {
  final Color color;
  final bool isIncomplete;

  const ColoredMarker(
      {super.key, this.color = Colors.black, this.isIncomplete = false});

  @override
  Widget build(BuildContext context) => Container();
}
