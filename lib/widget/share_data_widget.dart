import 'package:flutter/material.dart';

class ShareDataWidget extends InheritedWidget {
   ShareDataWidget({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

   int data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget? of(BuildContext context) {
    print("ShareDataWidget");
    ///引用值，数据改变后会刷新
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
    ///只引用初始值，数据改变后不刷新
    // return context
    //     .getElementForInheritedWidgetOfExactType<ShareDataWidget>()!.widget as ShareDataWidget;
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(ShareDataWidget old) {
    return old.data != data;
  }
}
