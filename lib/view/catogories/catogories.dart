import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/category/catogories_widgetcontroller.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var constatnt = Get.put(Constantwidgets());
    var widgetController = Get.put(CatogoriesWidgets());

    return SafeArea(
      child: Scaffold(
        backgroundColor: constatnt.myColors.Primarywhite,
        body: GetBuilder<CatogoriesWidgets>(
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                constatnt.welcomText(
                    txt1: "Category", txt2: "All category Details", ctx: context),
               widgetController.selectionButton(),
                   
               
               widgetController.addButton(context: context) ,

                 widgetController.catogoriesShow(),
                    
                controller.categorieBasedTransactionshow(
                          context: context),
              ],
            );
          }
        ),
      ),
    );
  }
}
