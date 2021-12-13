import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet_controller/Hive/model.dart';
import 'package:wallet_controller/Hive/transactionModel.dart';
import 'package:wallet_controller/widget/widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({Key? key}) : super(key: key);

  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  late Box<Model> catbox;
  late Box<Transactionmodel> transactionbox;
  void show(BuildContext conxt, {required String txt}) {
    ScaffoldMessenger.of(conxt).showSnackBar(SnackBar(
        // margin: EdgeInsets.only(left: 100, right: 100, top: 400, bottom: 400),
        behavior: SnackBarBehavior.floating,
        // padding: EdgeInsets.all(60),
        content: Text(txt)));
  }

  TextEditingController incomecatcontroller = TextEditingController();
  TextEditingController expensecatcontroller = TextEditingController();
  TextEditingController incomenotecontroller = TextEditingController();
  TextEditingController expensenotecontroller = TextEditingController();

  TextEditingController incomecontroller = TextEditingController();
  TextEditingController expensecontroller = TextEditingController();
  int? selectedIndex;
  int? _selectedIndex;
  String catogorie = "";
  String expcatogorie = "";

  bool _selection = false;
  bool income = true;
  bool expense = false;
  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  //datepicker.................

  String? formattedDate = DateFormat('MM-dd').format(DateTime.now()).toString();
  String? formattedDate1 =
      DateFormat('MMM-dd').format(DateTime.now()).toString();
  static DateTime dt = DateTime.now();
  DateTime _date = DateTime(dt.year, dt.month, dt.day);
  DateTime date = DateTime(dt.year, dt.month, dt.day);
  Future datepicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
      initialDate: date,
    );
    if (newDate == null) return date = initialDate;
    setState(() {
      // initialDate = date;
      date = newDate;
      formattedDate1 = DateFormat('MMM-dd').format(date);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catbox = Hive.box<Model>("catogeries");
    transactionbox = Hive.box<Transactionmodel>("transaction");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: obj.Primarywhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: 302,
                  margin: const EdgeInsets.only(
                    top: 30,
                    left: 16,
                  ),
                  child: new_text(
                      txt1: 'Add Transaction',
                      txt2: "Add the latest transaction.")),
              const SizedBox(
                height: 27,
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
              const SizedBox(
                height: 50,
              ),
              income == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 25,
                              ),
                              Text("Date",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 58,
                              ),
                              GestureDetector(
                                onTap: () => datepicker(context),
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "$formattedDate1",
                                    style: TextStyle(
                                        color: obj.black,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )),
                                  width: 100,
                                  height: 31,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: HexColor("#D0D0D0")),
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text("Amount",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 14,
                              ),
                              Expanded(
                                child: Form(
                                  key: formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 11),
                                    child: TextFormField(
                                      controller: incomecontroller,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "This Field Is Required";
                                        } else if (RegExp(
                                                r'^[a-z A-Z _\-=@,\.;( ,)[, ], {, }, *, +, ?, ., ^, $, |]+$,-')
                                            .hasMatch(value)) {
                                          return "Enter a correct amount";
                                        } else if (value[0] == "-") {
                                          return "Enter a correct amount";
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
                                          labelText: 'Enter the amount',
                                          prefixText: '\₹',
                                          suffixText: 'INR',
                                          suffixStyle: const TextStyle(
                                              color: Colors.green)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Text("Category",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        color: Colors.white,
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 35.0, right: 35),
                                                child: ValueListenableBuilder(
                                                    valueListenable:
                                                        catbox.listenable(),
                                                    builder: (context,
                                                        Box<Model> catShow,
                                                        cntxt) {
                                                      List<int> keys = catbox
                                                          .keys
                                                          .cast<int>()
                                                          .where((Key) =>
                                                              catbox
                                                                  .get(Key)!
                                                                  .field ==
                                                              true)
                                                          .toList();
                                                      if (keys.isEmpty) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              "Add Some Categories",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                // color: HexColor('#678983'),
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      "inccat");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .add_circle_outline))
                                                          ],
                                                        );
                                                      } else {
                                                        return ListView
                                                            .separated(
                                                          itemBuilder:
                                                              (context, index) {
                                                            final int key =
                                                                keys[index];
                                                            final Model?
                                                                catinc =
                                                                catbox.get(key);
                                                            return ListTile(
                                                              tileColor:
                                                                  _selectedIndex ==
                                                                          index
                                                                      ? Colors
                                                                          .green
                                                                      : null,
                                                              onTap: () {
                                                                setState(() {
                                                                  _selectedIndex =
                                                                      index;
                                                                  catogorie =
                                                                      catinc!
                                                                          .cat;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: Text(
                                                                catinc!.cat
                                                                    .toUpperCase(),
                                                                style:
                                                                    TextStyle(
                                                                  color: _selectedIndex ==
                                                                          index
                                                                      ? obj
                                                                          .yellow
                                                                      : obj
                                                                          .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              // leading: Text("$key"),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (cont, index) =>
                                                                  const Divider(),
                                                          itemCount:
                                                              keys.length,
                                                          shrinkWrap: true,
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, top: 12),
                                    child: Text(
                                        catogorie == ""
                                            ? "Select a category"
                                            : catogorie.toUpperCase(),
                                        style: TextStyle(
                                            color: HexColor("#858585"),
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ),
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: HexColor("#D0D0D0"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Text("Notes",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 23,
                              ),
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 11),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.length >= 20) {
                                          return "Make Your Note Little bit short";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: incomenotecontroller,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Transaction notes',
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            List<int> keys = catbox.keys
                                .cast<int>()
                                .where((Key) => catbox.get(Key)!.field == true)
                                .toList();
                            if (formKey.currentState!.validate() &&
                                _formKey.currentState!.validate()) {
                              if (keys.isEmpty) {
                                show(context, txt: 'Categories is empty');
                              } else if (catogorie == "") {
                                show(context, txt: "Please select a category");
                              } else {
                                double incamount =
                                    double.parse(incomecontroller.text);

                                Transactionmodel income = Transactionmodel(
                                    notes: incomenotecontroller.text,
                                    time: date,
                                    isIncome: true,
                                    categorie: catogorie,
                                    amount: incamount);

                                transactionbox.add(income);
                                setState(() {});

                                incomecontroller.clear();
                                Navigator.pushReplacementNamed(context, "Home")
                                    .then((value) {
                                  setState(() {});
                                  setState(() {});
                                });
                              }
                            }
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: obj.yellow,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 271,
                                  height: 44,
                                  child: Center(
                                    child: Text(
                                      "Add Transaction",
                                      style: TextStyle(
                                          color: obj.Primarywhite,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  )),
                            ),
                          ),
                        )
                      ],
                      //expense........
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 25,
                              ),
                              Text("Date",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 58,
                              ),
                              GestureDetector(
                                onTap: () => datepicker(context),
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "$formattedDate1",
                                    style: TextStyle(
                                        color: obj.black,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )),
                                  width: 100,
                                  height: 31,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: HexColor("#D0D0D0")),
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text("Amount",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 14,
                              ),
                              Expanded(
                                child: Form(
                                  key: formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 11),
                                    child: TextFormField(
                                      controller: incomecontroller,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "This Field Is Required";
                                        } else if (RegExp(
                                                r'^[a-z A-Z _\-=@,\.;( ,)[, ], {, }, *, +, ?, ., ^, $, |]+$,-')
                                            .hasMatch(value)) {
                                          return "Enter a correct amount";
                                        } else if (value.length >= 20) {
                                          return "Enter a correct amount";
                                        } else if (value[0] == "-") {
                                          return "Enter a correct amount";
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
                                          labelText: 'Enter the amount',
                                          prefixText: '\₹',
                                          suffixText: 'INR',
                                          suffixStyle: const TextStyle(
                                              color: Colors.green)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Text("Category",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        color: Colors.white,
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 35.0, right: 35),
                                                child: ValueListenableBuilder(
                                                    valueListenable:
                                                        catbox.listenable(),
                                                    builder: (context,
                                                        Box<Model> catShow,
                                                        cntxt) {
                                                      List<int> keys = catbox
                                                          .keys
                                                          .cast<int>()
                                                          .where((Key) =>
                                                              catbox
                                                                  .get(Key)!
                                                                  .field ==
                                                              false)
                                                          .toList();
                                                      if (keys.isEmpty) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              "Add Some Categories",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                // color: HexColor('#678983'),
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      "inccat");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .add_circle_outline))
                                                          ],
                                                        );
                                                      } else {
                                                        return ListView
                                                            .separated(
                                                          itemBuilder:
                                                              (context, index) {
                                                            final int key =
                                                                keys[index];
                                                            final Model?
                                                                catinc =
                                                                catbox.get(key);
                                                            return ListTile(
                                                              tileColor:
                                                                  _selectedIndex ==
                                                                          index
                                                                      ? Colors
                                                                          .green
                                                                      : null,
                                                              onTap: () {
                                                                setState(() {
                                                                  _selectedIndex =
                                                                      index;
                                                                  expcatogorie =
                                                                      catinc!
                                                                          .cat;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: Text(
                                                                catinc!.cat
                                                                    .toUpperCase(),
                                                                style:
                                                                    TextStyle(
                                                                  color: _selectedIndex ==
                                                                          index
                                                                      ? obj
                                                                          .yellow
                                                                      : obj
                                                                          .black,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                ),
                                                              ),
                                                              // leading: Text("$key"),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (cont, index) =>
                                                                  const Divider(),
                                                          itemCount:
                                                              keys.length,
                                                          shrinkWrap: true,
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 12),
                                    child: Text(
                                        expcatogorie == ""
                                            ? "Select a category"
                                            : expcatogorie.toUpperCase(),
                                        style: TextStyle(
                                            color: HexColor("#858585"),
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ),
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: HexColor("#D0D0D0"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Text("Notes",
                                  style: TextStyle(
                                      color: obj.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                              const SizedBox(
                                width: 23,
                              ),
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 11),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.length >= 20) {
                                          return "Make Your Note Little bit short";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: incomenotecontroller,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Transaction notes',
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            List<int> keys = catbox.keys
                                .cast<int>()
                                .where((Key) => catbox.get(Key)!.field == false)
                                .toList();
                            if (formKey.currentState!.validate() &&
                                _formKey.currentState!.validate()) {
                              if (keys.isEmpty) {
                                show(context, txt: 'Categories is empty');
                              } else if (expcatogorie == "") {
                                show(context, txt: "Please select a category");
                              } else {
                                double incamount =
                                    double.parse(incomecontroller.text);

                                Transactionmodel income = Transactionmodel(
                                    notes: incomenotecontroller.text,
                                    time: date,
                                    isIncome: false,
                                    categorie: expcatogorie,
                                    amount: incamount);

                                transactionbox.add(income);
                                setState(() {});

                                incomecontroller.clear();
                                Navigator.pushReplacementNamed(context, "Home")
                                    .then((value) {
                                  setState(() {});
                                  setState(() {});
                                });
                              }
                            }
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: obj.yellow,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 271,
                                  height: 44,
                                  child: Center(
                                    child: Text(
                                      "Add Transaction",
                                      style: TextStyle(
                                          color: obj.Primarywhite,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
