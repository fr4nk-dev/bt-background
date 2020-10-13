import 'dart:async';

import 'package:background_blue/src/native/background_bt.dart';
import 'package:background_blue/src/utils/log_printer.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final logger = getLogger('AppController');

  RxString mensaje = "prueba".obs;
  RxBool authorizationStatusOk = false.obs;
  RxBool locationServiceEnabled = false.obs;
  RxBool bluetoothEnabled = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await checkAllRequirements();
  }

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;

    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.always;

    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;

    this.bluetoothEnabled.value = bluetoothEnabled;
    this.authorizationStatusOk.value = authorizationStatusOk;
    this.locationServiceEnabled.value = locationServiceEnabled;
  }

  initScanBeacon() async {
    BackgroundBt.instance.start();
  }

  pauseScanBeacon() async {
    BackgroundBt.instance.stop();
  }

  @override
  void onClose() {
    BackgroundBt.instance.stop();
    super.onClose();
  }
}
