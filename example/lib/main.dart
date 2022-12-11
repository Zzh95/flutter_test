import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test_plugin/flutter_test_plugin.dart';
import 'package:flutter_test_plugin_example/test_page/popup_windows_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterTestPlugin.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: TestPage(),
        ),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return InheritedTestPage();
            }));
          },
          child: Text('InheritedWidget测试'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return ProviderRoute();
            }));
          },
          child: Text('Provider测试'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return GetXTestPage();
            }));
          },
          child: Text('getX测试页面'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return PopupWindowsPage();
            }));
          },
          child: Text('弹窗测试页面'),
        ),
      ],
    );
  }
}

