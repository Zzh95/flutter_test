import 'package:flutter/material.dart';

class ChangeNotifierUtil implements Listenable {
  List listeners = [];

  @override
  void addListener(VoidCallback listener) {
    print('添加监听器');
    //添加监听器
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    print('移除监听器');
    //移除监听器
    listeners.remove(listener);
  }

  void notifyListeners() {
    //通知所有监听器，触发监听器回调
    for (var item in listeners) {
      item();
    }
  }
}
