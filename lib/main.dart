import 'dart:io';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wallet_controller/Hive/model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallet_controller/checkingpage.dart';
import 'package:wallet_controller/home.dart';
import 'package:wallet_controller/new_ui/new_category_page.dart';
import 'package:wallet_controller/new_ui/new_splashscreen.dart';
import 'package:wallet_controller/new_ui/new_transaction_add.dart';
import 'Hive/transactionModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  runApp(MaterialApp(
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
      '/': (context) => const CheckingPage(),
      'Home': (context) => const Home(),
      'inccat': (context) => const NewCategories(),
      "transaction": (context) => const NewTransactionPage(),
      "splash": (context) => const Newsplashscreen(),
    },
  ));
}
