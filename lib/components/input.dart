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
  final Decoration backgroundDecoration;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final bool autofocus;
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
    this.left = LGaps.empty,
    this.right = LGaps.empty,
    this.onChanged,
    this.onEditingComplete,
    this.autofocus = false,
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
    final Key key,
    final String title,
    final TextStyle titleStyle,
    final TextStyle inputStyle,
    final double titleWidth,
    final String hintText,
    final TextStyle hintStyle,
    final Widget left,
    final Widget right,
    final double inputHeight,
    final FocusNode focusNode,
    final Color backgroundColor,
    final EdgeInsets backgroundPadding,
    final BoxDecoration backgroundDecoration,
    final ValueChanged<String> onChanged,
    final VoidCallback onEditingComplete,
    final bool autofocus,
    final ValueChanged<String> onSubmitted,
    final List<TextInputFormatter> inputFormatters,
    final TextAlign textAlign,
    final InputDecoration inputDecoration,
    final TextInputType keyboardType,
    final TextEditingController controller,
    final bool readOnly,
    final bool obscureText,
    final int maxLength,
    final bool bordered,
}) = _LabelInput;

  @override
  Widget build(BuildContext context) {
    Widget body = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        left,
        Expanded(
          flex: 1,
          child: SizedBox(
            height: inputHeight,
            child: Align(
              alignment: Alignment.center,
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
                autofocus: autofocus,
                onEditingComplete: onEditingComplete,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colours.black,
                ).merge(inputStyle),
              ),
            ),
          ),
        ),
        right,
      ],
    );
    // 是否有底部标签
    if (bordered) {
      body = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(
              context,
              width: 0.7,
              color: Colours.gray3,
            ),
          ),
        ),
        child: body,
      );
    }
    if (backgroundPadding != EdgeInsets.zero) {
      body = Padding(
        padding: backgroundPadding,
        child: body,
      );
    }

    if (backgroundDecoration == null) {
      body = Material(
        color: backgroundColor,
        child: body,
      );
    } else {
      body = DecoratedBox(
        decoration: backgroundDecoration,
        child: body,
      );
    }
    return body;
  }
}

class _LabelInput extends LInput {
  _LabelInput({
    final Key key,
    final String title,
    final double inputHeight = 44,
    final TextStyle titleStyle,
    final double titleWidth = 80.0,
    final String hintText = "",
    final TextStyle hintStyle,
    final TextStyle inputStyle,
    final Widget left,
    final Widget right = LGaps.empty,
    final Color backgroundColor = Colors.white,
    final EdgeInsets backgroundPadding = const EdgeInsets.symmetric(
      horizontal: 15.0,
      vertical: 0.0,
    ),
    final Decoration backgroundDecoration,
    final BorderRadiusGeometry borderRadius,
    final ValueChanged<String> onChanged,
    final VoidCallback onEditingComplete,
    final ValueChanged<String> onSubmitted,
    final List<TextInputFormatter> inputFormatters,
    final TextAlign textAlign = TextAlign.start,
    final InputDecoration inputDecoration,
    final TextInputType keyboardType,
    final TextEditingController controller,
    final FocusNode focusNode,
    final bool autofocus = false,
    final bool obscureText = false,
    final bool readOnly = false,
    final bool bordered = true,
    final int maxLength,
  }) : assert(title != null, "title required"),super(
          key: key,
          inputHeight: inputHeight,
          inputStyle: inputStyle,
          controller: controller,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          textAlign: textAlign,
          keyboardType: keyboardType,
          autofocus: autofocus,
          readOnly: readOnly,
          maxLength: maxLength,
          bordered: bordered,
          obscureText: obscureText,
          backgroundDecoration: backgroundDecoration,
          backgroundPadding: backgroundPadding,
          backgroundColor: backgroundColor,
          focusNode: focusNode,
          inputDecoration: InputDecoration(
            counterText: "",
            hintText: hintText,
            isDense: true,
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: Colours.gray5,
            ).merge(hintStyle),
            border: InputBorder.none,
          ).copyWith(
            icon: inputDecoration?.icon,
            labelText: inputDecoration?.labelText,
            labelStyle: inputDecoration?.labelStyle,
            helperText: inputDecoration?.helperText,
            helperStyle: inputDecoration?.helperStyle,
            helperMaxLines : inputDecoration?.helperMaxLines,
            hintText: inputDecoration?.hintText,
            hintStyle: inputDecoration?.hintStyle,
            hintMaxLines: inputDecoration?.hintMaxLines,
            errorText: inputDecoration?.errorText,
            errorStyle: inputDecoration?.errorStyle,
            errorMaxLines: inputDecoration?.errorMaxLines,
            isCollapsed: inputDecoration?.isCollapsed,
            isDense: inputDecoration?.isDense,
            contentPadding: inputDecoration?.contentPadding,
            prefixIcon: inputDecoration?.prefixIcon,
            prefix: inputDecoration?.prefix,
            prefixText: inputDecoration?.prefixText,
            prefixStyle: inputDecoration?.prefixStyle,
            prefixIconConstraints: inputDecoration?.prefixIconConstraints,
            suffixIcon: inputDecoration?.suffixIcon,
            suffix: inputDecoration?.suffix,
            suffixText: inputDecoration?.suffixText,
            suffixStyle: inputDecoration?.suffixStyle,
            suffixIconConstraints: inputDecoration?.suffixIconConstraints,
            counter: inputDecoration?.counter,
            counterText: inputDecoration?.counterText,
            counterStyle: inputDecoration?.counterStyle,
            filled: inputDecoration?.filled,
            fillColor: inputDecoration?.fillColor,
            focusColor: inputDecoration?.focusColor,
            hoverColor: inputDecoration?.hoverColor,
            errorBorder: inputDecoration?.errorBorder,
            focusedBorder: inputDecoration?.focusedBorder,
            focusedErrorBorder: inputDecoration?.focusedErrorBorder,
            disabledBorder: inputDecoration?.disabledBorder,
            enabledBorder: inputDecoration?.enabledBorder,
            border: inputDecoration?.border,
            enabled: inputDecoration?.enabled,
            semanticCounterText: inputDecoration?.semanticCounterText,
            alignLabelWithHint: inputDecoration?.alignLabelWithHint,
          ),
          left: left??SizedBox(
            width: titleWidth,
            child: Text(
              title??"",
              style: TextStyle(
                fontSize: 14.0,
                color: Colours.gray8,
              ).merge(titleStyle),
            ),
          ),
          right: right,
        );
}
