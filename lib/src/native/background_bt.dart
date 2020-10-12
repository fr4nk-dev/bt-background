import 'dart:async';

import 'package:background_blue/src/utils/log_printer.dart';
import 'package:flutter/services.dart';

class BackgroundBt {
  BackgroundBt._iternal();
  static BackgroundBt _instance = BackgroundBt._iternal();
  static BackgroundBt get instance => _instance;

  final logger = getLogger('BackgroundLocation');
  final _methodChannel = MethodChannel('fr4nk.com/background-location');

  bool _running = false;

  Future<void> start() async {
    logger.i('INICIANDO BACKGROUND LOCATION');
    _methodChannel.invokeMethod('start');
    _running = true;
  }

  Future<void> stop() async {
    await _methodChannel.invokeMethod('stop');
    _running = false;
  }
}
