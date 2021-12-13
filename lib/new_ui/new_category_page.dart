import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet_controller/Hive/model.dart';
import 'package:wallet_controller/Hive/transactionModel.dart';
import 'package:wallet_controller/widget/widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NewCategories extends StatefulWidget {
  const NewCategories({Key? key}) : super(key: key);

  @override
  _NewCategoriesState createState() => _NewCategoriesState();
}

class _NewCategoriesState extends State<NewCategories> {
  final formKey = GlobalKey<FormState>();
  TextEditingController categorycontroller = TextEditingController();

  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  String formattedDate = DateFormat('MMM-dd').format(_date);
  String formattedDate1 = DateFormat('MMM-dd').format(_date);
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
          child: SizedBox(
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
                        color: obj.Primarywhite,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 20,
                              color: obj.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            formattedDate1,
                            style: TextStyle(
                              fontSize: 10,
                              color: obj.black,
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
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            transs.categorie.toUpperCase(),
                            style: TextStyle(
                                color: obj.black,
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
                                Text(
                                  " ${transs.amount}",
                                  style: TextStyle(
                                      color: HexColor("#52AA54"),
                                      fontFamily: "Poppins",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
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
                                Text(
                                  " ${transs.amount}",
                                  style: TextStyle(
                                      color: HexColor("#FE5355"),
                                      fontFamily: "Poppins",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
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
          color: obj.Primarywhite,
        ),
      ),
      itemCount: id.length,
      shrinkWrap: true,
    );
  }

  bool? colorChanger;
  int? selectedIndex;
  int? _selectedIndex;
  late Box<Model> catbox;
  late Box<Transactionmodel> transbox;

  String catogorie = "";
  String expcatogorie = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catbox = Hive.box<Model>("catogeries");
    transbox = Hive.box<Transactionmodel>("transaction");
    setState(() {});
  }

  //button variables...............
  bool income = true;
  bool expense = false;

  @override
  Widget build(BuildContext context) {
    List<int> keys = catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == true)
        .toList();
    List<int> keys1 = catbox.keys
        .cast<int>()
        .where((Key) => catbox.get(Key)!.field == false)
        .toList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: obj.Primarywhite,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //WelcomeText****
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
                        txt1: 'Category', txt2: "All category Details")),
              ],
            ),
            Container(
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
                                    obj.yellow,
                                  )
                                : MaterialStateProperty.all(
                                    HexColor("#F8F8F8"))),
                        onPressed: () {
                          setState(() {
                            income = true;
                            expense = false;
                          });
                        },
                        child: Text("Income",
                            style: TextStyle(
                                color: income == true
                                    ? obj.Primarywhite
                                    : obj.yellow,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
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
                                    obj.yellow,
                                  )
                                : MaterialStateProperty.all(
                                    HexColor("#F8F8F8"))),
                        onPressed: () {
                          setState(() {
                            expense = true;
                            income = false;
                          });
                        },
                        child: Text("Expense",
                            style: TextStyle(
                                color: expense == true
                                    ? obj.Primarywhite
                                    : obj.yellow,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 21, right: 33),
              child: Container(
                height: MediaQuery.of(context).size.height / 10.54,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext) {
                          return AlertDialog(
                            backgroundColor: obj.secondary,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " Add new category",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: obj.black,
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
                                            borderSide:
                                                BorderSide(color: obj.black),
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        labelText: 'Enter the category',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    obj.yellow)),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (income == true) {
                                              String income =
                                                  categorycontroller.text;
                                              Model inccat = Model(
                                                  cat: income, field: true);
                                              catbox.add(inccat);
                                              categorycontroller.clear();
                                              setState(() {});

                                              Navigator.pop(context);
                                            } else {
                                              String income =
                                                  categorycontroller.text;
                                              Model expcat = Model(
                                                  cat: income, field: false);
                                              catbox.add(expcat);
                                              categorycontroller.clear();
                                              setState(() {});
                                              Navigator.pop(context);
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: obj.Primarywhite,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    obj.yellow)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          categorycontroller.clear();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: obj.Primarywhite,
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
            ),
            income == true && keys.isNotEmpty
                ? Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4.80,
                      child: ValueListenableBuilder(
                          valueListenable: catbox.listenable(),
                          builder: (context, Box<Model> catShow, cntxt) {
                            List<int> keys = catbox.keys
                                .cast<int>()
                                .where((Key) => income == true
                                    ? catbox.get(Key)!.field == true
                                    : catbox.get(Key)!.field == false)
                                .toList();

                            return GridView.builder(
                              padding: const EdgeInsets.only(
                                  left: 70.0, right: 70, top: 30, bottom: 30),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 14.0,
                                      mainAxisSpacing: 10.0),
                              itemBuilder: (context, index) {
                                final int key = keys[index];
                                final Model? catinc = catbox.get(key);
                                return GestureDetector(
                                  onDoubleTap: () {
                                    setState(() {
                                      _selectedIndex = null;
                                      catogorie = "";
                                    });
                                  },
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext) {
                                          return AlertDialog(
                                            backgroundColor: obj.secondary,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  " Delete this category",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Colors.redAccent,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(obj
                                                                        .yellow)),
                                                        onPressed: () {
                                                          catbox.delete(key);
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              color: obj
                                                                  .Primarywhite,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                    TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(obj
                                                                        .yellow)),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              color: obj
                                                                  .Primarywhite,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                      print(_selectedIndex);
                                      print("first$catogorie");
                                      catogorie = catinc!.cat;
                                      print("1");
                                      print("second$catogorie");
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == index
                                            ? obj.yellow
                                            : HexColor("#F3F1EC"),
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Center(
                                      child: Text(
                                        catinc!.cat.toUpperCase(),
                                        style: TextStyle(
                                            color: _selectedIndex == index
                                                ? obj.Primarywhite
                                                : obj.black,
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
                            );
                          }),
                    ),
                  )
                : expense == true && keys1.isNotEmpty
                    ?

                    //exp..................

                    Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 4.80,
                          child: ValueListenableBuilder(
                              valueListenable: catbox.listenable(),
                              builder: (context, Box<Model> catShow, cntxt) {
                                List<int> keys = catbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        catbox.get(Key)!.field == false)
                                    .toList();

                                return GridView.builder(
                                  padding: const EdgeInsets.only(
                                      left: 70.0,
                                      right: 70,
                                      top: 30,
                                      bottom: 30),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 14.0,
                                          mainAxisSpacing: 10.0),
                                  itemBuilder: (context, index) {
                                    final int key = keys[index];
                                    final Model? catexp = catbox.get(key);
                                    return GestureDetector(
                                      onDoubleTap: () {
                                        setState(() {
                                          selectedIndex = null;
                                          expcatogorie = "";
                                        });
                                      },
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext) {
                                              return AlertDialog(
                                                backgroundColor: obj.secondary,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      " Delete this category",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          color:
                                                              Colors.redAccent,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 40,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        TextButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(obj
                                                                            .yellow)),
                                                            onPressed: () {
                                                              catbox
                                                                  .delete(key);
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  color: obj
                                                                      .Primarywhite,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                        TextButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(obj
                                                                            .yellow)),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  color: obj
                                                                      .Primarywhite,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;

                                          expcatogorie = catexp!.cat;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: selectedIndex == index
                                                ? obj.yellow
                                                : obj.secondary,
                                            borderRadius:
                                                BorderRadius.circular(9)),
                                        child: Center(
                                          child: Text(
                                            catexp!.cat.toUpperCase(),
                                            style: TextStyle(
                                                color: selectedIndex == index
                                                    ? obj.Primarywhite
                                                    : obj.black,
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
                                );
                              }),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Add Some Categories",
                          style: TextStyle(
                            color: Colors.red,
                            // color: HexColor('#678983'),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

            Divider(
              color: obj.Primarywhite,
            ),

            keys.isNotEmpty && income == true
                ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                          color: obj.secondary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: ValueListenableBuilder(
                          valueListenable: transbox.listenable(),
                          builder: (context,
                              Box<Transactionmodel> transactionshow, cntxt) {
                            List<int> all = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.categorie == catogorie)
                                .toList();

                            if (_selectedIndex == null) {
                              return Center(
                                child: Text(
                                  "Select a category",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: obj.black,
                                  ),
                                ),
                              );
                            }
                            if (all.isEmpty) {
                              return Center(
                                child: Text(
                                  "No Transactions yet",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: obj.black,
                                  ),
                                ),
                              );
                            } else {
                              return listView(id: all);
                            }
                          }),
                    ),
                  )
                : expense == true && keys1.isNotEmpty
                    ? Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.56,
                          decoration: BoxDecoration(
                              color: obj.secondary,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: ValueListenableBuilder(
                              valueListenable: transbox.listenable(),
                              builder: (context,
                                  Box<Transactionmodel> transactionshow,
                                  cntxt) {
                                List<int> all1 = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.categorie ==
                                        expcatogorie)
                                    .toList();

                                if (selectedIndex == null) {
                                  return Center(
                                    child: Text(
                                      "Select a category",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: obj.black,
                                      ),
                                    ),
                                  );
                                }
                                if (all1.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "No Transactions yet",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: obj.black,
                                      ),
                                    ),
                                  );
                                } else {
                                  return listView(id: all1);
                                }
                              }),
                        ),
                      )
                    : SizedBox(),
          ],
        ),
      ),
    );
  }
}
