import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/home_page/homescreen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var constant = Get.put(Constantwidgets());

    // var homescreencontroller

    return SafeArea(
      child: Scaffold(
        backgroundColor: constant.myColors.Primarywhite,
        body: SizedBox(
           height: MediaQuery.of(context).size.height / 1.1,
          width: MediaQuery.of(context).size.width,
          child: GetBuilder<HomeScreenController>(
            init:HomeScreenController() ,
            builder: (controller) {
              return Column(children: [
                constant.welcomText(txt1: "Welcome", txt2: "Manage your Finance Easily", ctx: context),
                controller.totalBalnce(context: context),
                controller.incomeExpenseBox(context: context),
                const SizedBox(
                height: 50,
              ),
              controller.transactionShow(context: context)
              ],);
            }
          ),
        ),
      ),
    );
  }
}
