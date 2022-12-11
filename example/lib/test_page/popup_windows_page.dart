import 'package:flutter/material.dart';
import 'package:flutter_test_plugin/my_popup/popup_windows.dart';
class PopupWindowsPage extends StatefulWidget {
  const PopupWindowsPage({Key? key}) : super(key: key);

  @override
  _PopupWindowsPageState createState() => _PopupWindowsPageState();
}

class _PopupWindowsPageState extends State<PopupWindowsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              height: 600,
            ),
            dialogWidget1(),
            Container(height: 50,),
            dialogWidget2(),
            Container(height: 50,),
            dialogWidget3(),
            Container(
              height: 600,
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogWidget1(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupWindowWidget(
          showChildHeight: 200,
          showChildWidth: 200,
          intelligentConversion: true,
          direction: Direction.Top,
          showChild: Container(
          height: 200,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue
          ),
          child: Text("测试"),
        ), child: Container(
          width: 100,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red
          ),
          child: Text("top按钮"),
        ),),
      ],
    );
  }

  Widget dialogWidget2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(width: 0,),
        PopupWindowWidget(
          showChildHeight: 200,
          showChildWidth: 100,
          intelligentConversion: true,
          arrowPosition: ArrowPosition.left,
          direction: Direction.Top,
          showChild: Container(
            height: 200,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue
            ),
            child: Text("测试"),
          ), child: Container(
          width: 150,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red
          ),
          child: Text("top按钮"),
        ),),
        Container(width: 20,),
      ],
    );
  }

  Widget dialogWidget3(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(width: 0,),
        PopupWindowWidget(
          showChildHeight: 200,
          showChildWidth: 200,
          intelligentConversion: true,
          arrowHeight: 12,
          arrowWidth: 24,
          direction: Direction.Top,
            arrowPosition: ArrowPosition.right,
          showChild: Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue
            ),
            child: Text("测试"),
          ), child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red
          ),
          child: Text("1"),
        ),),
        Container(width: 0,),
      ],
    );
  }
}
