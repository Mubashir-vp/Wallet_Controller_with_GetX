import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet_controller/Hive/transactionModel.dart';
import 'package:wallet_controller/widget/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transbox = Hive.box<Transactionmodel>("transaction");
    initFunction();
    setState(() {});
  }

  initFunction() {
    transbox = Hive.box<Transactionmodel>("transaction");
    final _yesterday =
        DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);

    if (transbox!.isEmpty) {
      return;
    } else {
      Sumofincome();
      SumofExpense();

      balanceAmount();
    }
  }

  Box<Transactionmodel>? transbox;

  //.........DropDown Variables........
  final _list = ['All', 'Today', 'Yesterday', 'Custom', 'Monthly'];
  bool All = true;
  bool Today = false;
  bool Yesterday = false;
  bool Custom = false;
  bool Monthly = false;

/*.........Date Pickers........*/
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

  /*.........List Tile........*/

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

        final Transactionmodel? transs = transbox!.get(key);

        final _date = transs!.time;

        formattedDate = DateFormat('dd').format(_date);
        formattedDate1 = DateFormat('EEE').format(_date);

        return Padding(
          padding:
              const EdgeInsets.only(left: 6.0, right: 6, bottom: 0, top: 0),
          child: GestureDetector(
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
                            " Delete this Transaction",
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              obj.yellow)),
                                  onPressed: () {
                                    transbox!.delete(key);
                                    transbox!.delete(key).then((value) {
                                      initFunction();
                                      setState(() {});
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        initFunction();
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Yes",
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
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "No",
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
                ],
              ),
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

  /*.........Calculations........*/

  double sumInc = 0;
  num balance = 0.0;
  Sumofincome() {
    List<int> key1 = transbox!.keys
        .cast<int>()
        .where((Key) => transbox!.get(Key)!.isIncome == true)
        .toList();
    List<int> kee = key1.reversed.toList();
    sumInc = 0;
    for (int i = 0; i < kee.length; i++) {
      final Transactionmodel? eki = transbox!.get(kee[i]);
      sumInc = sumInc + eki!.amount;
    }
  }

  double sumExpense = 0;

  SumofExpense() {
    List<int> key1 = transbox!.keys
        .cast<int>()
        .where((Key) => transbox!.get(Key)!.isIncome == false)
        .toList();
    List<int> kee = key1.reversed.toList();
    sumExpense = 0;

    for (int i = 0; i <= kee.length - 1; i++) {
      final Transactionmodel? eki = transbox!.get(kee[i]);

      sumExpense = sumExpense + eki!.amount;
    }
  }

  balanceAmount() {
    balance = sumInc - sumExpense;
  }

  @override
  Widget build(BuildContext context) {
    List<int> allBalance = transbox!.keys.cast<int>().toList();

    int currentIndex = 0;
    return SafeArea(
        child: Scaffold(
      backgroundColor: obj.Primarywhite,
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
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
                        txt1: 'Welcome', txt2: "Manage your Finance Easily")),
                SizedBox()
              ],
            ),

            //TotalTransactionCard****

            Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 1.2,
              margin: const EdgeInsets.only(
                left: 20,
                top: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                  color: obj.secondary,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(
                          color: HexColor("#736E62"),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.rupeeSign,
                          color: HexColor("#736E62"),
                          size: 32,
                        ),
                        Text(
                          allBalance.isNotEmpty ? " $balance" : "0.0",
                          style: TextStyle(
                              color: HexColor("#736E62"),
                              fontSize: 40,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //iNcome&expenses****8

            Padding(
              padding: const EdgeInsets.only(
                left: 34,
                top: 13,
                right: 34,
              ),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor("#EDFDF4"),
                          borderRadius: BorderRadius.circular(15)),
                      height: 85,
                      width: MediaQuery.of(context).size.width / 2.56,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 14, left: 46, right: 46),
                            child: Text(
                              "Income",
                              style: TextStyle(
                                  color: HexColor("#52AA54"),
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.rupeeSign,
                                color: HexColor("#52AA54"),
                                size: 15,
                              ),
                              Text(
                                allBalance.isNotEmpty ? " $sumInc" : "0.0",
                                style: TextStyle(
                                    color: HexColor("#52AA54"),
                                    fontFamily: "Poppins",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor("#FDEEEC"),
                          borderRadius: BorderRadius.circular(15)),
                      height: 85,
                      width: MediaQuery.of(context).size.width / 2.56,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 14, left: 46, right: 46),
                            child: Text(
                              "Expense",
                              style: TextStyle(
                                  color: HexColor("#FE5355"),
                                  fontFamily: "Poppins",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.rupeeSign,
                                color: HexColor("#FE5355"),
                                size: 15,
                              ),
                              Text(
                                allBalance.isNotEmpty ? " $sumExpense" : "0.0",
                                style: TextStyle(
                                    color: HexColor("#FE5355"),
                                    fontFamily: "Poppins",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),

            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 2.56,
                decoration: BoxDecoration(
                    color: obj.secondary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  children: [
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
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: obj.black)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 3),
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
                            padding: const EdgeInsets.only(
                                top: 23, left: 1, right: 3),
                            child: Monthly == false && Custom == false
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                  )
                                : Monthly == true
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: GestureDetector(
                                                onTap: () =>
                                                    _datepicker(context),
                                                child: Text(formattedMonth,
                                                    style: TextStyle(
                                                      color: obj.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 14.0),
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
                                            padding: const EdgeInsets.only(
                                                left: 14.0),
                                            child: TextButton(
                                              onPressed: () {
                                                dateRangePicker();
                                              },
                                              child: toFrom(),
                                            ),
                                          ),
                                        ],
                                      ))
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / .8,
                        child: ValueListenableBuilder(
                            valueListenable: transbox!.listenable(),
                            builder: (context,
                                Box<Transactionmodel> transactionshow, cntxt) {
                              List<int> today = transbox!.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox!.get(Key)!.time == _date)
                                  .toList();
                              List<int> all =
                                  transbox!.keys.cast<int>().toList();
                              List<int> custom = transbox!.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox!.get(Key)!.time == _date)
                                  .toList();
                              List<int> yesterday = transbox!.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox!.get(Key)!.time == _yesterday)
                                  .toList();
                              List<int> monthly = transbox!.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox!.get(Key)!.time.month ==
                                      month.month)
                                  .toList();
                              List<int> start = transbox!.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox!.get(Key)!.time == startDate)
                                  .toList();

                              List<int> end = transbox!.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox!.get(Key)!.time == endDate)
                                  .toList();
                              int difference =
                                  endDate.difference(startDate).inDays;

                              List<int> rangeKey = [];
                              for (int i = 0; i <= difference; i++) {
                                rangeKey.addAll(transbox!.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox!.get(Key)!.time ==
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
                              if (All == true && all.isNotEmpty) {
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
                                    List<int> keyy = rangeKey.reversed.toList();
                                    final key = keyy[index];
                                    int difference =
                                        endDate.difference(startDate).inDays;
                                    for (int i = 0; i <= difference; i++) {
                                      rangeKey.addAll(transbox!.keys
                                          .cast<int>()
                                          .where((Key) =>
                                              transbox!.get(Key)!.time ==
                                              startDate.add(Duration(days: i)))
                                          .toList());
                                    }

                                    final Transactionmodel? transs =
                                        transbox!.get(key);

                                    final _date = transs!.time;

                                    formattedDate =
                                        DateFormat('dd').format(_date);
                                    formattedDate1 =
                                        DateFormat('EEE').format(_date);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0,
                                          right: 6,
                                          bottom: 0,
                                          top: 0),
                                      child: GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      obj.secondary,
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        " Delete this Transaction",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                                transbox!
                                                                    .delete(
                                                                        key);
                                                                transbox!
                                                                    .delete(key)
                                                                    .then(
                                                                        (value) {
                                                                  initFunction();
                                                                  setState(
                                                                      () {});
                                                                  Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                      () {
                                                                    initFunction();
                                                                  });
                                                                });
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
                                                                      MaterialStateProperty.all(obj
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.warning),
                                      SizedBox(),
                                      Text(
                                        "No Transactions",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: obj.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
