library popup_windows;

import 'package:flutter/material.dart';
import 'package:flutter_test_plugin/my_popup/popup_window_route.dart';

enum Direction {
  //控件上方
  Top,
  //控件下方
  Bottom,
  //控件左边
  Left,
  //控件右边
  Right,
}

enum ArrowPosition {
  //按钮的左边
  left,
  //按钮的右边
  right,
  //按钮的中间
  center,
}

///带箭头的弹窗控件
class PopupWindowWidget<T> extends StatefulWidget {
  PopupWindowWidget(
      {Key? key,
      required this.showChild,
      this.intelligentConversion = false,
      required this.child,
      this.showChildHeight = 150,
      this.showChildWidth = 320,
      this.direction = Direction.Bottom,
      this.dialogBgColor = Colors.transparent,
      this.arrowHeight = 24,
      this.arrowWidth = 12,
      this.showArrow = true,
      this.interval = 4,
      this.arrowWidget,
      this.arrowOffset = 0,
      this.arrowPosition = ArrowPosition.center,
      this.offset = Offset.zero})
      : super(key: key);

  //超出边界自动换方向；left⇋right、top⇋bottom
  //todo:后续会找出最优方向
  final bool intelligentConversion;

  //触发弹出展示的widget
  final Widget child;

  //弹出展示的widget
  final Widget showChild;

  //箭头widget
  final Widget? arrowWidget;

  //展示方向
  final Direction direction;

  //showChild展示位置偏移量,默认居中展示(设置margin时可能不居中，可以设置此变量居中;left=n,right=-n)
  final Offset offset;

  //显示dialog的宽度
  final double showChildWidth;

  //显示dialog的高度
  final double showChildHeight;

  //dialog的背景颜色
  final Color dialogBgColor;

  //三角形的高度
  final double arrowHeight;

  //三角形的宽度
  final double arrowWidth;

  //是否显示三角形
  final bool showArrow;

  //三角形往右偏的偏移量（往左设置负数）
  final double arrowOffset;

  //三角形与按钮的距离
  final double interval;

  final ArrowPosition arrowPosition;

  @override
  _PopupWindowWidgetState createState() => _PopupWindowWidgetState();
}

class _PopupWindowWidgetState<T> extends State<PopupWindowWidget<T>> {
  Offset getOffset(RenderBox button) {
    switch (widget.direction) {
      case Direction.Left:
      case Direction.Right:
        return Offset(widget.offset.dx, widget.offset.dy);
      case Direction.Top:
      case Direction.Bottom:
        return Offset(widget.offset.dx, button.size.height + widget.offset.dy);
      default:
        return Offset(0.0, 0.0);
    }
  }

  void showPopupWindow() {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(getOffset(button), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    Navigator.push<T>(
        context,
        PopupWindowRoute<T>(
            child: widget.showChild,
            button: button.size,
            position: position,
            direction: widget.direction,
            intelligentConversion: widget.intelligentConversion,
            showChildHeight: widget.showChildHeight,
            showChildWidth: widget.showChildWidth,
            dialogBgColor: widget.dialogBgColor,
            arrowHeight: widget.arrowHeight,
            arrowWidth: widget.arrowWidth,
            showArrow: widget.showArrow,
            interval: widget.interval,
            arrowWidget: widget.arrowWidget,
            arrowOffset: widget.arrowOffset,
            arrowPosition: widget.arrowPosition));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: showPopupWindow,
      child: widget.child,
    );
  }
}
