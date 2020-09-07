import 'package:flutter/material.dart';
import 'dart:math' as math;

class LShape {
  final LBorderShape borderShape;
  final BorderRadiusGeometry borderRadius;
  final BorderSide side;

  const LShape({
    this.borderShape: LBorderShape.RoundedRectangle,
    this.borderRadius: const BorderRadius.all(Radius.circular(10)),
    this.side: const BorderSide(
        color: Colors.transparent, style: BorderStyle.solid, width: 0),
  });
}

class LShadow {
  final Color highlightColor;
  final double highlightDistance;
  final double highlightBlur;
  final double highlightSpread;

  final Color shadowColor;
  final double shadowDistance;
  final double shadowBlur;
  final double shadowSpread;
  final Offset shadowOffset;

  const LShadow({
    this.highlightColor = LHighlightShadowColor,
    this.highlightDistance = 3,
    this.highlightBlur = 6,
    this.highlightSpread = 1,
    this.shadowColor = LDarkShadowColor,
    this.shadowDistance = 3,
    this.shadowBlur = 6,
    this.shadowSpread = 1,
    this.shadowOffset,
  });
}

/// 为组件设置边角。
///
/// Set corners for widget
class LCorner {
  final double leftTopCorner;
  final double rightTopCorner;
  final double rightBottomCorner;
  final double leftBottomCorner;

  const LCorner({
    this.leftTopCorner = 0,
    this.rightTopCorner = 0,
    this.rightBottomCorner = 0,
    this.leftBottomCorner = 0,
  });

  LCorner.all(double radius)
      : leftTopCorner = radius,
        rightTopCorner = radius,
        rightBottomCorner = radius,
        leftBottomCorner = radius;
}

/// 边角风格。
/// [round] - 圆角
/// [bevel] - 斜角
///
/// Rounded corner style.
/// [round]-rounded corners
/// [bevel]-beveled corners
enum LCornerStyle {
  round,
  bevel,
}

typedef LGroupContorllerClickCallback = List<Color> Function(
    Widget stateChanged, bool selected, List<Widget> widgets);

class LGroupController {
  final List<State> states = List();
  final LGroupContorllerClickCallback groupClickCallback;
  final bool mustBeSelected;
  LGroupController({this.mustBeSelected = false, this.groupClickCallback});
}

enum LGradientType {
  Linear,
  Radial,
  Sweep,
}

enum LLightOrientation {
  LeftTop,
  LeftBottom,
  RightTop,
  RightBottom,
}

enum LBorderShape {
  RoundedRectangle,
  ContinuousRectangle,
  BeveledRectangle,
}

enum LSurface {
  Flat, //平面
  Convex, //凸面
  Concave, //凹面
}

enum LState {
  Normal,
  Highlighted,
  Disable,
}

enum LAppearance {
  Llat,
  Neumorphism,
  Material,
}

enum LType {
  Button,
  Toggle,
}

typedef LColorForStateCallback = Color Function(
    Widget sender, LState state);
typedef LGradientForStateCallback = Gradient Function(
    Widget sender, LState state);
typedef LBorderForStateCallback = Border Function(
    Widget sender, LState state);
typedef LChildForStateCallback = Widget Function(
    Widget sender, LState state);
typedef LTapEventForStateCallback = void Function(
    Widget sender, LState state, bool checked);
typedef LShapeForStateCallback = LShape Function(
    Widget sender, LState state);
typedef LSurfaceForStateCallback = LSurface Function(
    Widget sender, LState state);

typedef LOnTapCallback = void Function(Widget sender, bool checked);
typedef LOnTapDownCallback = void Function(Widget sender, bool checked);
typedef LOnTapCancelCallback = void Function(Widget sender, bool checked);
typedef LOnTapUpCallback = void Function(Widget sender, bool checked);

//ZenUI库中所有组件的主颜色
const Color LPrimerColor = Colors.lightBlueAccent;
const Color LInnerShadowColor = Colors.black38;
const Offset LInnerShadowOffset = Offset(10, 10);
const Color LHighlightShadowColor = Colors.white;
const Color LDarkShadowColor = Colors.black;
const Color LDisableColor = Colors.grey;
