import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class BlueController extends GetxController {
  @override
  void onInit() async {
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      print('ERROR $e');
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
