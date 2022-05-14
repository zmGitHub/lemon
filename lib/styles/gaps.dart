import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 间隔
class LGaps {
  /// 水平间隔
  static Widget hGap(double width) => SizedBox(width: width);
  /// 垂直间隔
  static Widget vGap(double height) => SizedBox(height: height);
  static const Widget empty = SizedBox.shrink();
}
