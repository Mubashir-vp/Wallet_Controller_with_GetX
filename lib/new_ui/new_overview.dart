import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wallet_controller/widget/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wallet_controller/Hive/transactionModel.dart';
import 'package:wallet_controller/Hive/model.dart';

class NewOverview extends StatefulWidget {
  const NewOverview({Key? key}) : super(key: key);

  @override
  _NewOverviewState createState() => _NewOverviewState();
}

class _NewOverviewState extends State<NewOverview> {
  //Pie Keys...............
  Map<String, double> val() {
    return {
      "txt1": 00,
      "txt2": 01,
      "txt3": 01,
    };
  }

  late Box<Model> catbox;
  static Box<Transactionmodel> transbox =
      Hive.box<Transactionmodel>("transaction");
  List<int> piechartIncome = transbox.keys
      .cast<int>()
      .where((Key) => transbox.get(Key)!.isIncome == true)
      .toList();
  List<int> piechartExpense = transbox.keys
      .cast<int>()
      .where((Key) => transbox.get(Key)!.isIncome == false)
      .toList();
  List<int> piechartAll = transbox.keys
      .cast<int>()
      .where((Key) => transbox.get(Key)!.isIncome == true)
      .toList();

  Map<String, double> catgorieFetchingExpCustom() {
    Map<String, double> allMap = {};
    int expdifference = endDate.difference(startDate).inDays;

    List catogoriesFromCatboxKey = [];
    List catogoriesFromCatboxKeyy = [];

    List catogoriesFromCatbox = [];
    List sumOfCatogoriesFromTransactionBox = [];
    double sum = 0;
    for (int i = 0; i <= expdifference; i++) {
      rangeKey.addAll(transbox.keys
          .cast<int>()
          .where((Key) =>
              transbox.get(Key)!.time == startDate.add(Duration(days: i)) &&
              transbox.get(Key)!.isIncome == false)
          .toList());
    }

    catogoriesFromCatboxKey = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.isIncome == false)
        .toList();
    final Transactionmodel? incCat = transbox.get(catogoriesFromCatboxKey);

    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      final Transactionmodel? incCat = transbox.get(catogoriesFromCatboxKey[i]);
      catogoriesFromCatbox.add(incCat!.categorie);
    }
    for (int i = 0; i <= expdifference; i++) {
      sumOfCatogoriesFromTransactionBox.addAll(transbox.keys
          .cast<int>()
          .where((Key) =>
              transbox.get(Key)!.time == startDate.add(Duration(days: i)) &&
              transbox.get(Key)!.isIncome == false)
          .toList());
    }

    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      sum = 0;

      for (int j = 0; j < sumOfCatogoriesFromTransactionBox.length; j++) {
        final Transactionmodel? sumcatogories =
            transbox.get(sumOfCatogoriesFromTransactionBox[j]);
        if (sumcatogories!.categorie == catogoriesFromCatbox[i]) {
          sum = sum + sumcatogories.amount;
        }
      }
      allMap[catogoriesFromCatbox[i]] = sum;
    }
    return allMap;
  }

  Map<String, double> catgorieFetchingExp(
      {required List sumOfCatogoriesFromTransBox, required bool isIncome}) {
    List catogoriesFromCatboxKeyy = [];
    List catogoriesFromCatboxKey = [];
    List catogoriesFromCatbox = [];
    List sumOfCatogoriesFromTransactionBox = [];
    double sum = 0;
    Map<String, double> allMap = {};

    catogoriesFromCatboxKeyy = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.isIncome == isIncome)
        .toList();
    catogoriesFromCatboxKey = catogoriesFromCatboxKeyy.toSet().toList();

    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      final Transactionmodel? incCat = transbox.get(catogoriesFromCatboxKey[i]);
      catogoriesFromCatbox.add(incCat!.categorie);
    }
    sumOfCatogoriesFromTransactionBox = sumOfCatogoriesFromTransBox;
    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      sum = 0;

      for (int j = 0; j < sumOfCatogoriesFromTransactionBox.length; j++) {
        final Transactionmodel? sumcatogories =
            transbox.get(sumOfCatogoriesFromTransactionBox[j]);
        if (sumcatogories!.categorie == catogoriesFromCatbox[i]) {
          sum = sum + sumcatogories.amount;
        }
      }
      allMap[catogoriesFromCatbox[i]] = sum;
    }
    return allMap;
  }

  Map<String, double> catgorieFetchingInc(
      {required List sumOfCatogoriesFromTransBox, required bool isIncome}) {
    List catogoriesFromCatboxKey = [];
    List catogoriesFromCatboxKeyy = [];

    List catogoriesFromCatbox = [];
    List sumOfCatogoriesFromTransactionBox = [];
    double sum = 0;
    Map<String, double> allMap = {};

    catogoriesFromCatboxKeyy = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.isIncome == isIncome)
        .toList();
    catogoriesFromCatboxKey = catogoriesFromCatboxKeyy.toSet().toList();

    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      final Transactionmodel? incCat = transbox.get(catogoriesFromCatboxKey[i]);
      catogoriesFromCatbox.add(incCat!.categorie);
    }
    sumOfCatogoriesFromTransactionBox = sumOfCatogoriesFromTransBox;
    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      sum = 0;

      for (int j = 0; j < sumOfCatogoriesFromTransactionBox.length; j++) {
        final Transactionmodel? sumcatogories =
            transbox.get(sumOfCatogoriesFromTransactionBox[j]);
        if (sumcatogories!.categorie == catogoriesFromCatbox[i]) {
          sum = sum + sumcatogories.amount;
        }
      }
      allMap[catogoriesFromCatbox[i]] = sum;
    }
    return allMap;
  }

  List<int> rangeKey = [];

  Map<String, double> catgorieFetchingIncCustom() {
    List catogoriesFromCatboxKey = [];
    List catogoriesFromCatboxKeyy = [];

    List catogoriesFromCatbox = [];
    List sumOfCatogoriesFromTransactionBox = [];
    double sum = 0;
    Map<String, double> allMap = {};
    int expdifference = endDate.difference(startDate).inDays;

    for (int i = 0; i <= expdifference; i++) {
      rangeKey.addAll(transbox.keys
          .cast<int>()
          .where((Key) =>
              transbox.get(Key)!.time == startDate.add(Duration(days: i)) &&
              transbox.get(Key)!.isIncome == true)
          .toList());
    }

    catogoriesFromCatboxKey = transbox.keys
        .cast<int>()
        .where((Key) => transbox.get(Key)!.isIncome == true)
        .toList();
    catogoriesFromCatboxKeyy = catogoriesFromCatboxKey.toSet().toList();

    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      final Transactionmodel? incCat = transbox.get(catogoriesFromCatboxKey[i]);
      catogoriesFromCatbox.add(incCat!.categorie);
    }
    for (int i = 0; i <= expdifference; i++) {
      sumOfCatogoriesFromTransactionBox.addAll(transbox.keys
          .cast<int>()
          .where((Key) =>
              transbox.get(Key)!.time == startDate.add(Duration(days: i)) &&
              transbox.get(Key)!.isIncome == true)
          .toList());
    }

    for (int i = 0; i < catogoriesFromCatboxKey.length; i++) {
      sum = 0;

      for (int j = 0; j < sumOfCatogoriesFromTransactionBox.length; j++) {
        final Transactionmodel? sumcatogories =
            transbox.get(sumOfCatogoriesFromTransactionBox[j]);
        if (sumcatogories!.categorie == catogoriesFromCatbox[i]) {
          sum = sum + sumcatogories.amount;
        }
      }
      allMap[catogoriesFromCatbox[i]] = sum;
    }
    return allMap;
  }

  //button variables...............
  bool income = true;
  bool expense = false;
  //.........DropDown Variables........
  final _list = ['All', 'Today', 'Yesterday', 'Custom', 'Monthly'];
  bool All = true;
  bool Today = false;
  bool Yesterday = false;
  bool Custom = false;
  bool Monthly = false;

