import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/model/transactionModel.dart';

class HomeScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    transbox = Hive.box<Transactionmodel>("transaction");
    initFunction();
  }

  Box<Transactionmodel>? transbox;
  var constant = Get.find<Constantwidgets>();

  //............................... Variables........
  final _list = ['All', 'Today', 'Yesterday', 'Custom', 'Monthly'];
  bool All = true;
  bool Today = false;
  bool Yesterday = false;
  bool Custom = false;
  bool Monthly = false;
  String formattedMonth = DateFormat('MMMM').format(month);
  static DateTime month = DateTime.now();
  static DateTimeRange? range;
  static DateTime startDate = DateTime.now().add(const Duration(days: -5));
  static DateTime endDate = DateTime.now();
  String formattedStartDate = DateFormat('MMM-dd').format(startDate);
  String formattedEndDate = DateFormat('MMM-dd').format(endDate);
  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  String formattedDate = DateFormat('MMM-dd').format(_date);
  String formattedDate1 = DateFormat('MMM-dd').format(_date);
  int currentIndex = 0;
  // Rx<double> sumOfExpnse  = 0.0.obs;
  Rx<double> sumInc = 0.0.obs;
  Rx<double> balance = 0.0.obs;
  Rx<double> sumOfExpnse = 0.0.obs;

  //...............................Functions........
  // List<int> allBalance() {
  //   List<int> allBalance = transbox!.keys.cast<int>().toList();
  //   return allBalance;
  // }

  Future _datepicker({required var context}) async {
    DateTime initialDate = DateTime.now();
    final newDate = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: initialDate,
      initialDate: month,
    );
    if (newDate == null) return month = initialDate;

    month = newDate;
    formattedMonth = DateFormat('MMMM').format(month);
    print(month);
    update();
  }

  Future dateRangePicker({required var context}) async {
    final _initialDateRange = DateTimeRange(
        start: DateTime.now().add(const Duration(days: -2)),
        end: DateTime.now());
    final newdateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime.now(),
        initialDateRange: range ?? _initialDateRange);
    if (newdateRange == null) return;
    range = newdateRange;
    startDate = range!.start;
    endDate = range!.end;
    update();
  }

  Widget getFrom() {
    if (range == null) {
      return Text("From",
          style: TextStyle(
            color: constant.myColors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
          DateFormat('MMM-dd').format(
            range!.start,
          ),
          style: TextStyle(
            color: constant.myColors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    }
  }

  Widget toFrom() {
    if (range == null) {
      return Text("Untill",
          style: TextStyle(
            color: constant.myColors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
        DateFormat('MMM-dd').format(range!.end),
        style: TextStyle(
          color: constant.myColors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      );
    }
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

  /*.........Calculations........*/

  Sumofincome() {
    List<int> key1 = transbox!.keys
        .cast<int>()
        .where((Key) => transbox!.get(Key)!.isIncome == true)
        .toList();
    List<int> kee = key1.reversed.toList();
    sumInc = 0.0.obs;
    for (int i = 0; i < kee.length; i++) {
      final Transactionmodel? eki = transbox!.get(kee[i]);
      sumInc.value = sumInc.value + eki!.amount;
    }
  }

  SumofExpense() {
    List<int> key1 = transbox!.keys
        .cast<int>()
        .where((Key) => transbox!.get(Key)!.isIncome == false)
        .toList();
    List<int> kee = key1.reversed.toList();
    sumOfExpnse = 0.0.obs;

    for (int i = 0; i <= kee.length - 1; i++) {
      final Transactionmodel? eki = transbox!.get(kee[i]);

      sumOfExpnse.value = sumOfExpnse.value + eki!.amount;
    }
  }

  balanceAmount() {
    balance.value = sumInc.value - sumOfExpnse.value;
  }

  /*.........widgets........*/
  Widget listView({required id, required var context}) {
    return ListView.separated(
      itemBuilder: (context, index) {
        List<int> keyy = id.reversed.toList();
        final key = keyy[index];

        final Transactionmodel? transs = transbox!.get(key);

        final _date = transs!.time;

        formattedDate = DateFormat('dd').format(_date);
        formattedDate1 = DateFormat('EEE').format(_date);

        return Dismissible(
          background: Container(
            color: Colors.red,
            child: Center(child: Icon(Icons.delete)),
          ),
          key: ValueKey<int>(key),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext) {
                    return AlertDialog(
                      backgroundColor: constant.myColors.secondary,
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
                                              constant.myColors.yellow)),
                                  onPressed: () {
                                    transbox!.delete(key).then((value) {
                                      initFunction();
                                      update();
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        initFunction();
                                      });
                                    });
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: constant.myColors.Primarywhite,
                                        fontWeight: FontWeight.w500),
                                  )),
                              TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              constant.myColors.yellow)),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    "No",
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
              return res;
            } else {
              Navigator.pop(context);
            }
          },
          onDismissed: (DismissDirection direction) {},
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
                                    " -${transs.amount}",
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

  Widget totalBalnce({required var context}) {
    List<int> allBalance = transbox!.keys.cast<int>().toList();

    return Expanded(
      flex: 1,
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width / 1.2,
        margin: const EdgeInsets.only(
          left: 20,
          top: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: constant.myColors.secondary,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Total Balance",
                    style: TextStyle(
                        color: HexColor("#736E62"),
                        // fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(
                  color: constant.myColors.secondary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: FaIcon(
                        FontAwesomeIcons.rupeeSign,
                        color: HexColor("#736E62"),
                        size: 12,
                      ),
                    ),
                    Center(
                      child: Text(
                        allBalance.isNotEmpty ? " ${balance.value}" : " 0.0",
                        style: TextStyle(
                            color: HexColor("#736E62"),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget incomeExpenseBox({required var context}) {
    List<int> allBalance = transbox!.keys.cast<int>().toList();

    return Padding(
      padding: const EdgeInsets.only(
        left: 34,
        top: 13,
        right: 34,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: HexColor("#EDFDF4"),
                  borderRadius: BorderRadius.circular(15)),
              height: MediaQuery.of(context).size.width / 5,
              width: MediaQuery.of(context).size.width / 2.56,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Income",
                      style: TextStyle(
                          color: HexColor("#52AA54"),
                          fontFamily: "Poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: FaIcon(
                            FontAwesomeIcons.rupeeSign,
                            color: HexColor("#52AA54"),
                            size: 12,
                          ),
                        ),
                        Center(
                          child: Text(
                            allBalance.isNotEmpty ? " ${sumInc.value}" : " 0.0",
                            style: TextStyle(
                                color: HexColor("#52AA54"),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: HexColor("#FDEEEC"),
                  borderRadius: BorderRadius.circular(15)),
              height: MediaQuery.of(context).size.width / 5,
              width: MediaQuery.of(context).size.width / 2.56,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Expense",
                      style: TextStyle(
                          color: HexColor("#FE5355"),
                          fontFamily: "Poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.rupeeSign,
                          color: HexColor("#FE5355"),
                          size: 12,
                        ),
                        Text(
                          allBalance.isNotEmpty
                              ? " ${sumOfExpnse.value}"
                              : " 0.0",
                          style: TextStyle(
                              color: HexColor("#FE5355"),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget transactionShow({required var context}) {
    return Expanded(
      flex: 3,
      child: Container(
        height: MediaQuery.of(context).size.height / 2.56,
        decoration: BoxDecoration(
            color: constant.myColors.secondary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
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
                          border: Border.all(color: constant.myColors.black)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 3),
                        child: DropdownButtonFormField(
                          dropdownColor: constant.myColors.Primarywhite,
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: Colors.black,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: constant.myColors.black,
                          ),
                          elevation: 30,
                          iconSize: 32,
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
                              color: constant.myColors.black,
                            ),
                          ),
                          items: _list.map((e) {
                            return DropdownMenuItem(
                              onTap: () {
                                if (e == _list[0]) {
                                  All = true;
                                  Monthly = false;
                                  Custom = false;
                                  update();
                                } else if (e == _list[1]) {
                                  Today = true;
                                  All = false;
                                  Yesterday = false;
                                  Monthly = false;
                                  Custom = false;
                                  update();
                                }
                                if (e == _list[2]) {
                                  Yesterday = true;
                                  All = false;
                                  Today = false;
                                  Monthly = false;
                                  Custom = false;
                                  update();
                                }
                                if (e == _list[4]) {
                                  Monthly = true;
                                  Custom = false;
                                  All = false;
                                  Today = false;
                                  Yesterday = false;
                                  update();
                                } else if (e == _list[3]) {
                                  Custom = true;
                                  Monthly = false;
                                  All = false;
                                  Today = false;
                                  Yesterday = false;
                                  update();
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
                    padding: const EdgeInsets.only(top: 23, left: 1, right: 3),
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
                                        onTap: () => _datepicker(context: null),
                                        child: Text(formattedMonth,
                                            style: TextStyle(
                                              color: constant.myColors.black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ))),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14.0),
                                    child: TextButton(
                                      onPressed: () {
                                        dateRangePicker(context: null);
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
                                        dateRangePicker(context: null);
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
                child: GetBuilder<HomeScreenController>(
                    init: HomeScreenController(),
                    builder: (controller) {
                      List<int> today = transbox!.keys
                          .cast<int>()
                          .where((Key) => transbox!.get(Key)!.time == _date)
                          .toList();
                      List<int> all = transbox!.keys.cast<int>().toList();
                      List<int> custom = transbox!.keys
                          .cast<int>()
                          .where((Key) => transbox!.get(Key)!.time == _date)
                          .toList();
                      List<int> yesterday = transbox!.keys
                          .cast<int>()
                          .where(
                              (Key) => transbox!.get(Key)!.time == _yesterday)
                          .toList();
                      List<int> monthly = transbox!.keys
                          .cast<int>()
                          .where((Key) =>
                              transbox!.get(Key)!.time.month == month.month)
                          .toList();
                      List<int> start = transbox!.keys
                          .cast<int>()
                          .where((Key) => transbox!.get(Key)!.time == startDate)
                          .toList();

                      List<int> end = transbox!.keys
                          .cast<int>()
                          .where((Key) => transbox!.get(Key)!.time == endDate)
                          .toList();
                      int difference = endDate.difference(startDate).inDays;

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
                              color: constant.myColors.black,
                            ),
                          ),
                        );
                      }
                      if (All == true && all.isNotEmpty) {
                        return listView(id: all, context: context);
                      }
                      if (Today == true && today.isNotEmpty) {
                        return listView(id: today, context: context);
                      }
                      if (Yesterday == true && yesterday.isNotEmpty) {
                        return listView(id: yesterday, context: null);
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

                            final Transactionmodel? transs = transbox!.get(key);

                            final _date = transs!.time;

                            formattedDate = DateFormat('dd').format(_date);
                            formattedDate1 = DateFormat('EEE').format(_date);

                            return Dismissible(
                              background: Container(
                                color: Colors.red,
                                child: Center(child: Icon(Icons.delete)),
                              ),
                              key: ValueKey<int>(key),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  final bool res = await showDialog(
                                      context: context,
                                      builder: (BuildContext) {
                                        return AlertDialog(
                                          backgroundColor:
                                              constant.myColors.secondary,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                " Delete this Transaction",
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
                                                                  .all(constant
                                                                      .myColors
                                                                      .yellow)),
                                                      onPressed: () {
                                                        transbox!
                                                            .delete(key)
                                                            .then((value) {
                                                          initFunction();
                                                          update();
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1),
                                                              () {
                                                            initFunction();
                                                          });
                                                        });
                                                        Navigator.of(context)
                                                            .pop(true);
                                                        update();
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            color: constant
                                                                .myColors
                                                                .Primarywhite,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(constant
                                                                      .myColors
                                                                      .yellow)),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            color: constant
                                                                .myColors
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
                                  return res;
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              onDismissed: (DismissDirection direction) {},
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 10,
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
                                            color:
                                                constant.myColors.Primarywhite,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                formattedDate,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      constant.myColors.black,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                formattedDate1,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      constant.myColors.black,
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
                                        margin: const EdgeInsets.only(
                                            left: 1, right: 1),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                transs.categorie.toUpperCase(),
                                                style: TextStyle(
                                                    color:
                                                        constant.myColors.black,
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
                                              left: 0.0,
                                              right: 0,
                                              top: 16,
                                              bottom: 0),
                                          child: transs.isIncome == true
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .rupeeSign,
                                                      color:
                                                          HexColor("#52AA54"),
                                                      size: 11,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        " ${transs.amount}",
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                "#52AA54"),
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .rupeeSign,
                                                      color:
                                                          HexColor("#FE5355"),
                                                      size: 13,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        " ${transs.amount}",
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                "#FE5355"),
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                          separatorBuilder: (cont, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: rangeKey.length,
                          shrinkWrap: true,
                        );
                      }
                      if (Monthly == true && monthly.isNotEmpty) {
                        return listView(id: monthly, context: null);
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
                                  color: constant.myColors.black,
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
    );
  }
}
