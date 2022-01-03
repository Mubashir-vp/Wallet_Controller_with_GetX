import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_controller/constants/constant_widget.dart';

import 'notification_service_controller.dart';

class Settings_controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkButtonSwitched();
    NotificationApi2.init(initScheduled: true);
    sharedtimeGetting();
  }

  var constatnt = Get.put(Constantwidgets());

  static const IS_SWITCHED = 'buttonClicked';
  static const IS_ALARMON = 'alarmon';
  TimeOfDay? shardAlarm;

  bool isSwitched = false;
  bool tileShow = false;

  Future<void> checkButtonSwitched() async {
    final sharedPreference = await SharedPreferences.getInstance();
    final buttonOn = sharedPreference.getBool(IS_SWITCHED);
    if (buttonOn == false) {
      isSwitched = false;
      update();
    } else {
      isSwitched = true;
      tileShow = true;
      update();
    }
  }

  sharedtimeGetting() async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedTime = sharedPreference.getString(IS_ALARMON);
  }

  trueFunction() async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(IS_SWITCHED, true);
    update();
  }

  falseFunction() async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(IS_SWITCHED, false);
    update();
    NotificationApi2.cancelNotification();
  }

  alarmTimeSaver(
    var tym,
  ) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(IS_ALARMON, tym);
    update();
  }

  var sharedTime;
  var _formated;
  static TimeOfDay time = TimeOfDay.now();

  static final now = new DateTime.now();
  var dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  var format = DateFormat.jm();

  String formatTimeOfDay(TimeOfDay tod) {
    print(format); //"6:00 AM"
    return format.format(dt);
  }

  var formatted;
  TimeOfDay timee = TimeOfDay.now();
  Future timepicker(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 09, minute: 0);
    final newTime = await showTimePicker(context: context, initialTime: time);

    if (newTime == null) return;
    time = newTime.replacing(hour: newTime.hourOfPeriod);
    timee = newTime;
    dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    format = DateFormat().add_jm();
    formatted = format.format(dt);
    _formated = timee.format(context);
    alarmTimeSaver(_formated);
    sharedtimeGetting();

    NotificationApi2.showScheduledNotification(
        scheduledTime: Time(timee.hour, timee.minute, 0),
        title: "Wallet Controller",
        body: "Its Time To Add Your Transactions");
    update();
  }

  //***************widgets */
  Widget Setiing({required String txt, Widget? trail}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: constatnt.myColors.secondary,
            title: Center(
              child: Text(
                txt,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: HexColor('#817575'),
                ),
              ),
            ),
            trailing: trail),
      ),
    );
  }

  Widget Setiing1({required String txt, Widget? trail}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: constatnt.myColors.secondary,
            title: Center(
              child: Text(
                txt,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: HexColor('#817575'),
                ),
              ),
            ),
            trailing: trail),
      ),
    );
  }

  Widget firstTile() {
    return Setiing(
      txt: 'Notification',
      trail: IconButton(
        onPressed: () {
          if (isSwitched == false) {
            tileShow = true;
            isSwitched = true;
            trueFunction();
            update();
          } else if (isSwitched == true) {
            tileShow = false;
            isSwitched = false;
            falseFunction();
            NotificationApi2.cancelNotification();
            update();
          }
          update();
        },
        padding: const EdgeInsets.only(right: 20),
        icon: isSwitched == true
            ? const Icon(
                Icons.toggle_on,
                color: Colors.green,
                size: 50,
              )
            : const Icon(
                Icons.toggle_off_outlined,
                color: Colors.grey,
                size: 50,
              ),
      ),
    );
  }

  Widget notificationTile({required var context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: Container(
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tileColor: constatnt.myColors.secondary,
          title: Center(
            child: RichText(
                text: TextSpan(
                    text: sharedTime != null
                        ? "Reminder Set For : "
                        : "Select time for reminder",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: constatnt.myColors.black,
                    ),
                    children: [
                  TextSpan(
                    text: sharedTime == null ? "" : "$sharedTime",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: constatnt.myColors.black,
                    ),
                  )
                ])),
          ),
          trailing: IconButton(
            onPressed: () {
              timepicker(context);
            },
            icon: FaIcon(
              FontAwesomeIcons.clock,
              color: HexColor("#736E62"),
            ),
          ),
        ),
      ),
    );
  }

  Widget aboutTile({required var context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: GestureDetector(
          onTap: () => showAboutDialog(
                  context: context,
                  applicationName: "Wallet Controller",
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          child: Text(
                            "This is a Offline Income Expense tracker app,developed by Mubashir.VP under BrotoType Academy. ",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: constatnt.myColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )
                  ]),
          child: Setiing(txt: "About")),
    );
  }
}
