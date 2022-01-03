import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/model/model.dart';
import 'package:wallet_controller/model/transactionModel.dart';

class CatogoriesWidgets extends GetxController {
  @override
  void onInit() {
    super.onInit();
    catbox = Hive.box<Model>("catogeries");
    transbox = Hive.box<Transactionmodel>("transaction");
    update();
  }

  late Box<Model> catbox;
  List<int> keysInc() {
    return catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == true)
        .toList();
  }

  List<int> keys1() {
    return catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == false)
        .toList();
  }

  static late Box<Transactionmodel> transbox;
  final formKey = GlobalKey<FormState>();
  static TextEditingController categorycontroller = TextEditingController();
  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  static String formattedDate = DateFormat('MMM-dd').format(_date);
  static String formattedDate1 = DateFormat('MMM-dd').format(_date);
  static bool? colorChanger;
  static int? selectedIndex;
  static int? selectedIndexincome;
  static bool income = true;
  static bool expense = false;
  static String catogorie = "";
  static String expcatogorie = "";

  void incomeKey() {
    List<int> keys = catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == true)
        .toList();
  }

  void expenseKey() {
    List<int> keys1 = catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == false)
        .toList();
  }

  //*************************************************** */
  var constant = Get.find<Constantwidgets>();
  void items() {
    List<int> keys = catbox.keys
        .cast<int>()
        .where((Key) => income == false
            ? catbox.get(Key)!.field == false
            : catbox.get(Key)!.field == true)
        .toList();
    List<int> all1 = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.categorie == expcatogorie)
        .toList();
    List<int> all = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.categorie == catogorie)
        .toList();
    List<int> keys1 = catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == false)
        .toList();
    List<int> keysINc = catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == true)
        .toList();
  }

  Widget listView({required id}) {
    return ListView.separated(
      itemBuilder: (context, index) {
        List<int> keyy = id.reversed.toList();
        final key = keyy[index];

        final Transactionmodel? transs = transbox.get(key);

        final _date = transs!.time;

        formattedDate = DateFormat('dd').format(_date);
        formattedDate1 = DateFormat('EEE').format(_date);

        return Padding(
          padding:
              const EdgeInsets.only(left: 6.0, right: 6, bottom: 0, top: 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 28, bottom: 0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: constant.myColors.Primarywhite,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 20,
                              color: constant.myColors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            formattedDate1,
                            style: TextStyle(
                              fontSize: 10,
                              color: constant.myColors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 28,
                    bottom: 0,
                    left: 1,
                    right: 36,
                  ),
                  child: Container(
                    width: 180,
                    margin: const EdgeInsets.only(left: 1, right: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            transs.categorie.toUpperCase(),
                            style: TextStyle(
                                color: constant.myColors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            transs.notes ?? "",
                            style: TextStyle(
                                color: HexColor('#8A8A8A'),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0, top: 16, bottom: 0),
                      child: transs.isIncome == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.rupeeSign,
                                  color: HexColor("#52AA54"),
                                  size: 11,
                                ),
                                Expanded(
                                  child: Text(
                                    " ${transs.amount}",
                                    style: TextStyle(
                                        color: HexColor("#52AA54"),
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.rupeeSign,
                                  color: HexColor("#FE5355"),
                                  size: 13,
                                ),
                                Expanded(
                                  child: Text(
                                    " ${transs.amount}",
                                    style: TextStyle(
                                        color: HexColor("#FE5355"),
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            )),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (cont, index) => Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: Divider(
          thickness: 3,
          color: constant.myColors.Primarywhite,
        ),
      ),
      itemCount: id.length,
      shrinkWrap: true,
    );
  }

  Widget selectionButton() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      height: 62,
      color: HexColor("#F8F8F8"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 113,
              height: 40,
              child: TextButton(
                  style: ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: income == true
                          ? MaterialStateProperty.all(
                              constant.myColors.yellow,
                            )
                          : MaterialStateProperty.all(HexColor("#F8F8F8"))),
                  onPressed: () {
                    income = true;
                    expense = false;
                    update();
                  },
                  child: Text("Income",
                      style: TextStyle(
                          color: income == true
                              ? constant.myColors.Primarywhite
                              : constant.myColors.yellow,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w500)))),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
            width: 113,
            height: 40,
            child: TextButton(
                style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: expense == true
                        ? MaterialStateProperty.all(
                            constant.myColors.yellow,
                          )
                        : MaterialStateProperty.all(HexColor("#F8F8F8"))),
                onPressed: () {
                  expense = true;
                  income = false;
                  update();
                },
                child: Text("Expense",
                    style: TextStyle(
                        color: expense == true
                            ? constant.myColors.Primarywhite
                            : constant.myColors.yellow,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500))),
          ),
        ],
      ),
    );
  }

  Widget addButton({required var context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 21, right: 33),
      child: Container(
        height: MediaQuery.of(context).size.height / 10.54,
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext) {
                  return AlertDialog(
                    backgroundColor: constant.myColors.secondary,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          " Add new category",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: constant.myColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: TextFormField(
                              controller: categorycontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field Is Required";
                                } else if (value.length >= 20) {
                                  return "Enter a correct category";
                                }
                                if (value[0] == " ") {
                                  return "Enter a correct category";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: constant.myColors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                labelText: 'Enter the category',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        constant.myColors.yellow)),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (income == true) {
                                      String income = categorycontroller.text;
                                      Model inccat =
                                          Model(cat: income, field: true);
                                      catbox.add(inccat);
                                      categorycontroller.clear();
                                      update();

                                      Get.back();
                                    } else {
                                      String income = categorycontroller.text;
                                      Model expcat =
                                          Model(cat: income, field: false);
                                      catbox.add(expcat);
                                      categorycontroller.clear();
                                      update();
                                      Get.back();
                                    }
                                  }
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: constant.myColors.Primarywhite,
                                      fontWeight: FontWeight.w500),
                                )),
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        constant.myColors.yellow)),
                                onPressed: () {
                                  Get.back();

                                  categorycontroller.clear();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: constant.myColors.Primarywhite,
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        )
                      ],
                    ),
                  );
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [Text("Add Category"), Icon(Icons.add)],
          ),
        ),
      ),
    );
  }

  Widget catogoriesShow() {
    List<int> keys = catbox.keys
        .cast<int>()
        .where((Key) => income == false
            ? catbox.get(Key)!.field == false
            : catbox.get(Key)!.field == true)
        .toList();

    return income == true && keys.isNotEmpty
        ? GridView.builder(
            padding: const EdgeInsets.only(
                left: 70.0, right: 70, top: 30, bottom: 30),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (context, index) {
              final int key = keys[index];
              final Model? catexp = catbox.get(key);
              return GestureDetector(
                onDoubleTap: () {
                  selectedIndexincome = null;
                  catogorie = "";
                  update();
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext) {
                        return AlertDialog(
                          backgroundColor: constant.myColors.secondary,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                " Delete this category",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  constant.myColors.yellow)),
                                      onPressed: () {
                                        catbox.delete(key);
                                        update();
                                        update();
                                        update();
                                        Get.back();

                                        update();
                                        update();
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color:
                                                constant.myColors.Primarywhite,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  constant.myColors.yellow)),
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color:
                                                constant.myColors.Primarywhite,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                onTap: () {
                  selectedIndexincome = index;
                  catogorie = catexp!.cat;
                  print(catogorie);
                  update();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: selectedIndexincome == index
                          ? constant.myColors.yellow
                          : constant.myColors.secondary,
                      borderRadius: BorderRadius.circular(9)),
                  child: Center(
                    child: Text(
                      catexp!.cat.toUpperCase(),
                      style: TextStyle(
                          color: selectedIndexincome == index
                              ? constant.myColors.Primarywhite
                              : constant.myColors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ),
                ),
              );
            },
            itemCount: keys.length,
            shrinkWrap: true,
          )
        : income == false && keys.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.only(
                    left: 70.0, right: 70, top: 30, bottom: 30),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14.0,
                    mainAxisSpacing: 10.0),
                itemBuilder: (context, index) {
                  final int key = keys[index];
                  final Model? catexp = catbox.get(key);
                  return GestureDetector(
                    onDoubleTap: () {
                      selectedIndex = null;
                      expcatogorie = "";
                      print(expcatogorie);
                      update();
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext) {
                            return AlertDialog(
                              backgroundColor: constant.myColors.secondary,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    " Delete this category",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.redAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      constant
                                                          .myColors.yellow)),
                                          onPressed: () {
                                            catbox.delete(key);

                                            update();
                                            Get.back();
                                          },
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: constant
                                                    .myColors.Primarywhite,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      constant
                                                          .myColors.yellow)),
                                          onPressed: () => Get.back(),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: constant
                                                    .myColors.Primarywhite,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    onTap: () {
                      selectedIndex = index;
                      expcatogorie = catexp!.cat;
                      print(expcatogorie);
                      update();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? constant.myColors.yellow
                              : constant.myColors.secondary,
                          borderRadius: BorderRadius.circular(9)),
                      child: Center(
                        child: Text(
                          catexp!.cat.toUpperCase(),
                          style: TextStyle(
                              color: selectedIndex == index
                                  ? constant.myColors.Primarywhite
                                  : constant.myColors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: keys.length,
                shrinkWrap: true,
              )
            : Center(
                child: Text(
                  "Empty",
                  style: TextStyle(color: Colors.red),
                ),
              );
  }

  Widget categorieBasedTransactionshow({required var context}) {
    List<int> incomeCategories = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.categorie == catogorie)
        .toList();
    List<int> expenseCatogories = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.categorie == expcatogorie)
        .toList();

    return income == true && keysInc().isNotEmpty
        ? Expanded(
            child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    color: constant.myColors.secondary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: selectedIndexincome == null
                    ? Center(
                        child: Text(
                          "Select a category",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: constant.myColors.black,
                          ),
                        ),
                      )
                    : incomeCategories.isEmpty
                        ? Center(
                            child: Text(
                              "No Transactions yet",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: constant.myColors.black,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              List<int> keyy =
                                  incomeCategories.reversed.toList();
                              final key = keyy[index];

                              final Transactionmodel? transs =
                                  transbox.get(key);

                              final _date = transs!.time;

                              formattedDate = DateFormat('dd').format(_date);
                              formattedDate1 = DateFormat('EEE').format(_date);

                              return listView(id: incomeCategories);
                            },
                            separatorBuilder: (cont, index) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: Divider(
                                thickness: 3,
                                color: constant.myColors.Primarywhite,
                              ),
                            ),
                            itemCount: incomeCategories.length,
                            shrinkWrap: true,
                          )))
        : expense == true && keys1().isNotEmpty
            ? Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        color: constant.myColors.secondary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: selectedIndex == null
                        ? Center(
                            child: Text(
                              "Select a category",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: constant.myColors.black,
                              ),
                            ),
                          )
                        : expenseCatogories.isEmpty
                            ? Center(
                                child: Text(
                                  "No Transactions yet",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: constant.myColors.black,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  List<int> keyy =
                                      expenseCatogories.reversed.toList();
                                  final key = keyy[index];

                                  final Transactionmodel? transs =
                                      transbox.get(key);

                                  final _date = transs!.time;

                                  formattedDate =
                                      DateFormat('dd').format(_date);
                                  formattedDate1 =
                                      DateFormat('EEE').format(_date);

                                  return listView(id: expenseCatogories);
                                },
                                separatorBuilder: (cont, index) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: Divider(
                                    thickness: 3,
                                    color: constant.myColors.Primarywhite,
                                  ),
                                ),
                                itemCount: expenseCatogories.length,
                                shrinkWrap: true,
                              )))
            : Center();
  }
}
