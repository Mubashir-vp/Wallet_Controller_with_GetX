import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/overview/overview_controller.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var constant = Get.put(Constantwidgets());
    var overviewcontroller = Get.put(OverviewController());
    return Scaffold(
      backgroundColor: constant.myColors.Primarywhite,
      body: SafeArea(
        child: GetBuilder<OverviewController>(
          builder: (overviewcontroller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                constant.welcomText(
                    txt1: "Overview",
                    txt2: "Your transaction statitics",
                    ctx: context),
                Divider(
                  color: constant.myColors.Primarywhite,
                ),
                overviewcontroller.dropDown(context: context),
                overviewcontroller.selectionButton(),
                overviewcontroller.pie(context: context),
                            Divider(),

                overviewcontroller.transactionShow(context: context)
              ],
            );
          }
        ),
      ),
    );
  }
}
