import 'dart:math';

import 'package:flutter/material.dart';

class LAvatar extends StatelessWidget {

  const LAvatar({
    Key? key,
    this.width = 42,
    this.height = 42,
    required this.child,
    this.radius,
    this.decoration,
  }) : super(key: key);

  final double width;
  final double height;
  final Decoration? decoration;
  final Widget child;
  /// Default is width / 2, if width is null, radius = 1.
  final double? radius;


  @override
  Widget build(BuildContext context) {
    final double rad = radius ?? (width != null ? max(width / 2, 1) : 1);
    final BorderRadius borderRadius = BorderRadius.all(Radius.circular(rad));
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: width,
        height: height,
        decoration: decoration??BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}
