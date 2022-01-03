import 'dart:io';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:wallet_controller/model/model.dart';
import 'package:wallet_controller/model/transactionModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wallet_controller/view/Startingpage/startingpage.dart';
import 'package:wallet_controller/view/catogories/catogories.dart';
import 'package:wallet_controller/view/landingpage/landingpage.dart';
import 'package:wallet_controller/view/splashScreen/splashScreen.dart';
import 'package:wallet_controller/view/transaction_screen/transaction.dart';

final FlutterLocalNotificationsPlugin notification =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Directory path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(ModelAdapter());
  await Hive.openBox<Model>("catogeries");
  Hive.registerAdapter(TransactionmodelAdapter());
  await Hive.openBox<Transactionmodel>("transaction");

  runApp(GetMaterialApp(
    theme: ThemeData(
        timePickerTheme: TimePickerThemeData(
      dialHandColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      dialBackgroundColor: HexColor('#CFF1EF'),
      backgroundColor: Colors.white,
    )),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const StartingPage(),
      'Home': (context) => const LandingPage(),
      'inccat': (context) => const Categories(),
      "transaction": (context) => const AddTransactions(),
      "splash": (context) => const SplashScreen(),
    },
  ));
}
