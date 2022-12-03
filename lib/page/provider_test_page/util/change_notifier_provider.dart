import 'package:flutter/material.dart';

import 'change_notifier_util.dart';
import 'inherited_provider.dart';

class ChangeNotifierProvider<T extends ChangeNotifierUtil>
    extends StatefulWidget {
  const ChangeNotifierProvider({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final T data;

  //定义一个便捷方法，方便子树中的widget获取共享数据(优化前)
  // static T of<T>(BuildContext context) {
  //   // final type = _typeOf<InheritedProvider<T>>();
  //   final provider =
  //       context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
  //   return provider!.data;
  // }


  //添加一个listen参数，表示是否建立依赖关系
  //true表示引用会刷新当前页面，
  //false表示引用该数据，但是不刷新当前页面
  static T of<T>(BuildContext context, {bool listen = true}) {

    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>()
        : context.getElementForInheritedWidgetOfExactType<InheritedProvider<T>>()?.widget
    as InheritedProvider<T>;
    return provider!.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifierUtil>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    print('update');
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      print('更新');
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}
