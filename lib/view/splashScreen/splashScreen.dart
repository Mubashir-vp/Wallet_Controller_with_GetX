import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/splash_screen/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      var constant = Get.put(Constantwidgets());
    return SafeArea(child: Scaffold(
      backgroundColor:constant.myColors.yellow ,
      body: GetBuilder<SplashScreenController>(
        init: SplashScreenController(context: context),
        builder: (controller) {
          return SizedBox(
                    height: MediaQuery.of(context).size.height,
      
            
            child: controller.body(context: context),);
        }
      ),
    ));
  }
}
