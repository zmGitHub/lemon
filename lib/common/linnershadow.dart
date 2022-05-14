import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lemon/common/ldefine.dart';


class LInnerShadow extends SingleChildRenderObjectWidget {
  const LInnerShadow({
    Key? key,
    this.blur = 10,
    this.color = LInnerShadowColor,
    this.offset = LInnerShadowOffset,
    Widget? child,
  }) : super(key: key, child: child);

  final double? blur;
  final Color? color;
  final Offset? offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _ZenUIRenderInnerShadow renderObject = _ZenUIRenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _ZenUIRenderInnerShadow renderObject) {
    renderObject
      ..color = color!
      ..blur = blur!
      ..dx = offset!.dx
      ..dy = offset!.dy;
  }
}

class _ZenUIRenderInnerShadow extends RenderProxyBox {
  late double blur;
  late Color color;
  late double dx;
  late double dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child!, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);
    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx, dy);
    context.paintChild(child!, offset);
    context.canvas..restore()..restore()..restore();
  }
}
