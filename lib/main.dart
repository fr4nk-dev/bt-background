import 'package:background_blue/src/app_controller.dart';
import 'package:background_blue/src/db/db.dart';
import 'package:background_blue/src/enviroment/enviroment.dart';
import 'package:background_blue/src/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

void main() async {
  Logger.level = isProduction ? Level.warning : Level.verbose;

  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Get.put(AppController());
    return GetMaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}
