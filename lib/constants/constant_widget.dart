import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hexcolor/hexcolor.dart';

class Constantwidgets extends GetxController {
  MyColors myColors = MyColors();

  

  Widget welcomText({required String txt1, required String txt2,required var ctx}) {
    return Container(
        width: MediaQuery.of(ctx).size.width / 1.45,
        margin: const EdgeInsets.only(
          top: 20,
          left: 14,
        ),
        child: RichText(
          text: TextSpan(
            text: '$txt1.\n',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: myColors.black),
            children: <TextSpan>[
              TextSpan(
                  text: txt2,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: HexColor("#A3A3A3"))),
            ],
          ),
        ));
  }
}
class MyColors {
  Color Primarywhite = HexColor("#FFFFFF");
  Color yellow = HexColor("#FFBB38");
  Color black = HexColor("#281B13");
  Color secondary = HexColor("#F3F1EC");
}