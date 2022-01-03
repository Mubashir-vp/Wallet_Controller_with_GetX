import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/controller/settings/settings_controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var setting_statecontroller = Get.put(Settings_controller());
    var constatnt = Get.put(Constantwidgets());

    return SafeArea(
        child: Scaffold(
      backgroundColor: constatnt.myColors.Primarywhite,
      body: SingleChildScrollView(
        child: GetBuilder<Settings_controller>(
          init: Settings_controller(),
          builder: (controller) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    constatnt.welcomText(
                        txt1: 'Settings',
                        txt2: "Configure your settings",
                        ctx: context),
                        
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 9),
                controller.firstTile(),
                controller.tileShow?controller.notificationTile(context: context):const SizedBox(),
                controller.aboutTile(context: context),
                 Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child:controller. Setiing(txt: "Version: 1.0.3"),
                ),


              ],
            );
          }
        ),
      ),
    ));
  }
}
