import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallet_controller/new_ui/settings.dart';
import 'package:wallet_controller/widget/widget.dart';

class NewSettings extends StatefulWidget {
  const NewSettings({Key? key}) : super(key: key);

  @override
  _NewSettingsState createState() => _NewSettingsState();
}

class _NewSettingsState extends State<NewSettings> {
  @override
  Widget build(BuildContext context) {
    Widget Setiing({required String txt, Widget? trail}) {
      return Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: obj.secondary,
            title: Center(
              child: Text(
                txt,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: obj.black,
                ),
              ),
            ),
            trailing: trail),
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
                  SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Setiing(txt: "Reminder"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
