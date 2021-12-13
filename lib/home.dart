import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wallet_controller/new_ui/new_category_page.dart';
import 'package:wallet_controller/new_ui/new_overview.dart';
import 'package:wallet_controller/new_ui/new_settings.dart';
import 'package:wallet_controller/new_ui/new_transaction_add.dart';
import 'package:wallet_controller/new_ui/new_homescreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_controller/widget/widget.dart';

import 'new_ui/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final screens = [
  const NewHomeScreen(),
  const NewOverview(),
  const NewCategories(),
  const settings()
];

class _HomeState extends State<Home> {
  var currentIndex = 0;
  // Route _createRoute({required Widget child}) {
  //   return PageRouteBuilder(
  //       transitionDuration: Duration(seconds: 1),
  //       pageBuilder: (context, animation, secondaryAnimation) => child,
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) =>
  //           ScaleTransition(
  //             scale: animation,
  //             child: child,
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: obj.black,
        child: Icon(
          Icons.add,
          color: obj.Primarywhite,
          size: 41,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        onPressed: () {
          Navigator.pushNamed(context, 'transaction');
        },
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height / 8.56,
        child: BottomNavigationBar(
          showSelectedLabels: false,
          selectedItemColor: obj.yellow,
          unselectedItemColor: obj.black,
          showUnselectedLabels: false,
          backgroundColor: obj.Primarywhite,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(right: 300.0, left: 30),
                  child: FaIcon(FontAwesomeIcons.home),
                ),
                label: "add"),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(right: 260, left: 2),
                child: FaIcon(
                  FontAwesomeIcons.chartBar,
                ),
              ),
              label: "add",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(left: 50.0),
                child: FaIcon(
                  FontAwesomeIcons.listUl,
                ),
              ),
              label: "add",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.cog,
              ),
              label: "add",
            )
          ],
        ),
      ),
      body: IndexedStack(index: currentIndex, children: screens),
    );
  }
}



  // currentIndex: currentIndex,
  //         onTap: (index) {
  //           setState(() {
  //             currentIndex = index;
  //             print(currentIndex);
  //           });
  //         },