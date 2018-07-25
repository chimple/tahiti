import 'dart:async';

import 'package:flutter/services.dart';

class Tahiti {
  static const MethodChannel _channel =
      const MethodChannel('tahiti');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
