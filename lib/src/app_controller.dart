import 'dart:async';

import 'package:background_blue/src/native/background_bt.dart';
import 'package:background_blue/src/utils/log_printer.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final logger = getLogger('AppController');

  RxString mensaje = "prueba".obs;
  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;

  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

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
    await flutterBeacon.initializeScanning;
    await checkAllRequirements();
    if (!authorizationStatusOk.value ||
        !locationServiceEnabled.value ||
        !bluetoothEnabled.value) {
      print('RETURNED, authorizationStatusOk=$authorizationStatusOk, '
          'locationServiceEnabled=$locationServiceEnabled, '
          'bluetoothEnabled=$bluetoothEnabled');
      return;
    }

    final regions = <Region>[
      Region(
        identifier: 'REDMI NOTE 4',
        proximityUUID: '2c5b729b-8325-472c-815b-44bb163ce163',
      ),
    ];

    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      // print(result);

      if (result != null) {
        _regionBeacons[result.region] = result.beacons;
        _beacons.clear();
        _regionBeacons.values.forEach((list) {
          if (list.length > 0) {
            print('####### SE DETECTO EL BEACON ######');
            print(list);
          }
          _beacons.addAll(list);
        });
        _beacons.sort(_compareParameters);
      }
    });
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    BackgroundBt.instance.start();
    if (_beacons.isNotEmpty) {
      _beacons.clear();
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  @override
  void onClose() {
    BackgroundBt.instance.start();
    streamController?.close();
    _streamRanging?.cancel();
    _streamBluetooth?.cancel();
    flutterBeacon.close;
    super.onClose();
  }
}
