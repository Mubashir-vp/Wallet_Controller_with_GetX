import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:wallet_controller/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../old_ui/notification.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  static const IS_SWITCHED = 'buttonClicked';
  static const IS_ALARMON = 'alarmon';
  TimeOfDay? shardAlarm;

  bool? isSwitched;
  bool tileShow = false;

  Future<void> checkButtonSwitched() async {
    final sharedPreference = await SharedPreferences.getInstance();
    final buttonOn = sharedPreference.getBool(IS_SWITCHED);
    if (buttonOn == false) {
      setState(() {
        isSwitched = false;
      });
    } else {
      setState(() {
        isSwitched = true;
        tileShow = true;
      });
    }
  }

  sharedtimeGetting() async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedTime = sharedPreference.getString(IS_ALARMON);
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
    setState(() {
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
          body: "Its Time To Add Your Transactions",
          payload: "Payload");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkButtonSwitched();
    NotificationApi2.init(initScheduled: true);
    listenNotifications();
    sharedtimeGetting();
  }

  listenNotifications() {
    NotificationApi2.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) =>
      Navigator.pushReplacementNamed(context, 'Home');
  trueFunction() async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(IS_SWITCHED, true);
    setState(() {});
  }

  falseFunction() async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(IS_SWITCHED, false);
    setState(() {});
    NotificationApi2.cancelNotification();
  }

  alarmTimeSaver(
    var tym,
  ) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(IS_ALARMON, tym);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget Setiing({required String txt, Widget? trail}) {
      return Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
          child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: obj.secondary,
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: obj.secondary,
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

    return SafeArea(
      child: Scaffold(
          backgroundColor: obj.Primarywhite,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 302,
                        margin: const EdgeInsets.only(
                          top: 30,
                          left: 16,
                        ),
                        child: new_text(
                            txt1: 'Settings', txt2: "Configure your settings")),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 9),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child: Setiing(
                    txt: 'Notification',
                    trail: IconButton(
                      onPressed: () {
                        if (isSwitched == false) {
                          setState(() {
                            tileShow = true;
                            isSwitched = true;
                            trueFunction();
                          });
                        } else if (isSwitched == true) {
                          setState(() {
                            tileShow = false;
                            isSwitched = false;
                            falseFunction();
                            NotificationApi2.cancelNotification();
                          });
                        }
                        setState(() {});
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
                  ),
                ),
                tileShow
                    ? Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Container(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            tileColor: obj.secondary,
                            title: Center(
                              child: RichText(
                                  text: TextSpan(
                                      text: sharedTime != null
                                          ? "Reminder Set For : "
                                          : "Select time for reminder",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: obj.black,
                                      ),
                                      children: [
                                    TextSpan(
                                      text: sharedTime == null
                                          ? ""
                                          : "$sharedTime",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        color: obj.black,
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
                      )
                    : const SizedBox(),
                Padding(
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
                                            color: obj.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                      child: Setiing(txt: "About")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child: Setiing(txt: "Version: 0.0.1"),
                ),
              ],
            ),
          )),
    );
  }
}
