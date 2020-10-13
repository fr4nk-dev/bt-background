import 'package:background_blue/src/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Background'),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () {
                    if (!appController.authorizationStatusOk.value) {
                      return RaisedButton(
                          child: Text('Habilitar localizacion'),
                          onPressed: () async {
                            appController.authorizationStatusOk.value =
                                await flutterBeacon.requestAuthorization;
                            print(appController.authorizationStatusOk.value);
                          });
                    } else {
                      return Text('Localizacion habilitada');
                    }
                  },
                ),
                Obx(() {
                  if (!appController.bluetoothEnabled.value) {
                    return RaisedButton(
                        child: Text('Habilitar bluetooth'),
                        onPressed: () async {
                          appController.bluetoothEnabled.value =
                              await flutterBeacon.openBluetoothSettings;
                          print(appController.bluetoothEnabled.value);
                        });
                  } else {
                    return Text('Bluetooth habilitado');
                  }
                }),
                RaisedButton(
                  child: Text('Iniciar escaneo'),
                  onPressed: () {
                    print('Inicializa el escaneo');
                    appController.initScanBeacon();
                  },
                ),
                RaisedButton(
                  child: Text('Detener escaneo'),
                  onPressed: () {
                    print('Detener escaneo');
                    appController.pauseScanBeacon();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
