import 'package:flutter/material.dart';
import 'package:lemon/styles/colors.dart';
import 'package:lemon/styles/gaps.dart';

class LButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Decoration decoration;
  final VoidCallback onPressed;
  final Color disabledColor;
  final Color disabledTextColor;
  final Color highlightColor;
  final ShapeBorder shape;
  final Widget body;

  LButton({
    Key key,
    this.width = double.infinity,
    this.height = 44,
    this.radius = 22,
    this.decoration,
    this.onPressed,
    this.disabledColor,
    this.disabledTextColor,
    this.highlightColor,
    this.shape,
    this.body = LGaps.empty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
      child: FlatButton(
        onPressed: onPressed,
        disabledTextColor: disabledTextColor,
        disabledColor: disabledColor,
        shape: shape??RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        padding: const EdgeInsets.all(0.0),
        child: body,
      ),
    );
  }

  factory LButton.normal({
    key,
    double width,
    double height,
    @required String title,
    Decoration decoration,
    TextStyle textStyle,
    VoidCallback onPressed,
  }) = _DefaultBtn;
}
//<van-button type="default">默认按钮</van-button>
//<van-button type="primary">主要按钮</van-button>
//<van-button type="info">信息按钮</van-button>
//<van-button type="warning">警告按钮</van-button>
//<van-button type="danger">危险按钮</van-button>

class _DefaultBtn extends LButton {
  _DefaultBtn({
    key,
    double width = 100,
    double height = 44,
    @required String title,
    Decoration decoration,
    TextStyle textStyle,
    Color disabledColor = Colours.gray5,
    Color disabledTextColor = Colours.gray8,
    VoidCallback onPressed,
  })  : assert(title != null),
        super(
            key: key,
            width: width,
            height: height,
            decoration: decoration??BoxDecoration(
              border: Border.all(color: Colours.gray3, width: 1),
            ),
            disabledColor: disabledColor,
            disabledTextColor: disabledTextColor,
            onPressed: onPressed,
            body: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 14).merge(textStyle),
              ),
            ));
}
