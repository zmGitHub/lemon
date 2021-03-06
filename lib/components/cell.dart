import 'package:flutter/material.dart';
import 'package:lemon/styles/colors.dart';
import 'package:lemon/styles/gaps.dart';

class LCell extends StatelessWidget {
  final Widget left;
  final Widget body;
  final Widget right;
  final Widget content;
  final bool bordered;
  final Color backgroundColor;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final GestureTapCallback onTap;
  final CrossAxisAlignment crossAxisAlignment;

  const LCell({
    Key key,
    this.left: LGaps.empty,
    this.right: LGaps.empty,
    this.body: LGaps.empty,
    this.content,
    this.onTap,
    this.decoration,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.margin = const EdgeInsets.only(left: 15),
    this.bordered = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  factory LCell.primary({
    Key key,
    Color backgroundColor,
    Widget prefixLeft,
    Widget prefixRight,
    @required String title,
    TextStyle titleStyle,
    String label,
    TextStyle labelStyle,
    bool bordered,
    bool isLink,
    EdgeInsets padding,
    EdgeInsets linkPadding,
    EdgeInsets labelPadding,
    EdgeInsets margin,
    Widget linkIcon,
    Widget left,
    Widget body,
    Widget right,
    Widget content,
    GestureTapCallback onTap,
    CrossAxisAlignment crossAxisAlignment,
  }) = _CellPrimary;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        left,
        Expanded(
          flex: 1,
          child: body,
        ),
        right,
      ],
    );
    if (content != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          child,
          content,
        ],
      );
    }
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding,
          margin: margin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: bordered
                ? Border(
              bottom: Divider.createBorderSide(
                context,
                width: 0.7,
                color: Colours.gray3,
              ),
            )
                : null,
          ).copyWith(
            border: decoration?.border,
            color: decoration?.color,
            image: decoration?.image,
            borderRadius: decoration?.borderRadius,
            boxShadow: decoration?.boxShadow,
            gradient: decoration?.gradient,
            backgroundBlendMode: decoration?.backgroundBlendMode,
            shape: decoration?.shape,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CellPrimary extends LCell {
  _CellPrimary({
    final Key key,
    final Color backgroundColor = Colors.white,
    final Widget prefixLeft = LGaps.empty,
    final Widget prefixRight = LGaps.empty,
    @required String title,
    final TextStyle titleStyle,
    final String label = "",
    final TextStyle labelStyle,
    final bool bordered = true,
    final bool isLink = false,
    final EdgeInsets padding = const EdgeInsets.symmetric(vertical: 16),
    final EdgeInsets labelPadding = const EdgeInsets.only(right: 15.0),
    final EdgeInsets linkPadding = const EdgeInsets.symmetric(horizontal: 10),
    final EdgeInsets margin = const EdgeInsets.only(left: 15),
    final Widget linkIcon = const Icon(Icons.arrow_forward_ios, color: Colours.gray6, size: 14,),
    final Widget left,
    final Widget body,
    final Widget right,
    final Widget content,
    final GestureTapCallback onTap,
    final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  })  : assert(title != null),
        super(
          key: key,
          backgroundColor: backgroundColor,
          onTap: onTap,
          bordered: bordered,
          crossAxisAlignment: crossAxisAlignment,
          margin: margin,
          padding: padding,
          left: left??Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              prefixLeft,
              Text(
                title??"",
                style: TextStyle(
                  color: Colours.gray8,
                ).merge(titleStyle),
              ),
              prefixRight,
            ],
          ),
          body: Padding(
            padding: labelPadding,
            child: body??Text(
              label,
              style: TextStyle(
                color: Colours.gray6,
              ).merge(labelStyle),
              textAlign: TextAlign.right,
            ),
          ),
          content: content,
          right: right != null ? right : isLink ? Padding(
            padding: linkPadding,
            child: linkIcon,
          ) : LGaps.empty,
        );
}
