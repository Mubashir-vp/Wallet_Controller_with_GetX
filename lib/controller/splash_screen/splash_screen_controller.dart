import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_controller/constants/constant_widget.dart';

class SplashScreenController extends GetxController {
  void onInit() {
    super.onInit();
    checkButtonSwitched(context: context);
  }

  var constant = Get.put(Constantwidgets());

  var context;
  SplashScreenController({required this.context});
//*********Variables******************************************************

  bool isLoggedIn = false;
  static const IS_LOGGEDIN = 'loggedin';

//*********Functions******************************************************

  trueFunction() async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool(IS_LOGGEDIN, true);
  }

  Future<void> checkButtonSwitched({required var context}) async {
    WidgetsFlutterBinding.ensureInitialized();
    final sharedPreference = await SharedPreferences.getInstance();
    final logeedin = sharedPreference.getBool(IS_LOGGEDIN);
    if (logeedin == true) {
      Navigator.pushReplacementNamed(context, "Home");
    }
  }

//*********Widgets******************************************************
  Widget img() {
    return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
            child: Image(
          image: AssetImage("asset/wallet png.png"),
        )));
  }

  Widget body({required var context}) {
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
        ),
        img(),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: Text(
            "Your Wallet\nControl In\nOne App.",
            style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: constant.myColors.black),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            isLoggedIn == true;
            trueFunction();
            checkButtonSwitched(context: context);
          },
          child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: constant.myColors.black),
              margin: const EdgeInsets.only(left: 80, right: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Get Started",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: constant.myColors.Primarywhite),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: constant.myColors.Primarywhite,
                    size: 34.77,
                  )
                ],
              )),
        ),
        Divider()
      ],
    );
  }
}
