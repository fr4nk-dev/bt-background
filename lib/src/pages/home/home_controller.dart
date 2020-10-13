import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  StreamController<List<Beacon>> _beaconSubscription;

  RxList<Beacon> beacons = List().obs;

  @override
  void onReady() {
    super.onReady();

    _beaconSubscription.stream.listen((event) {
      beacons.value = event;
    });
  }

  @override
  void onClose() {
    _beaconSubscription.close();
    super.onClose();
  }
}
