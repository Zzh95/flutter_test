import 'package:flutter/material.dart';
import 'package:flutter_test_plugin/page/inherited_test_page/widget/button_widget.dart';
import 'package:flutter_test_plugin/page/inherited_test_page/widget/text_widget.dart';

import '../../widget/share_data_widget.dart';
class InheritedTestPage extends StatefulWidget {
  const InheritedTestPage({Key? key}) : super(key: key);

  @override
  _InheritedTestPageState createState() => _InheritedTestPageState();
}

class _InheritedTestPageState extends State<InheritedTestPage> {
  int count = 5;
  @override
  Widget build(BuildContext context) {
    print('最外层build');
    return Scaffold(
      body: Center(
        child: ShareDataWidget( //使用ShareDataWidget
          data: count,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: TextWidget(),//子widget中依赖ShareDataWidget
              ),
              ButtonWidget(),
              // ElevatedButton(
              //   child: const Text("Increment"),
              //   //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
              //   onPressed: () => setState(() => ++count),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
