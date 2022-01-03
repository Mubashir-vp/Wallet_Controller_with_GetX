import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/startingpage/startingpage_controller.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      var constant = Get.put(Constantwidgets());

    return SafeArea(
      child: GetBuilder<StaringPageController>(
        init: StaringPageController(context: context),
        builder: (controller) {
          return Scaffold(
            backgroundColor: constant.myColors.secondary,
            body: Center(child:controller. img1()),
          );
        }
      ),
    );
  }
}