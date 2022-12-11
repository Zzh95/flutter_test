
import 'dart:async';

import 'package:flutter/services.dart';
export 'page/inherited_test_page/inherited_test_page.dart';
export 'page/provider_test_page/test_page.dart';
export 'page/getx_test_page/getx_test_page.dart';
export 'my_popup/popup_window_route.dart';
export 'my_popup/popup_windows.dart';

class FlutterTestPlugin {
  static const MethodChannel _channel = MethodChannel('flutter_test_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
