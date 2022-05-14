import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lemon/common/ldefine.dart';
import 'package:lemon/common/linnershadow.dart';


class LControl extends StatefulWidget {
  const LControl({
    Key? key,
    this.componentId = 'componentId', //默认的componentId
    this.width,
    this.height,
    this.lightOrientation = LLightOrientation.LeftTop, //默认光源为左上角
    this.color = LPrimerColor,
    this.colorForCallback,
    this.gradient,
    this.gradientLorCallback,
    this.surface = LSurface.Flat, //默认表面形状为“凸面”
    this.surfaceLorCallback,
    this.childForStateCallback,
    this.shape,
    this.shapeForStateCallback,
    this.disabled = false, //默认为不禁用
    this.margin,
    this.padding,
    this.maskColor,
    this.supportDropShadow = true,
    this.dropShadow = const LShadow(),
    this.supportInnerShadow = true,
    this.innerShadow = const LShadow(),
    this.appearance,
    this.controlType = LType.Button, //默认类型为button
    this.isSelected = false, //默认为非选中
    this.userInteractive = true,
    this.controller,
    this.child,
    this.onTapCallback,
    this.onTapDownCallback,
    this.onTapUpCallback,
    this.onTapCancelCallback,
    this.onHover,
    this.hoverColor,
  }) : super(key: key);
  //组件标识，可以随意填写，用来在特殊情况下标识当前组件
  final String? componentId;

  //组件宽高，不指定宽高的情况下，control的size会随内容变化而变化
  final double? width;
  final double? height;

  //组件的内外边距，默认均为0
  final EdgeInsetsGeometry? margin; //组件外边距
  final EdgeInsetsGeometry? padding; //组件内边距

  //组件视觉效果及外观设置
  //LAppearance，组件外观选项，支持三种外观，Llat（扁平风格）,Neumorphism（新拟态风格）,Material（材质风格）,
  //LLightOrientation 光源方向，分为左上、左下、右上、右下四个方向。用来控制光源照射方向，会影响高亮方向和阴影方向
  //LSurface 组件表面的视觉效果，  Llat（平面效果）、Convex（凸面效果）、Concave（凹面效果）该效果会随着光源而变化
  //LSurfaceForStateCallback 根据状态不同，返回不同的Surface
  //LShape 设置组件的边框及外形 支持RoundedRectangle（圆角）,ContinuousRectangle（连续弧度）,BeveledRectangle（斜角）三种形式
  //LShapeForStateCallback 根据状态不同，返回不同的Shape
  final LAppearance? appearance;
  final LLightOrientation? lightOrientation;
  final LSurface? surface;
  final LSurfaceForStateCallback? surfaceLorCallback;
  final LShape? shape;
  final LShapeForStateCallback? shapeForStateCallback;

  //阴影设置
  //supportDropShadow 是否支持外阴影，默认为支持
  //supportInnerShadow 是否支持内阴影，主要用于新拟态风格，默认为支持
  //当任何一种阴影的support属性设置为true后，整个组件内部会去掉阴影层，从而ji
  final bool? supportDropShadow;
  final LShadow? dropShadow;
  final bool? supportInnerShadow;
  final LShadow? innerShadow;

  //背景色设置，color与gradient为互斥关系，设置了gradient就会覆盖color
  //Color 设置单色背景色
  //LColorForStateCallback 根据状态不同，返回不同的Color
  //Gradient 设置渐变背景色
  //LGradientForStateCallback 根据状态不同，返回不同的Gradient
  //maskColor 蒙板颜色，主要用于风格中的一些视觉效果，大多数情况下不应该被修改
  final Color? color;
  final LColorForStateCallback? colorForCallback;
  final Gradient? gradient;
  final LGradientForStateCallback? gradientLorCallback;
  final Color? maskColor;

  //组件的类型，组件支持的类型， Button,Toggle,
  //isSelected仅在controlType == Toggle的时候有效，可以通过设置isSelected来控制默认是否为“按下”状态
  final LType? controlType;
  final bool? isSelected;

  //是否禁用，默认为false，设置为yes时，会激活所有的stateLorCallback回调
  final bool? disabled;
  //是否与用户产生交互，默认为true，设置为false后，不会发生任何变化，只是不再响应事件
  final bool? userInteractive;

