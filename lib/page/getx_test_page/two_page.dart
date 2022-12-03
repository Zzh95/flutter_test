import 'package:flutter/material.dart';

import 'getx_test_page.dart';
import 'package:get/get.dart';
class TwoPage extends StatefulWidget {
  const TwoPage({Key? key}) : super(key: key);

  @override
  _TwoPageState createState() => _TwoPageState();
}

class _TwoPageState extends State<TwoPage> {
  late CounterController controller;
  late CounterController2 controller2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find();
    controller2 = Get.find();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<CounterController2>(builder: (controller2){
              return Text("controller2点击次数: ${controller2.count}");
            }),
            Text("controller2点击次数: ${controller2.count}"),
            Builder(builder: (context) {
              print("增加 build");
              return ElevatedButton(
                child: const Text("controller增加"),
                onPressed: () {
                  // count++;
                  controller.increment();
                },
              );
            }),
            Builder(builder: (context) {
              print("增加 build");
              return ElevatedButton(
                child: const Text("controller2增加"),
                onPressed: () {
                  // count++;

                  controller2.increment();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
