import 'package:flutter/material.dart';
import 'package:flutter_test_plugin/my_popup/popup_windows.dart';
import 'package:hexcolor/hexcolor.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;

class PopupWindowRoute<T> extends PopupRoute<T> {
  PopupWindowRoute({
    required this.child,
    required this.position,
    required this.direction,
    required this.intelligentConversion,
    required this.button,
    required this.showChildWidth,
    required this.showChildHeight,
    required this.dialogBgColor,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.showArrow,
    required this.interval,
    required this.arrowWidget,
    required this.arrowOffset,
    required this.arrowPosition,
  });

  final Widget child;
  final RelativeRect position;
  final Direction direction;
  final bool intelligentConversion;
  final Size button;
  final double showChildWidth;
  final double showChildHeight;
  final Color dialogBgColor;
  final double arrowHeight;
  final double arrowWidth;
  final bool showArrow;
  final double arrowOffset;
  final ArrowPosition arrowPosition;

  final double interval;

  //箭头widget
  final Widget? arrowWidget;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    switch (direction) {
      case Direction.Bottom:
      case Direction.Left:
      case Direction.Right:
      case Direction.Top:
        return child;
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    ///弹窗的宽高
    double childWidth = showChildWidth;
    double childHeight = showChildHeight;
    if (intelligentConversion) {
      if ((direction == Direction.Left || direction == Direction.Right)) {
        if (showArrow) {
          ///左右弹窗时：真实宽 = 弹窗宽 + 箭头宽 + 箭头和按钮的距离
          childWidth = showChildWidth + arrowWidth + interval;
        } else {
          childWidth = showChildWidth + interval;
        }
      }

      if ((direction == Direction.Bottom || direction == Direction.Top)) {
        if (showArrow) {
          ///上下弹窗时：真实高 = 弹窗高+箭头高+箭头与按钮的距离
          childHeight = showChildHeight + arrowHeight + interval;
        } else {
          childHeight = showChildHeight + interval;
        }

        ///上下弹窗市，当按钮框大于弹窗宽时，设置弹窗宽为按钮宽+弹窗宽
        if (showChildWidth < button.width) {
          childWidth = button.width + showChildWidth;
        }
      }
    }
    print("childWidth: $childWidth   childHeight: $childHeight");

    ///弹窗显示布局
    Widget? childWidget;
    if (direction == Direction.Bottom || direction == Direction.Top) {
      //获取垂直方向上的widget
      childWidget = getVerticalDialogWidget(context, childWidth, childHeight);
    }
    if (direction == Direction.Left || direction == Direction.Right) {
      //获取水平方向上的widget
      childWidget = getHorizontalDialogWidget(context, childWidth, childHeight);
    }

    return GestureDetector(
      onTap: () {
        Navigator.maybePop(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: dialogBgColor,
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: this.animation!,
            curve: Interval(0.0, 1.0),
          ),
          child: CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              direction: direction,
              intelligentConversion: intelligentConversion,
              button: button,
            ),
            child: SizedBox(
                width: childWidth,
                height: childHeight,
                child: childWidget ?? child),
          ),
        ),
      ),
    );
  }

  @override
  String get barrierLabel => "null";

  ///箭头布局
  Widget getArrowWidget(DirectionArrow directionArrow) {
    if (arrowWidget != null) {
      return SizedBox(
        width: arrowWidth,
        height: arrowHeight,
        child: arrowWidget,
      );
    }
    return CustomPaint(
      size: Size(arrowWidth, arrowHeight),
      painter: _TrianglePainter(
          directionArrow: directionArrow,
          color: HexColor("#808080"),
          borderColor: HexColor("#808080")),
    );
  }

  ///垂直方向的弹窗布局
  Widget verticalDialogChildWidget(double childWidth, double subtractWidth) {
    if (childWidth == showChildWidth) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: () {}, child: child);
    } else {
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;
      switch (arrowPosition) {
        case ArrowPosition.left:
          mainAxisAlignment = MainAxisAlignment.start;
          break;
        case ArrowPosition.right:
          mainAxisAlignment = MainAxisAlignment.end;
          break;
        case ArrowPosition.center:
          mainAxisAlignment = MainAxisAlignment.center;
          break;
      }
      return SizedBox(
        width: childWidth - subtractWidth,
        height: showChildHeight,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque, onTap: () {}, child: child),
          ],
        ),
      );
    }
  }

  ///垂直方向上的弹窗布局
  Widget? getVerticalDialogWidget(
      BuildContext context, double childWidth, double childHeight) {
    ///箭头的偏移量
    double positionedLeft = 0;

    ///箭头和弹窗所在的水平对齐方式
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;

    ///屏幕的宽
    double width = MediaQuery.of(context).size.width;

    ///弹窗减去的宽
    double subtractWidth = 0;

    double x;
    //点击view的宽度
    double diffX = button.width - childWidth;
    x = position.left + diffX / 2;
    if (x < 0.0) {
      ///左边顶住了屏幕左边，往右偏
      crossAxisAlignment = CrossAxisAlignment.start;

      ///点击按钮宽大于箭头的宽，设置箭头的父布局宽为按钮的宽
      if (position.left == 0) {
        print("按钮紧贴左边屏幕");
        switch (arrowPosition) {
          case ArrowPosition.left:
            positionedLeft = 0 - arrowWidth / 2;
            break;
          case ArrowPosition.right:
            subtractWidth = showChildWidth / 2;
            positionedLeft = button.width - arrowWidth / 2;
            break;
          case ArrowPosition.center:
            subtractWidth = showChildWidth;
            positionedLeft = button.width / 2 - arrowWidth / 2;
            break;
        }
      } else {
        print("按钮没有紧贴左边屏幕");
        switch (arrowPosition) {
          case ArrowPosition.left:
            positionedLeft = position.left - arrowWidth / 2;
            break;
          case ArrowPosition.right:
            subtractWidth =
                -(showChildWidth / 2 - (showChildWidth - position.left));
            positionedLeft = position.left + button.width - arrowWidth / 2;
            break;
          case ArrowPosition.center:
            positionedLeft = position.left - arrowWidth / 2 + button.width / 2;
            subtractWidth = showChildWidth - position.left * 2;
            break;
        }
      }
    } else if (x > width - childWidth) {
      print("右边顶住了屏幕右边，往左偏");

      ///右边顶住了屏幕右边，往左偏

      crossAxisAlignment = CrossAxisAlignment.end;
      print("arrowWidth：${arrowWidth}  button.width: ${button.width}");
      // if (button.width >= arrowWidth) {

      if (position.left + button.width >= width) {
        print("按钮紧贴屏幕右边");

        ///按钮紧贴屏幕右边
        switch (arrowPosition) {
          case ArrowPosition.left:
            subtractWidth = showChildWidth / 2;
            positionedLeft = childWidth - arrowWidth / 2 - button.width;
            break;
          case ArrowPosition.right:
            positionedLeft = position.left -
                (width - childWidth) +
                button.width -
                arrowWidth / 2;
            break;
          case ArrowPosition.center:
            subtractWidth = showChildWidth;
            positionedLeft = childWidth - button.width / 2 - arrowWidth / 2;
            break;
        }
      } else {
        ///按钮没有紧贴右边
        print("按钮没有紧贴右边");
        switch (arrowPosition) {
          case ArrowPosition.left:
            subtractWidth = -(showChildWidth / 2 -
                (showChildWidth - (width - position.left - button.width)));
            positionedLeft =
                position.left - (width - childWidth) - arrowWidth / 2;
            break;
          case ArrowPosition.right:
            positionedLeft = position.left -
                (width - childWidth) +
                button.width -
                arrowWidth / 2;
            break;
          case ArrowPosition.center:
            positionedLeft = position.left -
                (width - childWidth + arrowWidth / 2 - button.width / 2);
            subtractWidth =
                showChildWidth - (width - position.left - button.width) * 2;
            break;
        }
      }
    } else {
      print("正常居中，正常偏移");
      switch (arrowPosition) {
        case ArrowPosition.left:
          positionedLeft = (childWidth - button.width - arrowWidth) / 2;
          break;
        case ArrowPosition.right:
          positionedLeft = (childWidth + button.width - arrowWidth) / 2;
          break;
        case ArrowPosition.center:
          positionedLeft = childWidth / 2 - arrowWidth / 2;
          break;
      }
    }
    positionedLeft = positionedLeft + arrowOffset;

    Widget? childWidget;
    if (direction == Direction.Bottom) {
      //设置的在按钮底部，检查能否显示在底部
      if (checkIsBottom(context, childWidth, childHeight)) {
        childWidget = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            SizedBox(
              height: interval,
            ),
            showArrow
                ? SizedBox(
                    width: childWidth,
                    height: arrowHeight,
                    child: Stack(
                      children: [
                        Positioned(
                            left: positionedLeft,
                            top: 0,
                            child: getArrowWidget(DirectionArrow.top)),
                      ],
                    ),
                  )
                : Container(),
            verticalDialogChildWidget(childWidth, subtractWidth),
          ],
        );
      } else {
        childWidget = Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            verticalDialogChildWidget(childWidth, subtractWidth),
            showArrow
                ? SizedBox(
                    width: childWidth,
                    height: arrowHeight,
                    child: Stack(
                      children: [
                        Positioned(
                            left: positionedLeft,
                            top: 0,
                            child: getArrowWidget(DirectionArrow.bottom)),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: interval,
            ),
          ],
        );
      }
    }
    if (direction == Direction.Top) {
      //设置的在按钮顶部，检查能否显示在顶部
      if (checkIsTop(context, childWidth, childHeight)) {
        childWidget = Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            verticalDialogChildWidget(childWidth, subtractWidth),
            showArrow
                ? SizedBox(
                    width: childWidth,
                    height: arrowHeight,
                    child: Stack(
                      children: [
                        Positioned(
                            left: positionedLeft,
                            top: 0,
                            child: getArrowWidget(DirectionArrow.bottom)),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: interval,
            ),
          ],
        );
      } else {
        childWidget = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            SizedBox(
              height: interval,
            ),
            showArrow
                ? SizedBox(
                    width: childWidth,
                    height: arrowHeight,
                    child: Stack(
                      children: [
                        Positioned(
                            left: positionedLeft,
                            top: 0,
                            child: getArrowWidget(DirectionArrow.top)),
                      ],
                    ),
                  )
                : Container(),
            verticalDialogChildWidget(childWidth, subtractWidth),
          ],
        );
      }
    }
    return childWidget;
  }

  Widget? getHorizontalDialogWidget(
      BuildContext context, double? childWidth, double? childHeight) {
    double sizedBoxHeight = showChildHeight;
    double offsetY = showChildHeight / 2 - arrowHeight / 2;
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;

    double diffY = button.height - showChildHeight;
    double y = position.top + diffY / 2;
    print(
        "button.height：${button.height}  position.top: ${position.top}   position.bottom: ${position.bottom} ");
    if (intelligentConversion) {
      if (y < 0.0) {
        print("顶部");

        ///顶部
        y = 0.0;
        double heightY = position.top + button.height;
        crossAxisAlignment = CrossAxisAlignment.start;
        if (heightY >= arrowHeight) {
          sizedBoxHeight = heightY;
          offsetY = position.top + button.height / 2 - arrowHeight / 2;
        } else {
          sizedBoxHeight = position.top + button.height + arrowHeight;
          offsetY =
              position.top + button.height + arrowHeight - arrowHeight / 2;
        }
      } else if (y > MediaQuery.of(context).size.height - showChildHeight) {
        print("底部");

        ///底部
        // y = MediaQuery.of(context).size.height - showChildHeight;
        double heightY = MediaQuery.of(context).size.height - position.top;
        crossAxisAlignment = CrossAxisAlignment.end;
        if (heightY >= arrowHeight) {
          sizedBoxHeight = heightY;
          double bottomDistance =
              MediaQuery.of(context).size.height - position.top - button.height;
          if (bottomDistance >= 0) {
            if (button.height > arrowHeight) {
              offsetY = button.height / 2 - arrowHeight / 2;
            } else {
              offsetY = 0;
              sizedBoxHeight = (arrowHeight - button.height) / 2 + heightY;
            }
          } else {
            offsetY = heightY / 2 - arrowHeight / 2;
          }
        } else {
          sizedBoxHeight = arrowHeight;
          offsetY = 0;
        }
      }
    }
    print("sizedBoxHeight: $sizedBoxHeight    offsetY: ${offsetY}");
    Widget? childWidget;
    if (direction == Direction.Left) {
      if (checkIsLeft(context, childWidth, childHeight)) {
        childWidget = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque, onTap: () {}, child: child),
            if (showArrow)
              SizedBox(
                height: sizedBoxHeight,
                width: arrowWidth,
                child: Stack(
                  children: [
                    Positioned(
                        top: offsetY,
                        child: getArrowWidget(DirectionArrow.right)
                        // CustomPaint(
                        //   size: Size(arrowWidth, arrowHeight),
                        //   painter: _TrianglePainter(
                        //       directionArrow: DirectionArrow.right,
                        //       color: HexColor(dialogThemeUtil.arrowColor),
                        //       borderColor:
                        //           HexColor(dialogThemeUtil.arrowBorderColor)),
                        // ),
                        ),
                  ],
                ),
              )
            else
              Container(),
            SizedBox(
              width: interval,
            ),
          ],
        );
      } else {
        childWidget = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            SizedBox(
              width: interval,
            ),
            if (showArrow)
              SizedBox(
                height: sizedBoxHeight,
                width: arrowWidth,
                child: Stack(
                  children: [
                    Positioned(
                        top: offsetY, child: getArrowWidget(DirectionArrow.left)
                        // CustomPaint(
                        //   size: Size(arrowWidth, arrowHeight),
                        //   painter: _TrianglePainter(
                        //       directionArrow: DirectionArrow.left,
                        //       color: HexColor(dialogThemeUtil.arrowColor),
                        //       borderColor:
                        //           HexColor(dialogThemeUtil.arrowBorderColor)),
                        // ),
                        ),
                  ],
                ),
              )
            else
              Container(),
            GestureDetector(
                behavior: HitTestBehavior.opaque, onTap: () {}, child: child)
          ],
        );
      }
    }
    if (direction == Direction.Right) {
      if (checkIsRight(context, childWidth, childHeight)) {
        childWidget = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            SizedBox(
              width: interval,
            ),
            if (showArrow)
              SizedBox(
                height: sizedBoxHeight,
                width: arrowWidth,
                child: Stack(
                  children: [
                    Positioned(
                        top: offsetY, child: getArrowWidget(DirectionArrow.left)
                        // CustomPaint(
                        //   size: Size(arrowWidth, arrowHeight),
                        //   painter: _TrianglePainter(
                        //       directionArrow: DirectionArrow.left,
                        //       color: HexColor(dialogThemeUtil.arrowColor),
                        //       borderColor:
                        //           HexColor(dialogThemeUtil.arrowBorderColor)),
                        // ),
                        ),
                  ],
                ),
              )
            else
              Container(),
            GestureDetector(
                behavior: HitTestBehavior.opaque, onTap: () {}, child: child)
          ],
        );
      } else {
        childWidget = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque, onTap: () {}, child: child),
            if (showArrow)
              SizedBox(
                height: sizedBoxHeight,
                width: arrowWidth,
                child: Stack(
                  children: [
                    Positioned(
                        top: offsetY,
                        child: getArrowWidget(DirectionArrow.right)
                        // CustomPaint(
                        //   size: Size(arrowWidth, arrowHeight),
                        //   painter: _TrianglePainter(
                        //       directionArrow: DirectionArrow.right,
                        //       color: HexColor(dialogThemeUtil.arrowColor),
                        //       borderColor:
                        //           HexColor(dialogThemeUtil.arrowBorderColor)),
                        // ),
                        ),
                  ],
                ),
              )
            else
              Container(),
            SizedBox(
              width: interval,
            ),
          ],
        );
      }
    }
    return childWidget;
  }

  //检查能否显示在控件的底部（底部距离不够，则检查顶部距离是否足够，不够则按设置的显示在底部）
  bool checkIsBottom(
      BuildContext context, double? childWidth, double? childHeight) {
    double height = MediaQuery.of(context).size.height;
    double y = position.top;
    if (intelligentConversion && childHeight != null) {
      if (y + childHeight > height) {
        double newY = position.top - childHeight - button.height;
        if (newY > 0) {
          return false;
        }
      }
    }
    return true;
  }

  //检查能否显示在控件的顶部（顶部距离不够，则检查底部距离是否足够，不够则按设置的显示在顶部）
  bool checkIsTop(
      BuildContext context, double? childWidth, double? childHeight) {
    if (intelligentConversion && childHeight != null) {
      double y = position.top - button.height - childHeight;
      if (y < 0.0) {
        double newY = position.top + button.height + childHeight;
        if (newY < MediaQuery.of(context).size.height) {
          return false;
        }
      }
    }
    return true;
  }

  //检查能否显示在控件的左边（左边距离不够，则检查右边距离是否足够，不够则按设置的显示在左边）
  bool checkIsLeft(
      BuildContext context, double? childWidth, double? childHeight) {
    print("childWidth: ${childWidth}  position.left: ${position.left}");
    if (intelligentConversion && childWidth != null) {
      double x = position.left - childWidth;

      ///左边位置不足以显示弹窗
      if (x < 0) {
        double rightShowWidget =
            MediaQuery.of(context).size.width - position.left - button.width;

        ///右边位置足够
        if (rightShowWidget - childWidth > 0) {
          return false;
        }
      }
    }
    return true;
  }

  //检查能否显示在控件的右边（右边距离不够，则检查左边距离是否足够，不够则按设置的显示在右边）
  bool checkIsRight(
      BuildContext context, double? childWidth, double? childHeight) {
    double width = MediaQuery.of(context).size.width;
    double x = width - position.right;
    if (intelligentConversion && childWidth != null) {
      ///右边位置不足
      if (x + childWidth > width) {
        double newX = position.left - childWidth;

        ///左边位置足够
        if (newX > 0) {
          return false;
        }
      }
    }
    return true;
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position, {
    required this.direction,
    required this.intelligentConversion,
    required this.button,
  });

  final RelativeRect position;
  final Direction direction;
  final bool intelligentConversion;
  final Size button;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  //childSize代表popupwindow
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    Offset offset = Offset(0.0, 0.0);
    switch (direction) {
      case Direction.Bottom:
        offset = bottom(size, childSize);
        break;
      case Direction.Left:
        offset = left(size, childSize);
        break;
      case Direction.Right:
        offset = right(size, childSize);
        break;
      case Direction.Top:
        offset = top(size, childSize);
        break;
    }
    print("dx: ${offset.dx}\ndy: ${offset.dy}");
    return offset;
  }

  //触发控件下方
  Offset bottom(Size size, Size childSize) {
    double y = position.top;
    double x;
    //点击view的宽度
    double diffX = button.width - childSize.width;
    x = position.left + diffX / 2;
    if (intelligentConversion) {
      if (x < 0.0) {
        x = 0.0;
      } else if (x > size.width - childSize.width) {
        x = size.width - childSize.width;
      }
      if (y + childSize.height > size.height) {
        double newY = position.top - childSize.height - button.height;
        if (newY > 0) {
          y = newY;
        }
      }
    }
    return Offset(x, y);
  }

  //触发控件上方
  Offset top(Size size, Size childSize) {
    double y = position.top - button.height - childSize.height;
    double diffX = button.width - childSize.width;
    double x = position.left + diffX / 2;
    if (intelligentConversion) {
      if (x < 0.0) {
        x = 0.0;
      } else if (x > size.width - childSize.width) {
        x = size.width - childSize.width;
      }
      if (y < 0.0) {
        double newY = position.top + button.height + childSize.height;
        if (newY < size.height) {
          y = position.top;
        }
      }
    }
    return Offset(x, y);
  }

  //触发控件左边
  Offset left(Size size, Size childSize) {
    double x = position.left - childSize.width;
    print(
        "position.left: ${position.left}  childSize.width: ${childSize.width}");
    print("button.width: ${button.width}  button.height: ${button.height}");
    double diffY = button.height - childSize.height;
    double y = position.top + diffY / 2;
    if (intelligentConversion) {
      if (x < 0) {
        double rightShowWidget = size.width - position.left - button.width;
        if (rightShowWidget - childSize.width > 0) {
          x = position.left + button.width;
        }
      }
      if (y < 0.0) {
        y = 0.0;
      } else if (y > size.height - childSize.height) {
        y = size.height - childSize.height;
      }
    }
    return Offset(x, y);
  }

  //触发控件右边
  Offset right(Size size, Size childSize) {
    double x = size.width - position.right;
    double diffY = button.height - childSize.height;
    double y = position.top + diffY / 2;
    if (intelligentConversion) {
      if (x + childSize.width > size.width) {
        double newX = position.left - childSize.width;
        if (newX > 0) {
          x = newX;
        }
      }
      if (y < 0.0) {
        y = 0.0;
      } else if (y > size.height - childSize.height) {
        y = size.height - childSize.height;
      }
    }
    return Offset(x, y);
  }

  //屏幕底部
  Offset windowButton(Size size, Size childSize) {
    double x = (size.width - childSize.width) / 2;
    double y = size.height - childSize.height;
    return Offset(x, y);
  }

  //屏幕左边
  Offset windowLeft(Size size, Size childSize) {
    double x = 0;
    double y = (size.height - childSize.height) / 2;
    return Offset(x, y);
  }

  //屏幕右边
  Offset windowRight(Size size, Size childSize) {
    double x = size.width - childSize.width;
    double y = (size.height - childSize.height) / 2;
    return Offset(x, y);
  }

  //屏幕顶部
  Offset windowTop(Size size, Size childSize) {
    double x = (size.width - childSize.width) / 2;
    double y = 0;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

///箭头的指向
enum DirectionArrow {
  //指向上方
  top,
  //指向下方
  bottom,
  //指向左边
  left,
  //指向右边
  right,
}

// 绘制箭头
class _TrianglePainter extends CustomPainter {
  // bool isDownArrow;
  Color color;
  Color borderColor;
  DirectionArrow directionArrow;

  _TrianglePainter({
    // required this.isDownArrow,
    required this.directionArrow,
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.strokeWidth = 2.0;
    paint.color = color;
    paint.style = PaintingStyle.fill;

    switch (directionArrow) {
      case DirectionArrow.top:
        path.moveTo(0.0, size.height + 0.5);
        path.lineTo(size.width / 2.0, 0.0);
        path.lineTo(size.width, size.height + 0.5);
        break;
      case DirectionArrow.bottom:
        path.moveTo(0.0, -0.5);
        path.lineTo(size.width / 2.0, size.height);
        path.lineTo(size.width, -0.5);
        break;
      case DirectionArrow.left:
        path.moveTo(size.width + 0.5, size.height);
        path.lineTo(0.0, size.height / 2.0);
        path.lineTo(size.width + 0.5, 0.0);
        break;
      case DirectionArrow.right:
        path.moveTo(-0.5, 0.0);
        path.lineTo(size.width, size.height / 2.0);
        path.lineTo(-0.5, size.height);
        break;
    }
    // if (isDownArrow) {
    //   path.moveTo(0.0, -1.5);
    //   path.lineTo(size.width / 2.0, size.height);
    //   path.lineTo(size.width, -1.5);
    // } else {
    //   path.moveTo(0.0, size.height + 1.5);
    //   path.lineTo(size.width / 2.0, 0.0);
    //   path.lineTo(size.width, size.height + 1.5);
    // }

    canvas.drawPath(path, paint);
    Paint paintBorder = Paint();
    Path pathBorder = Path();
    paintBorder.strokeWidth = 0.5;
    paintBorder.color = borderColor;
    paintBorder.style = PaintingStyle.stroke;

    switch (directionArrow) {
      case DirectionArrow.top:
        pathBorder.moveTo(0.5, size.height + 0.5);
        pathBorder.lineTo(size.width / 2.0, 0);
        pathBorder.lineTo(size.width - 0.5, size.height + 0.5);
        break;
      case DirectionArrow.bottom:
        pathBorder.moveTo(0.0, -0.5);
        pathBorder.lineTo(size.width / 2.0, size.height);
        pathBorder.lineTo(size.width, -0.5);
        break;
      case DirectionArrow.left:
        pathBorder.moveTo(size.width + 0.5, size.height);
        pathBorder.lineTo(0.0, size.height / 2.0);
        pathBorder.lineTo(size.width + 0.5, 0.0);
        break;
      case DirectionArrow.right:
        pathBorder.moveTo(-0.5, 0.0);
        pathBorder.lineTo(size.width, size.height / 2.0);
        pathBorder.lineTo(-0.5, size.height);
        break;
    }
    // if (isDownArrow) {
    //   pathBorder.moveTo(0.0, -0.5);
    //   pathBorder.lineTo(size.width / 2.0, size.height);
    //   pathBorder.lineTo(size.width, -0.5);
    // } else {
    //   pathBorder.moveTo(0.5, size.height + 0.5);
    //   pathBorder.lineTo(size.width / 2.0, 0);
    //   pathBorder.lineTo(size.width - 0.5, size.height + 0.5);
    // }

    canvas.drawPath(pathBorder, paintBorder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
