import 'dart:async';

import 'package:background_blue/src/utils/log_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class BackgroundBt {
  BackgroundBt._iternal();
  static BackgroundBt _instance = BackgroundBt._iternal();
  static BackgroundBt get instance => _instance;

  final logger = getLogger('BackgroundLocation');
  final _methodChannel = MethodChannel('fr4nk.com/background-location');

  final StreamController<List<Beacon>> _beaconController = StreamController();
  Stream<List<Beacon>> get streamBeacon => _beaconController.stream;

  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  Future<void> start() async {
    logger.i('INICIANDO BACKGROUND LOCATION');
    _methodChannel.invokeMethod('start');

    await flutterBeacon.initializeScanning;

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
            _beaconController.add(list);
            logger.i('BEACON DETECTADO');
            logger.d(list[0]);
          }
          _beacons.addAll(list);
        });
        _beacons.sort(_compareParameters);
      }
    });
  }

  Future<void> stop() async {
    await _methodChannel.invokeMethod('stop');
    if (_beacons.isNotEmpty) {
      _beacons.clear();
    }

    _streamRanging?.pause();

    streamController?.close();
    _streamRanging?.cancel();
    _streamBluetooth?.cancel();
    _beaconController?.close();
    flutterBeacon.close;
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
}