  //子组件
  //LChildForStateCallback 子组件的callback方法，可以根据组件不同的状态来设置不同的子组件
  final Widget? child;
  final LChildForStateCallback? childForStateCallback;

  final LGroupController? controller;

  final LOnTapCallback? onTapCallback; //最近被点击后的callback
  final LOnTapDownCallback? onTapDownCallback;
  final LOnTapUpCallback? onTapUpCallback;
  final LOnTapCancelCallback? onTapCancelCallback;
  final ValueChanged<bool>? onHover;
  final Color? hoverColor;

  @override
  State<StatefulWidget> createState() {
    return LControlState();
  }
}

class LControlState extends State<LControl> {
  LState? controlState;

  Color? defaultColor;
  Color? currentColor;

  Gradient? defaultGradient;
  Gradient? currentGradient;


  Widget? defaultWidget;
  Widget? currentWidget;

  Border? defaultBorder;
  Border? currentBorder;

  LShape? defaultShape;
  LShape? currentShape;

  LSurface? defaultSurface = LSurface.Flat;
  LSurface? currentSurface = LSurface.Flat;

  bool isSelected = false;
  bool disabled = false;

  bool supportDropShadow = true;

  LType controlType = LType.Button;
  LAppearance appearance = LAppearance.Llat;
  LLightOrientation lightOrientation = LLightOrientation.LeftTop;

  late Color maskColor;

  bool _hovering = false;

//  MouseCursor effectiveMouseCursor;

