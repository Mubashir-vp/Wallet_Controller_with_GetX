import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaringPageController extends GetxController {
  void onInit() {
    super.onInit();
    checkButtonSwitched(context: context);

  }
  Widget img1() {
  return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(
          child: Image(
        image: AssetImage("asset/Untitled-1sas-removebg-preview.png"),
      )));
}

  var context;
  StaringPageController({required this.context});
  var IS_LOGGEDIN = 'loggedin';
  bool isLoggedIn = false;

  Future<void> checkButtonSwitched({required var context}) async {
    final sharedPreference = await SharedPreferences.getInstance();
    final isLoggedIn = sharedPreference.getBool(IS_LOGGEDIN);
    if (isLoggedIn == true) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "Home");
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "splash");
      });
    }
  }
}
