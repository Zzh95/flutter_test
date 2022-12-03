import 'package:flutter/material.dart';
import 'package:flutter_test_plugin/page/getx_test_page/two_page.dart';
import 'package:get/get.dart';

import 'model.dart';

class CounterController extends GetxController {
  int count = 0;

  void increment() {
    count++;
    update();
  }
}

class CounterController2 extends GetxController {
  CounterController2(this.count);

  int count = 0;

  void increment() {
    // count++;
    update();
  }
}

class GetXTestPage extends StatefulWidget {
  const GetXTestPage({Key? key}) : super(key: key);

  @override
  _GetXTestPageState createState() => _GetXTestPageState();
}

class _GetXTestPageState extends State<GetXTestPage> {
  RxInt count = 0.obs;
  RxList listData = ['12', '45'].obs;
  Rx<Model> model = Model().obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put<CounterController>(CounterController());
    Get.lazyPut<CounterController2>(() => CounterController2(2));
    // Get.put<CounterController2>(CounterController2(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetXTestPage'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetBuilder<CounterController>(builder: (controller) {
              return Column(
                children: [
                  Text("controller点击次数: ${controller.count}"),
                  GetBuilder<CounterController2>(

                      builder: (controller) {
                        return Column(
                          children: [
                            Text("controller2点击次数: ${controller.count}"),
                          ],
                        );
                      }),
                ],
              );
            }),

            Builder(builder: (context) {
              print("次数 build");

              return Obx(() {
                print("obx次数 build");
                return Text("obx点击次数: $count");
              });
            }),
            Builder(builder: (context) {
              print("增加 build");
              return ElevatedButton(
                child: const Text("obx增加"),
                onPressed: () {
                  count++;
                },
              );
            }),
            CountWidget(),
          ],
        ),
      ),
    );

  }
}

class CountWidget extends StatefulWidget {
  const CountWidget({Key? key}) : super(key: key);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              controller2.count++;
              controller2.update();
              // controller2.increment();
            },
          );
        }),
        Builder(builder: (context) {
          print("跳转");
          return ElevatedButton(
            child: const Text("跳转"),
            onPressed: () {
              // count++;
              Get.to(TwoPage());
            },
          );
        }),
      ],
    );
  }
}
