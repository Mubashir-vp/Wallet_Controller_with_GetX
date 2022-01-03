import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/transaction/transaction_controller.dart';

class AddTransactions extends StatelessWidget {
  const AddTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var constant = Get.put(Constantwidgets());
    var controllerdot = Get.put(TransactionController());

    return SafeArea(
        child: Scaffold(
      backgroundColor: constant.myColors.Primarywhite,
      body: GetBuilder<TransactionController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                constant.welcomText(
                    txt1: "Add Transaction",
                    txt2: "Add the latest transaction.",
                    ctx: context),
                const SizedBox(
                  height: 27,
                ),
                controller.selectionButton(),
                const SizedBox(
                height: 50,
              ),
              controller.textFormfield(context: context)
              ],
            ),

          );
        },
      ),
    ));
  }
}
