import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemon/styles/colors.dart';

class LAppBar extends StatelessWidget implements PreferredSizeWidget {
  LAppBar({
    Key? key,
    this.title = '',
    this.titleStyle,
    this.height = 48.0,
    this.decoration,
    this.brightness,
    this.centerTitle = true,
    this.bottomBordered = true,
    this.middleSpacing = NavigationToolbar.kMiddleSpacing,
    this.middle,
    this.actions,
    this.bottom,
    this.leadingIcon = Icons.arrow_back_ios,
    this.leaderSize = 28,
    this.backgroundColor = Colors.white,
    this.leadingColor = Colours.gray6,
    this.leading,
    this.iconTheme,
    this.actionsIconTheme,
    this.onPressed,
  }) : preferredSize = Size.fromHeight(height! + (bottom?.preferredSize.height ?? 0.0)),super(key: key);

  final double? height;
  final Decoration? decoration;
  final Brightness? brightness;
  final double? middleSpacing;
  final bool? centerTitle;
  final bool? bottomBordered;
  final String title;
  final TextStyle? titleStyle;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? middle;
  final PreferredSizeWidget? bottom;
  final IconData? leadingIcon;
  final Color? backgroundColor;
  final Color? leadingColor;
  final double? leaderSize;
  final VoidCallback? onPressed;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);
    // icon样式
    final IconThemeData _overallIconTheme = iconTheme
        ?? appBarTheme.iconTheme
        ?? theme.primaryIconTheme;

    final IconThemeData _actionsIconTheme = actionsIconTheme
        ?? appBarTheme.actionsIconTheme
        ?? _overallIconTheme;
    // 返回按钮处理
    final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    // 状态栏样式
    final Brightness _brightness =
        brightness ?? appBarTheme.brightness ?? theme.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = _brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    // 左侧按钮
    Widget? _leading = leading;
    if (_leading == null && canPop) {
      _leading = IconButton(
        icon: Icon(leadingIcon, size: leaderSize, color: leadingColor,),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            // 返回前 先把键盘收起来
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.maybePop(context);
          }
        },
      );
    }

    Widget? _trailing;
    if (actions != null) {
      _trailing = IconTheme.merge(
        data: _actionsIconTheme,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions!,
        ),
      );
    }
    Widget? _middle = middle;
    if (middle == null) {
      _middle = Text(title, style: const TextStyle(
        fontSize: 14,
        color: Colours.black,
      ).merge(titleStyle),);
    }

    // appbar
    Widget _appbar = ClipRect(
      child: CustomSingleChildLayout(
        delegate: _ToolbarContainerLayout(height!),
        child: IconTheme.merge(
          data: _overallIconTheme,
          child: NavigationToolbar(
            leading: _leading,
            middle: _middle,
            trailing: _trailing,
            centerMiddle: centerTitle!,
            middleSpacing: middleSpacing!,
          ),
        ),
      ),
    );

    // 底部组件
    if (bottom != null) {
      _appbar = Column(
        children: <Widget>[
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height!),
              child: _appbar,
            ),
          ),
          bottom!,
        ],
      );
    }


    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: backgroundColor,
          child: DecoratedBox(
            decoration: decoration??BoxDecoration(
              border: bottomBordered! ? const Border(
                bottom: BorderSide(color: Colours.gray4, width: 0.75),
              ) : null,
            ),
            child: Semantics(
              explicitChildNodes: true,
              child: SafeArea(
                bottom: false,
                top: true,
                child: _appbar,
              ),
            ),
          ),
        ),
      ),
    );
  }

}


class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout(this.toolbarHeight);

  final double toolbarHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: toolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, toolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) =>
      toolbarHeight != oldDelegate.toolbarHeight;
}