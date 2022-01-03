import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/view/catogories/catogories.dart';
import 'package:wallet_controller/view/home_screen/home_screen.dart';
import 'package:wallet_controller/view/overview/overview.dart';
import 'package:wallet_controller/view/settings/settings.dart';

class LandingpageController extends GetxController {
  var constant = Get.put(Constantwidgets());

  final screens = [
    const HomeScreen(),
    const Overview(),
    const Categories(),
    const Settings()
  ];
  var currentIndex = 0;
  Widget bottomBar({required var context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8.56,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        selectedItemColor: constant.myColors.yellow,
        unselectedItemColor: constant.myColors.black,
        showUnselectedLabels: false,
        backgroundColor: constant.myColors.Primarywhite,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          currentIndex = index;
          update();
        },
        items:  [
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(right: 300.0, left: 30),
                child: FaIcon(
                  FontAwesomeIcons.home,
                ),
              ),
              label: "Home"),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 260, left: 2),
              child: FaIcon(
                FontAwesomeIcons.chartBar,
              ),
            ),
            label: "OverView",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: FaIcon(
                FontAwesomeIcons.listUl,
              ),
            ),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.cog,
            ),
            label: "Settings",
          )
        ],
      ),
    );
  }
}
