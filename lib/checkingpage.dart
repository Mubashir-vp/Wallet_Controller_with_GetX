import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallet_controller/new_ui/new_splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_controller/widget/widget.dart';
import 'home.dart';
import 'new_ui/new_homescreen.dart';

class CheckingPage extends StatefulWidget {
  const CheckingPage({Key? key}) : super(key: key);

  @override
  State<CheckingPage> createState() => _CheckingPageState();
}

class _CheckingPageState extends State<CheckingPage> {
  var IS_LOGGEDIN = 'loggedin';
  bool isLoggedIn = false;

  Future<void> checkButtonSwitched() async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkButtonSwitched();

    checkButtonSwitched();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: obj.secondary,
        body: Center(child: img1()),
      ),
    );
  }
}