/*.........Date Pickers........*/
  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  String formattedDate = DateFormat('MMM-dd').format(_date);
  String formattedDateyester = DateFormat('MMM-dd').format(_yesterday);

  String formattedMonth = DateFormat('MMMM').format(month);
  static DateTime month = DateTime.now();
  Future _datepicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final newDate = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: initialDate,
      initialDate: month,
    );
    if (newDate == null) return month = initialDate;
    setState(() {
      month = newDate;
      formattedMonth = DateFormat('MMMM').format(month);

      // formattedMonth = month.toString();
      print(month);
    });
  }

  /*.........Date Range Pickers........*/
  static DateTimeRange? range;
  static DateTime startDate = DateTime.now().add(const Duration(days: -5));
  static DateTime endDate = DateTime.now();
  String formattedStartDate = DateFormat('MMM-dd').format(startDate);
  String formattedEndDate = DateFormat('MMM-dd').format(endDate);

  Future dateRangePicker() async {
    final _initialDateRange = DateTimeRange(
        start: DateTime.now().add(const Duration(days: -2)),
        end: DateTime.now());
    final newdateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime.now(),
        initialDateRange: range ?? _initialDateRange);
    if (newdateRange == null) return;
    setState(() {
      range = newdateRange;
      startDate = range!.start;
      endDate = range!.end;
    });
  }

  Widget getFrom() {
    if (range == null) {
      return Text("From",
          style: TextStyle(
            color: obj.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
          DateFormat('MMM-dd').format(
            range!.start,
          ),
          style: TextStyle(
            color: obj.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    }
  }

  Widget toFrom() {
    if (range == null) {
      return Text("Untill",
          style: TextStyle(
            color: obj.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
        DateFormat('MMM-dd').format(range!.end),
        style: TextStyle(
          color: obj.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
  //ListView.................

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
                        color: obj.Primarywhite,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 20,
                            color: obj.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          formattedDate1,
                          style: TextStyle(
                            fontSize: 10,
                            color: obj.black,
                            fontFamily: 'Poppins',
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
                // IconButton(
                //   icon: const Icon(Icons.delete),
                //   onPressed: () {
                //     transbox!.delete(key).then((value) {
                //       // initFunction();
                //       setState(() {});
                //       Future.delayed(const Duration(seconds: 1), () {
                //         // initFunction();
                //       });
                //     });
                //   },
                // )
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transbox = Hive.box<Transactionmodel>("transaction");
    catbox = Hive.box<Model>("catogeries");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: obj.Primarywhite,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 302,
                margin: const EdgeInsets.only(
                  top: 30,
                  left: 16,
                ),
                child: new_text(
                    txt1: 'Overview', txt2: "Your transaction statitics")),
            const SizedBox(),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, top: 18),
                    child: Container(
                      width: 180,
                      height: 50,
                      margin: const EdgeInsets.only(left: 12, top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //  border: Border.all(color: obj.black)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 3),
                        child: DropdownButtonFormField(
                          dropdownColor: obj.Primarywhite,
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: Colors.black,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: obj.black,
                          ),
                          elevation: 30,
                          iconSize: 32,
                          focusColor: Colors.blue,
                          autofocus: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            // print(value);
                          },
                          hint: Text(
                            _list[0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: obj.black,
                            ),
                          ),
                          items: _list.map((e) {
                            return DropdownMenuItem(
                              onTap: () {
                                if (e == _list[0]) {
                                  setState(() {
                                    All = true;
                                    Monthly = false;
                                    Custom = false;
                                  });
                                } else if (e == _list[1]) {
                                  setState(() {
                                    Today = true;
                                    All = false;
                                    Yesterday = false;
                                    Monthly = false;
                                    Custom = false;
                                  });
                                }
                                if (e == _list[2]) {
                                  setState(() {
                                    Yesterday = true;
                                    All = false;
                                    Today = false;
                                    Monthly = false;
                                    Custom = false;
                                  });
                                }
                                if (e == _list[4]) {
                                  setState(() {
                                    Monthly = true;
                                    Custom = false;
                                    All = false;
                                    Today = false;
                                    Yesterday = false;
                                  });
                                } else if (e == _list[3]) {
                                  setState(() {
                                    Custom = true;
                                    Monthly = false;
                                    All = false;
                                    Today = false;
                                    Yesterday = false;
                                  });
                                }
                              },
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Monthly == false && Custom == false
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                          )
                        : Monthly == true
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: GestureDetector(
                                        onTap: () => _datepicker(context),
                                        child: Text(formattedMonth,
                                            style: TextStyle(
                                              color: obj.black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ))),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14.0),
                                    child: TextButton(
                                      onPressed: () {
                                        dateRangePicker();
                                      },
                                      child: getFrom(),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_right_alt_rounded,
                                      size: 40,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14.0),
                                    child: TextButton(
                                      onPressed: () {
                                        dateRangePicker();
                                      },
                                      child: toFrom(),
                                    ),
                                  ),
                                ],
                              )),
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
            Container(
              decoration: BoxDecoration(
                  color: obj.secondary,
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.only(top: 25),
              width: 318,
              height: 190,
              child: income == true
                  ? piechartIncome.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 13,
                              child: piechart(
                                  val: All == true
                                      ? catgorieFetchingInc(
                                          sumOfCatogoriesFromTransBox: transbox.keys
                                              .cast<int>()
                                              .where((Key) =>
                                                  transbox.get(Key)!.isIncome ==
                                                  true)
                                              .toList(),
                                          isIncome: true)
                                      : Today == true
                                          ? catgorieFetchingInc(
                                              sumOfCatogoriesFromTransBox: transbox
                                                  .keys
                                                  .cast<int>()
                                                  .where((Key) =>
                                                      transbox.get(Key)!.isIncome == true &&
                                                      transbox.get(Key)!.time ==
                                                          _date)
                                                  .toList(),
                                              isIncome: true)
                                          : Yesterday == true
                                              ? catgorieFetchingInc(
                                                  sumOfCatogoriesFromTransBox:
                                                      transbox.keys
                                                          .cast<int>()
                                                          .where((Key) =>
                                                              transbox
                                                                      .get(Key)!
                                                                      .isIncome ==
                                                                  true &&
                                                              transbox
                                                                      .get(Key)!
                                                                      .time ==
                                                                  _yesterday)
                                                          .toList(),
                                                  isIncome: true)
                                              : Monthly == true
                                                  ? catgorieFetchingInc(
                                                      sumOfCatogoriesFromTransBox:
                                                          transbox.keys
                                                              .cast<int>()
                                                              .where((Key) => transbox.get(Key)!.time.month == month.month && transbox.get(Key)!.isIncome == true)
                                                              .toList(),
                                                      isIncome: true)
                                                  : Custom == true
                                                      ? catgorieFetchingIncCustom()
                                                      : val(),
                                  color: Colors.green),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            )
                          ],
                        )
                      : Center(
                          child: Text(
                            "No Transactions Yet  ",
                            style: TextStyle(
                              fontSize: 18,
                              color: obj.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                  : piechartExpense.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Expanded(child: SizedBox()),
                            Expanded(
                              flex: 13,
                              child: piechart(
                                  val: All == true
                                      ? catgorieFetchingExp(
                                          sumOfCatogoriesFromTransBox: transbox.keys
                                              .cast<int>()
                                              .where((Key) =>
                                                  transbox.get(Key)!.isIncome ==
                                                  false)
                                              .toList(),
                                          isIncome: false)
                                      : Today == true
                                          ? catgorieFetchingExp(
                                              sumOfCatogoriesFromTransBox: transbox
                                                  .keys
                                                  .cast<int>()
                                                  .where((Key) =>
                                                      transbox.get(Key)!.isIncome ==
                                                          false &&
                                                      transbox.get(Key)!.time ==
                                                          _date)
                                                  .toList(),
                                              isIncome: false)
                                          : Yesterday == true
                                              ? catgorieFetchingExp(
                                                  sumOfCatogoriesFromTransBox:
                                                      transbox.keys
                                                          .cast<int>()
                                                          .where((Key) =>
                                                              transbox
                                                                      .get(Key)!
                                                                      .isIncome ==
                                                                  false &&
                                                              transbox.get(Key)!.time ==
                                                                  _yesterday)
                                                          .toList(),
                                                  isIncome: false)
                                              : Monthly == true
                                                  ? catgorieFetchingExp(
                                                      sumOfCatogoriesFromTransBox:
                                                          transbox.keys
                                                              .cast<int>()
                                                              .where((Key) => transbox.get(Key)!.time.month == month.month && transbox.get(Key)!.isIncome == false)
                                                              .toList(),
                                                      isIncome: false)
                                                  : Custom == true
                                                      ? catgorieFetchingExpCustom()
                                                      : val(),
                                  color: Colors.red),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        )
                      : Center(
                          child: Text(
                            "No Transactions Yet  ",
                            style: TextStyle(
                              fontSize: 18,
                              color: obj.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
            ),
            const SizedBox(
              height: 60,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 4.30,
                decoration: BoxDecoration(
                    color: obj.secondary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: MediaQuery.of(context).size.height / .8,
                      child: income == true
                          ? ValueListenableBuilder(
                              valueListenable: transbox.listenable(),
                              builder: (context,
                                  Box<Transactionmodel> transactionshow,
                                  cntxt) {
                                List<int> today = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time == _date &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();
                                List<int> all = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();
                                List<int> custom = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time == _date &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();
                                List<int> yesterday = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time == _yesterday &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();
                                List<int> monthly = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time.month ==
                                            month.month &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();
                                List<int> start = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time == startDate &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();

                                List<int> end = transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time == endDate &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList();
                                int difference =
                                    endDate.difference(startDate).inDays;

                                List<int> rangeKey = [];
                                for (int i = 0; i <= difference; i++) {
                                  rangeKey.addAll(transbox.keys
                                      .cast<int>()
                                      .where((Key) =>
                                          transbox.get(Key)!.time ==
                                          startDate.add(Duration(days: i)))
                                      .toList());
                                }

                                if (today.isEmpty &&
                                    all.isEmpty &&
                                    custom.isEmpty &&
                                    yesterday.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "No Transactions",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: obj.black,
                                      ),
                                    ),
                                  );
                                }
                                if (All == true) {
                                  return listView(id: all);
                                }
                                if (Today == true && today.isNotEmpty) {
                                  return listView(id: today);
                                }
                                if (Yesterday == true && yesterday.isNotEmpty) {
                                  return listView(id: yesterday);
                                }
                                if (Custom == true && rangeKey.isNotEmpty) {
                                  return ListView.separated(
                                    itemBuilder: (context, index) {
                                      List<int> keyy =
                                          rangeKey.reversed.toList();
                                      final key = keyy[index];
                                      int difference =
                                          endDate.difference(startDate).inDays;
                                      for (int i = 0; i <= difference; i++) {
                                        rangeKey.addAll(transbox.keys
                                            .cast<int>()
                                            .where((Key) =>
                                                transbox.get(Key)!.time ==
                                                startDate
                                                    .add(Duration(days: i)))
                                            .toList());
                                      }

                                      final Transactionmodel? transs =
                                          transbox.get(key);

                                      final _date = transs!.time;

                                      formattedDate =
                                          DateFormat('dd').format(_date);
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0,
                                            right: 6,
                                            bottom: 0,
                                            top: 0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16,
                                                    top: 28,
                                                    bottom: 0),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: obj.Primarywhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        formattedDate,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: obj.black,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        formattedDate1,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: obj.black,
                                                          fontFamily: 'Poppins',
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
                                                  margin: const EdgeInsets.only(
                                                      left: 1, right: 1),
                                                  // color: Colors.red,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          transs.categorie
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: obj.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          transs.notes ?? "",
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  '#8A8A8A'),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0,
                                                            top: 16,
                                                            bottom: 0),
                                                    child:
                                                        transs.isIncome == true
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  FaIcon(
                                                                    FontAwesomeIcons
                                                                        .rupeeSign,
                                                                    color: HexColor(
                                                                        "#52AA54"),
                                                                    size: 11,
                                                                  ),
                                                                  Text(
                                                                    " ${transs.amount}",
                                                                    style: TextStyle(
                                                                        color: HexColor(
                                                                            "#52AA54"),
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  FaIcon(
                                                                    FontAwesomeIcons
                                                                        .rupeeSign,
                                                                    color: HexColor(
                                                                        "#FE5355"),
                                                                    size: 13,
                                                                  ),
                                                                  Text(
                                                                    " ${transs.amount}",
                                                                    style: TextStyle(
                                                                        color: HexColor(
                                                                            "#FE5355"),
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )
                                                                ],
                                                              )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (cont, index) =>
                                        const SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: rangeKey.length,
                                    shrinkWrap: true,
                                  );
                                }
                                if (Monthly == true && monthly.isNotEmpty) {
                                  return listView(id: monthly);
                                } else {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.warning),
                                        SizedBox(),
                                        Text(
                                          "No Transactions",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: HexColor('#817575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              })
                          : expense == true && piechartExpense.isNotEmpty
                              ? ValueListenableBuilder(
                                  valueListenable: transbox.listenable(),
                                  builder: (context,
                                      Box<Transactionmodel> transactionshow,
                                      cntxt) {
                                    List<int> todayExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time == _date &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList();
                                    List<int> allExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.isIncome ==
                                            false)
                                        .toList();
                                    List<int> customExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time == _date &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList();
                                    List<int> yesterdayExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time ==
                                                _yesterday &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList();
                                    List<int> monthlyExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time.month ==
                                                month.month &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList();
                                    List<int> startExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time ==
                                                startDate &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList();

                                    List<int> endExp = transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time ==
                                                endDate &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList();
                                    int difference =
                                        endDate.difference(startDate).inDays;

                                    List<int> rangeKeyExp = [];
                                    for (int i = 0; i <= difference; i++) {
                                      rangeKey.addAll(transbox.keys
                                          .cast<int>()
                                          .where((Key) =>
                                              transbox.get(Key)!.time ==
                                              startDate.add(Duration(days: i)))
                                          .toList());
                                    }

                                    if (allExp.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No Transactions",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: HexColor("#CFF1EF")
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      );
                                    }
                                    if (All == true) {
                                      return listView(id: allExp);
                                    }
                                    if (Today == true && todayExp.isNotEmpty) {
                                      return listView(id: todayExp);
                                    }
                                    if (Yesterday == true &&
                                        yesterdayExp.isNotEmpty) {
                                      return listView(id: yesterday);
                                    }
                                    if (Custom == true && rangeKey.isNotEmpty) {
                                      return ListView.separated(
                                        itemBuilder: (context, index) {
                                          List<int> keyy =
                                              rangeKey.reversed.toList();
                                          final key = keyy[index];
                                          int difference = endDate
                                              .difference(startDate)
                                              .inDays;
                                          for (int i = 0;
                                              i <= difference;
                                              i++) {
                                            rangeKey.addAll(transbox.keys
                                                .cast<int>()
                                                .where((Key) =>
                                                    transbox.get(Key)!.time ==
                                                    startDate
                                                        .add(Duration(days: i)))
                                                .toList());
                                          }

                                          final Transactionmodel? transs =
                                              transbox.get(key);

                                          final _date = transs!.time;

                                          formattedDate = DateFormat('MMM-dd')
                                              .format(_date);
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              height: 60,
                                              color: HexColor('#FFFFFF'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Expanded(
                                                      child: Text(
                                                        formattedDate,
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              '#817575'),
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      transs.categorie,
                                                      style: TextStyle(
                                                        color:
                                                            HexColor('#817575'),
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Expanded(
                                                      child: Text(
                                                        transs.amount
                                                            .toString(),
                                                        style: TextStyle(
                                                          color:
                                                              transs.isIncome ==
                                                                      true
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (cont, index) =>
                                            const SizedBox(
                                          height: 10,
                                        ),
                                        itemCount: rangeKey.length,
                                        shrinkWrap: true,
                                      );
                                    }
                                    if (Monthly == true &&
                                        monthlyExp.isNotEmpty) {
                                      return listView(id: monthlyExp);
                                    } else {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.warning),
                                            SizedBox(),
                                            Text(
                                              "No Transactions",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: HexColor('#817575'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  })
                              : Center(
                                  child: Text(
                                    "No Transactions",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: obj.black,
                                    ),
                                  ),
                                ),
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
