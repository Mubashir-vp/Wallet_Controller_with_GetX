import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/landingpage/landing_controller.dart';
import 'package:wallet_controller/view/transaction_screen/transaction.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var constant = Get.put(Constantwidgets());

    return SafeArea(
        child: GetBuilder<LandingpageController>(
            init: LandingpageController(),
            builder: (controller) {
              return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: constant.myColors.black,
                  child: Icon(
                    Icons.add,
                    color: constant.myColors.Primarywhite,
                    size: 41,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  onPressed: () {
                    Get.to(AddTransactions());
                  },
                ),
                 bottomNavigationBar:controller.bottomBar(context: context),
                body: IndexedStack(
                    index: controller.currentIndex,
                    children: controller.screens),
              );
            }));
  }
}
