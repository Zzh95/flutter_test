import 'package:flutter/material.dart';

import '../../../widget/share_data_widget.dart';
class ButtonWidget extends StatefulWidget {
  const ButtonWidget({Key? key}) : super(key: key);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Increment"),
      //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
      onPressed: () => setState(() => ++ShareDataWidget.of(context)!.data),
    );
  }
}
