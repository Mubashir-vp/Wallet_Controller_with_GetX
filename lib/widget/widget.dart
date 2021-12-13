import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pie_chart/pie_chart.dart';

class MyColors {
  Color Primarywhite = HexColor("#FFFFFF");
  Color yellow = HexColor("#FFBB38");
  Color black = HexColor("#281B13");
  Color secondary = HexColor("#F3F1EC");
}

MyColors obj = MyColors();

Widget Myheading({required String? text}) {
  return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Center(
          child: Text(
        text!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          fontSize: 40,
          color: HexColor("#CFF1EF").withOpacity(0.7),
        ),
      )));
}

Widget Myheading2({required String? text}) {
  return SizedBox(
    height: 40,
    child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
            child: Text(
          text!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 20,
            color: HexColor("#CFF1EF").withOpacity(0.7),
          ),
        ))),
  );
}

Widget img() {
  return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(
          child: Image(
        image: AssetImage("asset/wallet png.png"),
      )));
}

Widget img1() {
  return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(
          child: Image(
        image: AssetImage("asset/Untitled-1sas-removebg-preview.png"),
      )));
}
//===============================quates===================================

Widget text() {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(35.0),
      child: Text(
        " \"Money, like emotions,\n is something you must control\n to keep your life on the right track.\"",
        style: TextStyle(
            color: HexColor("#678983"), fontSize: 20, fontFamily: 'Sahitya'),
      ),
    ),
  );
}

//============================getStarted button=================
Widget btn({required Function onPressed, required String txt}) {
  return TextButton(
      onPressed: onPressed(),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor("#F0E9D2")),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        txt,
        style: TextStyle(color: HexColor('#817575')),
      ));
}
//==================================home button========================================

Widget homeButton(String tip,
    {String? txt,
    IconData? icn,
    EdgeInsetsGeometry? margin,
    double? width,
    required Function onTap}) {
  return Row(
    children: [
      Padding(
        padding: EdgeInsets.all(18.0),
        child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                boxShadow: const [
                  BoxShadow(
                      spreadRadius: 1.0, blurRadius: 5.0, color: Colors.black),
                ],
                color: HexColor("#FFD66B"),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Text(
                  txt ?? "",
                  style: TextStyle(
                      fontFamily: "Sahitya",
                      fontWeight: FontWeight.w100,
                      color: HexColor('#817575')),
                ),
                IconButton(
                  tooltip: tip,
                  onPressed: () {
                    onTap();
                  },
                  icon: Icon(icn),
                  color: HexColor('#817575'),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

//======================home tile===============================================

Widget tile(
    {required String date,
    required String inc,
    required String exp,
    required TextStyle txtstyle}) {
  return Padding(
    padding: const EdgeInsets.all(19.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: HexColor('#817575'), widt)
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: HexColor('#FFFFFF'),
        leading: Container(
          child: Text(
            date,
            style: TextStyle(
              color: HexColor('#817575'),
              fontFamily: 'Poppins',
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              inc,
              style: TextStyle(
                color: HexColor('#817575'),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        trailing: Text(
          "₹$exp",
          style: txtstyle,
        ),
      ),
    ),
  );
}

//==================month view card==============================

//=============================Exp Card===========================

Widget expCard(
    {required String text1, required String text2, required Color color}) {
  return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: HexColor('#FFFFFF'),
        ),
        child: Column(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  text1,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: HexColor('#817575'),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(boxShadow: const [
                    BoxShadow(blurRadius: 3.0, color: Colors.black),
                  ], borderRadius: BorderRadius.circular(50), color: color),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        text2,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ));
}

//=============================Pie chart===========================
Map<String, double> jjjj(
    {required String txt1,
    required String txt2,
    required String txt3,
    required double val1,
    required double val2,
    required double val3}) {
  return {
    txt1: val1,
    txt2: val2,
    txt3: val3,
  };
}

Widget piechart(
    {required Map<String, double> val, required MaterialColor color}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: PieChart(
      dataMap: val,
      ringStrokeWidth: 90,
      colorList: [
        HexColor("#2f4b7c"),
        HexColor("#665191"),
        HexColor("a05195"),
        HexColor("#d45087"),
        HexColor("#f95d6a"),
        HexColor("#ff7c43"),
        HexColor("#ffa600"),
        HexColor("#003f5c"),
        color,
      ],
      chartRadius: 70,
      animationDuration: Duration(milliseconds: 1000),
      chartType: ChartType.ring,
      legendOptions: LegendOptions(
          legendPosition: LegendPosition.right,
          showLegendsInRow: false,
          showLegends: true,
          legendTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: obj.black),
          legendShape: BoxShape.circle),
      chartValuesOptions: ChartValuesOptions(
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900]!.withOpacity(0.9),
        ),
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
        decimalPlaces: 0,
        chartValueBackgroundColor: Colors.grey[200],
      ),
    ),
  );
}
//=========================expense income textfield===================================

Widget customTile() {
  return Container(
    child: Row(
      children: const [Text("Text1"), Text("Text2"), Text("text3")],
    ),
  );
}

Widget new_text({required String txt1, required String txt2}) {
  return RichText(
    text: TextSpan(
      text: '$txt1.\n',
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: obj.black),
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
  );
}