  @override
  void initState() {
//    effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
//      MaterialStateMouseCursor.clickable,
//      <MaterialState>{
//        if (disabled) MaterialState.disabled,
//        if (_hovering) MaterialState.hovered,
////        if (_hasLocus) MaterialState.focused,
//      },
//    );
    controlState = LState.Normal;
    appearance = widget.appearance ?? LAppearance.Llat;
    supportDropShadow = widget.supportDropShadow ?? true;
    lightOrientation = widget.lightOrientation ?? LLightOrientation.LeftTop;
    controlType = widget.controlType ?? LType.Button;
    maskColor = widget.maskColor ?? Colors.black12;

    defaultColor = widget.color ?? LPrimerColor;
    defaultGradient = widget.gradient;

    if (widget.controller != null) {
      widget.controller!.states!.add(this);
    }

    isSelected = widget.isSelected ?? false;

    if (controlType == LType.Toggle) {
      controlState = isSelected ? LState.Highlighted : LState.Normal;
    }

    disabled = widget.disabled ?? false;
    if (disabled) {
      controlState = LState.Disable;
      defaultColor = LDisableColor;
      // defaultBackgroundColors = [LDisableColor, LDisableColor];
    }

    if (widget.colorForCallback != null) {
      currentColor = widget.colorForCallback!(widget, controlState!);
    }

    if (widget.gradientLorCallback != null) {
      currentGradient = widget.gradientLorCallback!(widget, controlState!);
    }

    // if (widget.backgroundColorsLorCallback != null) {
    //   currentBackgroundColors =
    //       widget.backgroundColorsLorCallback(widget, controlState);
    // }
    // currentBackgroundColors =
    //     _fixBackgroundColors(currentBackgroundColors, widget.backgroundColors);

    defaultShape = widget.shape ?? const LShape();
    currentShape = defaultShape;

    defaultWidget = widget.child!;
    if (widget.childForStateCallback != null) {
      currentWidget = widget.childForStateCallback!(widget, controlState!);
    }
    currentWidget = currentWidget ?? defaultWidget;

    defaultSurface = widget.surface!;
    if (widget.surfaceLorCallback != null) {
      currentSurface = widget.surfaceLorCallback!(widget, controlState!);
    }

    if (controlType == LType.Toggle && isSelected) {
      controlState = LState.Highlighted;
      _controlGestureHandlerLorState();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      controlState = LState.Disable;
      _controlGestureHandlerLorState();
      return createCoreControl();
    }
    if (widget.userInteractive == false) {
      return createCoreControl();
    }
    return MouseRegion(
//      cursor: effectiveMouseCursor,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          if (controlType == LType.Button) {
            controlState = LState.Highlighted;
          } else {
            if (widget.controller != null &&
                widget.controller!.mustBeSelected &&
                isSelected) {
              return;
            }
            isSelected = !isSelected;
            controlState = LState.Highlighted;
          }
          _controlGestureHandlerLorState();
          if (widget.onTapDownCallback != null) {
            widget.onTapDownCallback!(widget, isSelected);
          }
        },
        onTapUp: (TapUpDetails details) {
          if (widget.onTapUpCallback != null) {
            widget.onTapUpCallback!(widget, isSelected);
          }
        },
        onTapCancel: () {
          if (controlType == LType.Button) {
            controlState = LState.Normal;
          } else {
            controlState =
            isSelected ? LState.Highlighted : LState.Normal;
          }
          _controlGestureHandlerLorState();
          if (widget.onTapCancelCallback != null) {
            widget.onTapCancelCallback!(widget, isSelected);
          }
        },
        onTap: () {
          if (controlType == LType.Button) {
            controlState = LState.Normal;
            _controlGestureHandlerLorState();
          } else {
            controlState =
            isSelected ? LState.Highlighted : LState.Normal;
            if (widget.controller != null &&
                widget.controller!.states!.isNotEmpty) {
              final List<Widget> all = <Widget>[];
              Widget? changed;
              for (int i = 0; i < widget.controller!.states!.length; i++) {
                final LControlState state = widget.controller!.states![i] as LControlState;
                all.add(state.widget);
                if (state != this) {
                  if (state.isSelected == false &&
                      state.controlState == LState.Normal) {
                    continue;
                  }
                  state.isSelected = false;
                  state.controlState = LState.Normal;
                  state._controlGestureHandlerLorState();
                } else {
                  changed = widget;
                  _controlGestureHandlerLorState();
                }
              }
              if (widget.controller!.groupClickCallback != null) {
                widget.controller!.groupClickCallback!(changed, isSelected, all);
              }
            } else {
              _controlGestureHandlerLorState();
            }
          }
          if (widget.onTapCallback != null) {
            widget.onTapCallback!(widget, isSelected);
          }
        },
        child: createCoreControl(),
      ),
    );
  }

  void _handleMouseEnter(PointerEnterEvent event) => _handleHoverChange(true);
  
  void _handleMouseExit(PointerExitEvent event) => _handleHoverChange(false);
  
  void _handleHoverChange(bool hovering) {
    if (_hovering != hovering) {
      _hovering = hovering;
      widget.onHover?.call(_hovering);
    }
    if (widget.hoverColor != null) {
      _controlGestureHandlerLorState();
    }
  }

  //============> 工具函数

  Widget createCoreControl() {
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: ShapeDecoration(
        color: (currentGradient != null) ? null : currentColor,
        gradient: currentGradient,
        shape: _createShapeBorder(controlState!, false),
        shadows: _createDropShadowList(
            controlState, widget.dropShadow, supportDropShadow),
      ),
      foregroundDecoration: ShapeDecoration(
        shape: _createShapeBorder(controlState!, false),
      ),
      child: _createChildContainer(
          controlState!, widget.lightOrientation!, widget.innerShadow!),
    );
  }

  Widget _createChildContainer(LState state,
      LLightOrientation lightOrientation, LShadow innerShadow) {
    switch (appearance) {
      case LAppearance.Llat: //扁平风格，忽略所有阴影效果
        return Container(
          foregroundDecoration: _createSurfaceShape(),
          // decoration: ShapeDecoration(
          //   shape: _createShapeBorder(state, true),
          //   gradient: _createGradientBackgroundColorLorState(state),
          // ),
          padding: widget.padding,
          child: currentWidget,
        );
      case LAppearance.Material: //Google风格，不做内阴影
        return Container(
          // alignment: Alignment.center,
          foregroundDecoration: _createSurfaceShape(),
          // decoration: ShapeDecoration(
          //   shape: _createShapeBorder(state, true),
          //   gradient: _createGradientBackgroundColorLorState(state),
          // ),
          padding: widget.padding,
          child: currentWidget,
        );
      default: //LControlAppearance.Neumorphism
        if (widget.supportInnerShadow ?? true) {
          return LInnerShadow(
            blur: innerShadow.highlightBlur,
            color: _innerShadowColor(true, state, innerShadow)!,
            offset: _innerShadowOffset(false, state, innerShadow),
            child: LInnerShadow(
              blur: innerShadow.shadowDistance,
              color: _innerShadowColor(false, state, innerShadow)!,
              offset: _innerShadowOffset(true, state, innerShadow),
              child: Container(
                padding: widget.padding,
                foregroundDecoration: _createSurfaceShape(),
                decoration: ShapeDecoration(
                  color: (currentGradient != null) ? null : currentColor,
                  gradient: currentGradient,
                  shape: _createShapeBorder(state, true),
                  // gradient:
                  //     _createGradientBackgroundColorLorState(controlState),
                ),
                child: currentWidget,
              ),
            ),
          );
        } else {
          return Container(
            padding: widget.padding,
            foregroundDecoration: _createSurfaceShape(),
            decoration: ShapeDecoration(
              color: (currentGradient != null) ? null : currentColor,
              gradient: currentGradient,
              shape: _createShapeBorder(state, true),
              // gradient: _createGradientBackgroundColorLorState(state),
            ),
            child: currentWidget,
          );
        }
    }
  }

  //统一处理手势操作
  void _controlGestureHandlerLorState() {
    _updateState();
    setState(() {});
  }

  void _updateState() {
    if (widget.colorForCallback != null) {
      currentColor =
          widget.colorForCallback!(widget, controlState!);
      if (controlState == LState.Normal && widget.hoverColor != null && _hovering) {
          currentColor = widget.hoverColor!;
      }
    }
    
    if (widget.gradientLorCallback != null) {
      currentGradient =
          widget.gradientLorCallback!(widget, controlState!);
    }
    
    if (widget.childForStateCallback != null) {
      currentWidget =
          widget.childForStateCallback!(widget, controlState!);
    }
    
    if (widget.surfaceLorCallback != null) {
      currentSurface =
          widget.surfaceLorCallback!(widget, controlState!);
    }
    
    if (widget.shapeForStateCallback != null) {
      currentShape =
          widget.shapeForStateCallback!(widget, controlState!);
    }
  }

  //处理边框
  ShapeBorder _createShapeBorder(LState state, bool justShape) {
    if (widget.shapeForStateCallback != null) {
      currentShape =
          widget.shapeForStateCallback!(widget, state);
    } else {
      currentShape = defaultShape;
    }
    // justShape = false;

    switch (currentShape!.borderShape) {
      case LBorderShape.BeveledRectangle:
        return BeveledRectangleBorder(
          borderRadius: currentShape!.borderRadius,
          side: justShape ? BorderSide.none : currentShape!.side,
        );
      case LBorderShape.ContinuousRectangle:
        return ContinuousRectangleBorder(
          borderRadius: currentShape!.borderRadius,
          side: justShape ? BorderSide.none : currentShape!.side,
        );
      default:
        return RoundedRectangleBorder(
          borderRadius: currentShape!.borderRadius,
          side: justShape ? BorderSide.none : currentShape!.side,
        );
    }
  }

  List<BoxShadow> _createDropShadowList(
      LState? state, LShadow? dropShadow, bool canUseShadow) {
    final List<BoxShadow> shadows = <BoxShadow>[];
    switch (appearance) {
      case LAppearance.Llat: //扁平风格，忽略所有阴影效果
        break;
      case LAppearance.Material: //Google风格，只处理背光阴影
        if (canUseShadow == false) {
          return shadows;
        }
        dropShadow ??= const LShadow();
        if (dropShadow != null) {
          shadows.add(BoxShadow(
            color: dropShadow.shadowColor??const Color(0xFF000000),
            offset: dropShadow.shadowOffset!,
            blurRadius: dropShadow.shadowBlur,
            spreadRadius: dropShadow.shadowSpread,
          ));
        }

        break;
      default: //LControlAppearance.Neumorphism，新拟态风格，处理向光和背光两个阴影
        if (canUseShadow == false) {
          return shadows;
        }
        dropShadow ??= const LShadow();
        shadows.add(BoxShadow(
          color: dropShadow.highlightColor,
          offset: _dropShadowOffset(
              appearance, lightOrientation, state!, true, dropShadow)!,
          blurRadius:
          (state == LState.Highlighted) ? 0 : dropShadow.highlightBlur,
          spreadRadius: (state == LState.Highlighted)
              ? 0
              : dropShadow.highlightSpread,
        ));
        shadows.add(BoxShadow(
          color: dropShadow.shadowColor??const Color(0xFF000000),
          offset: _dropShadowOffset(
              appearance, lightOrientation, state, false, dropShadow)!,
          blurRadius:
          (state == LState.Highlighted) ? 0 : dropShadow.shadowBlur,
          spreadRadius:
          (state == LState.Highlighted) ? 0 : dropShadow.shadowSpread,
        ));
    }
    return shadows;
  }

  Offset? _dropShadowOffset(
      LAppearance appearance, //外观风格
      LLightOrientation lightOrientation, //光源方向，在LControlAppearance.Llat时无效
      LState state, //控件状态
      bool isHighlight, //当前是否处理高光，仅在LControlAppearance.Neumorphism时有效
      LShadow shadow) {
    //光影效果定义，仅在LControlAppearance.Neumorphism且isHighlight=true时处理高光
    Offset offset;
    if (appearance == LAppearance.Llat || state == LState.Highlighted) {
      return Offset.zero;
    }
    switch (lightOrientation) {
      case LLightOrientation.LeftTop:
        if (appearance == LAppearance.Material) {
          offset = Offset(shadow.shadowDistance, shadow.shadowDistance);
        } else {
          //LControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(-shadow.highlightDistance, -shadow.highlightDistance)
              : Offset(shadow.shadowDistance, shadow.shadowDistance);
        }
        return offset;
      case LLightOrientation.LeftBottom:
        if (appearance == LAppearance.Material) {
          offset = Offset(shadow.shadowDistance, -shadow.shadowDistance);
        } else {
          //LControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(-shadow.highlightDistance, shadow.highlightDistance)
              : Offset(shadow.shadowDistance, -shadow.shadowDistance);
        }
        return offset;
      case LLightOrientation.RightTop:
        if (appearance == LAppearance.Material) {
          offset = Offset(-shadow.shadowDistance, shadow.shadowDistance);
        } else {
          //LControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(shadow.highlightDistance, -shadow.highlightDistance)
              : Offset(-shadow.shadowDistance, shadow.shadowDistance);
        }
        return offset;
      case LLightOrientation.RightBottom:
        if (appearance == LAppearance.Material) {
          offset = Offset(-shadow.shadowDistance, -shadow.shadowDistance);
        } else {
          //LControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(shadow.highlightDistance, shadow.highlightDistance)
              : Offset(-shadow.shadowDistance, -shadow.shadowDistance);
        }
        return offset;
    }
  }

  Color? _innerShadowColor(
      bool isBacklight, LState state, LShadow innerShadow) {
    if (state == LState.Normal || state == LState.Disable) {
      return const Color.fromARGB(0, 0, 0, 0);
    } else {
      return isBacklight ? innerShadow.highlightColor : innerShadow.shadowColor;
    }
  }

  Offset _innerShadowOffset(
      bool isBacklight, LState state, LShadow innerShadow) {
    final double forwardlightDistance = innerShadow.highlightDistance.abs();
    final double backlightDistance = innerShadow.shadowDistance.abs();
    switch (lightOrientation) {
      case LLightOrientation.LeftTop:
        {
          Offset offset = isBacklight
              ? Offset(backlightDistance, backlightDistance)
              : Offset(-forwardlightDistance, -forwardlightDistance);
          if (state == LState.Normal || state == LState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
      case LLightOrientation.LeftBottom:
        {
          Offset offset = isBacklight
              ? Offset(backlightDistance, -backlightDistance)
              : Offset(-forwardlightDistance, forwardlightDistance);
          if (controlState == LState.Normal ||
              controlState == LState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
      case LLightOrientation.RightTop:
        {
          Offset offset = isBacklight
              ? Offset(-backlightDistance, backlightDistance)
              : Offset(forwardlightDistance, -forwardlightDistance);
          if (controlState == LState.Normal ||
              controlState == LState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
      case LLightOrientation.RightBottom:
        {
          Offset offset = isBacklight
              ? Offset(-backlightDistance, -backlightDistance)
              : Offset(forwardlightDistance, forwardlightDistance);
          if (controlState == LState.Normal ||
              controlState == LState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
    }
  }

  ShapeDecoration? _createSurfaceShape() {
    final Color surfaceShadowColor = Colors.black26;
    switch (currentSurface!) {
      case LSurface.Flat:
        return ShapeDecoration(
            shape: _createShapeBorder(controlState!, true),
            color: (controlState == LState.Highlighted)
                ? maskColor
                : Colors.transparent);
      case LSurface.Convex:
        switch (lightOrientation) {
          case LLightOrientation.LeftTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[Colors.transparent, surfaceShadowColor],
                  stops: const <double>[0.4, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            );
          case LLightOrientation.LeftBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[Colors.transparent, surfaceShadowColor],
                  stops: const <double>[0.4, 1.0],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
          case LLightOrientation.RightTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[Colors.transparent, surfaceShadowColor],
                  stops: const <double>[0.4, 1.0],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft),
            );
          case LLightOrientation.RightBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[Colors.transparent, surfaceShadowColor],
                  stops: const <double>[0.4, 1.0],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
        }
      case LSurface.Concave:
        switch (lightOrientation) {
          case LLightOrientation.LeftTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[surfaceShadowColor, Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            );
          case LLightOrientation.LeftBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[surfaceShadowColor, Colors.transparent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
          case LLightOrientation.RightTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[surfaceShadowColor, Colors.transparent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft),
            );
          case LLightOrientation.RightBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState!, true),
              gradient: LinearGradient(
                  colors: <Color>[surfaceShadowColor, Colors.transparent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
        }
    }
  }

  //============> 重载部分生存周期函数，用于不同状态的变化响应
  @override
  void didUpdateWidget(LControl oldWidget) {
    isSelected = widget.isSelected ?? false;
    controlType = widget.controlType ?? LType.Button;
    disabled = widget.disabled ?? false;
    defaultColor = widget.color!;
    if (disabled) {
      controlState = LState.Disable;
      defaultColor = LDisableColor;
      // defaultBackgroundColors = [LDisableColor, LDisableColor];
    } else if (controlType == LType.Toggle) {
      controlState = isSelected ? LState.Highlighted : LState.Normal;
      _updateState();
    } else if(controlState == LState.Disable){
      controlState = LState.Normal;
    }
    if(widget.colorForCallback != null){
      defaultColor = widget.colorForCallback!(widget, controlState!);
    }
    defaultColor = defaultColor;
    appearance = widget.appearance ?? LAppearance.Llat;
    defaultWidget = widget.child;
    defaultGradient = widget.gradient;
    if (controlState == LState.Normal) {
//      currentWidget = defaultWidget;
//      currentColor = defaultColor;
      currentGradient = defaultGradient;
    }
    currentWidget = defaultWidget;
    if(widget.childForStateCallback != null){
      currentWidget = widget.childForStateCallback!(widget, controlState!);
    }
    currentWidget = currentWidget;
    currentGradient = currentGradient;
//    currentColor = currentColor ?? defaultColor;
    currentColor = defaultColor;
    // defaultBackgroundColors = widget.backgroundColors ?? [LPrimerColor];
//    disabled = widget.disabled ?? false;
//    if (disabled) {
//      controlState = LState.Disable;
//      defaultColor = LDisableColor;
//      // defaultBackgroundColors = [LDisableColor, LDisableColor];
//    }
    defaultShape = widget.shape ?? const LShape();
    supportDropShadow = widget.supportDropShadow ?? true;
    maskColor = widget.maskColor ?? Colors.black12;
//    isSelected = widget.isSelected ?? false;
    lightOrientation = widget.lightOrientation ?? LLightOrientation.LeftTop;
//    controlType = widget.controlType ?? LType.Button;
    currentSurface = widget.surface ?? LSurface.Flat;

//    if (controlType == LType.Toggle) {
//      controlState = isSelected ? LState.Highlighted : LState.Normal;
//      _controlGestureHandlerLorState();
//    }

//    if (disabled) {
//      controlState = LState.Disable;
//    }

    if (widget.surfaceLorCallback != null) {
      currentSurface = widget.surfaceLorCallback!(widget, controlState!);
      currentSurface = currentSurface;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.states!.remove(this);
    }
    super.dispose();
  }
}
