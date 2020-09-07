import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemon/styles/colors.dart';
import 'package:lemon/styles/gaps.dart';

class LInput extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double inputHeight;
  final TextStyle inputStyle;
  final Color backgroundColor;
  final EdgeInsets backgroundPadding;
  final BoxDecoration backgroundDecoration;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final TextAlign textAlign;
  final InputDecoration inputDecoration;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool readOnly;
  final bool bordered;
  final bool obscureText;
  final int maxLength;

  const LInput({
    Key key,
    this.backgroundPadding = const EdgeInsets.symmetric(
      horizontal: 15.0,
      vertical: 0.0,
    ),
    this.inputHeight = 44,
    this.backgroundDecoration,
    this.backgroundColor = Colors.white,
    this.left = Gaps.empty,
    this.right = Gaps.empty,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.inputDecoration,
    this.keyboardType,
    this.controller,
    this.bordered = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.inputStyle,
    this.focusNode,
  }) : super(key: key);

  factory LInput.label({
    @required final String title,
    final TextStyle titleStyle,
    final double titleWidth,
    final String hintText,
    final TextStyle hintStyle,
    final Widget left,
    final Widget right,
    final double inputHeight,
    final Color backgroundColor,
    final EdgeInsets backgroundPadding,
    final BoxDecoration backgroundDecoration,
    final ValueChanged<String> onChanged,
    final VoidCallback onEditingComplete,
    final ValueChanged<String> onSubmitted,
    final List<TextInputFormatter> inputFormatters,
    final TextAlign textAlign,
    final InputDecoration inputDecoration,
    final TextInputType keyboardType,
    final TextEditingController controller,
    final bool readOnly,
    final int maxLength,
}) = _LabelInput;

  @override
  Widget build(BuildContext context) {
    BoxBorder border = bordered ? Border(
      bottom: Divider.createBorderSide(
        context,
        width: 0.7,
        color: Colours.gray3,
      ),
    ) : null;
    return Material(
      color: backgroundColor,
      child: Padding(
        padding: backgroundPadding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: border,
          ).copyWith(
            border: backgroundDecoration?.border,
            color: backgroundDecoration?.color,
            image: backgroundDecoration?.image,
            borderRadius: backgroundDecoration?.borderRadius,
            boxShadow: backgroundDecoration?.boxShadow,
            gradient: backgroundDecoration?.gradient,
            backgroundBlendMode: backgroundDecoration?.backgroundBlendMode,
            shape: backgroundDecoration?.shape,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              left,
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  height: inputHeight,
                  child: TextField(
                    textAlign: textAlign,
                    keyboardType: keyboardType,
                    obscureText: obscureText,
                    controller: controller,
                    inputFormatters: inputFormatters,
                    onChanged: onChanged,
                    readOnly: readOnly,
                    maxLength: maxLength,
                    decoration: inputDecoration,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colours.black,
                    ).merge(inputStyle),
                  ),
                ),
              ),
              right,
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelInput extends LInput {
  _LabelInput({
    @required final String title,
    final double inputHeight = 44,
    final TextStyle titleStyle,
    final double titleWidth = 80.0,
    final String hintText = "",
    final TextStyle hintStyle,
    final Widget left,
    final Widget right = Gaps.empty,
    final Color backgroundColor,
    final EdgeInsets backgroundPadding = const EdgeInsets.symmetric(
      horizontal: 15.0,
      vertical: 0.0,
    ),
    final Decoration backgroundDecoration,
    final ValueChanged<String> onChanged,
    final VoidCallback onEditingComplete,
    final ValueChanged<String> onSubmitted,
    final List<TextInputFormatter> inputFormatters,
    final TextAlign textAlign = TextAlign.start,
    final InputDecoration inputDecoration,
    final TextInputType keyboardType,
    final TextEditingController controller,
    final bool readOnly = false,
    final bool bordered = true,
    final int maxLength,
  }) : assert(title != null, "title required"),super(
          inputHeight: inputHeight,
          controller: controller,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          textAlign: textAlign,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLength: maxLength,
          bordered: bordered,
          backgroundDecoration: backgroundDecoration,
          backgroundPadding: backgroundPadding,
          inputDecoration: inputDecoration??InputDecoration(
            counterText: "",
            hintText: hintText,
            isDense: true,
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: Colours.gray5,
            ).merge(hintStyle),
            border: InputBorder.none,
          ),
          left: left??SizedBox(
            width: titleWidth,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                color: Colours.gray8,
              ).merge(titleStyle),
            ),
          ),
          right: right,
        );
}
