import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:wallet_controller/constants/constant_widget.dart';
import 'package:wallet_controller/model/model.dart';
import 'package:wallet_controller/model/transactionModel.dart';
import 'package:wallet_controller/view/overview/overview.dart';

class OverviewController extends GetxController {
//*********Variables******************************************************
  var constatnt = Get.put(Constantwidgets());
  @override
  void onInit() {
    super.onInit();
    catbox = Hive.box<Model>("catogeries");
    transbox = Hive.box<Transactionmodel>("transaction");
    update();
  }

  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  String formattedDate = DateFormat('MMM-dd').format(_date);
  String formattedDateyester = DateFormat('MMM-dd').format(_yesterday);

  String formattedMonth = DateFormat('MMMM').format(month);
  static DateTime month = DateTime.now();
  static DateTimeRange? range;
  static DateTime startDate = DateTime.now().add(const Duration(days: -5));
  static DateTime endDate = DateTime.now();
  String formattedStartDate = DateFormat('MMM-dd').format(startDate);
  String formattedEndDate = DateFormat('MMM-dd').format(endDate);
  Map<String, double> val() {
    return {
      "txt1": 00,
      "txt2": 01,
      "txt3": 01,
    };
  }

  List<int> rangeKey = [];

  bool income = true;
  bool expense = false;
  final _list = ['All', 'Today', 'Yesterday', 'Custom', 'Monthly'];
  bool All = true;
  bool Today = false;
  bool Yesterday = false;
  bool Custom = false;
  bool Monthly = false;

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
  // List<int> piechartAll = transbox.keys
  //     .cast<int>()
  //     .where((Key) => transbox.get(Key)!.isIncome == true)
  //     .toList();

//**************Fuctions ******************************************************/

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

    // formattedMonth = month.toString();
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
            color: constatnt.myColors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
          DateFormat('MMM-dd').format(
            range!.start,
          ),
          style: TextStyle(
            color: constatnt.myColors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    }
  }

  Widget toFrom() {
    if (range == null) {
      return Text("Untill",
          style: TextStyle(
            color: constatnt.myColors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
        DateFormat('MMM-dd').format(range!.end),
        style: TextStyle(
          color: constatnt.myColors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  Widget dropDown({required var context}) {
    return Row(
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
                //  border: Border.all(color: constatnt.myColors.black)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 3),
                child: DropdownButtonFormField(
                  dropdownColor: constatnt.myColors.Primarywhite,
                  iconDisabledColor: Colors.red,
                  iconEnabledColor: Colors.black,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: constatnt.myColors.black,
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
                      color: constatnt.myColors.black,
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
                                onTap: () => _datepicker(context: context),
                                child: Text(formattedMonth,
                                    style: TextStyle(
                                      color: constatnt.myColors.black,
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
                                dateRangePicker(context: context);
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
                                dateRangePicker(context: context);
                              },
                              child: toFrom(),
                            ),
                          ),
                        ],
                      )),
      ],
    );
  }

  Widget selectionButton() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
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
                            constatnt.myColors.yellow,
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
                            ? constatnt.myColors.Primarywhite
                            : constatnt.myColors.yellow,
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
                            constatnt.myColors.yellow,
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
                            ? constatnt.myColors.Primarywhite
                            : constatnt.myColors.yellow,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500))),
          ),
        ],
      ),
    );
  }

  Widget piechart(
      {required Map<String, double> val, required MaterialColor color}) {
    return PieChart(
      dataMap: val,
      ringStrokeWidth: 90,
      colorList: [
        HexColor("#2f4b7c"),
        HexColor("#665191"),
        HexColor("a05195"),
        HexColor("#d45087"),
        HexColor("#f95d6a"),
        HexColor("#ff7c43"),
        HexColor("#ffa600"),
        HexColor("#003f5c"),
        color,
      ],
      chartRadius: 70,
      animationDuration: Duration(milliseconds: 1000),
      chartType: ChartType.ring,
      legendOptions: LegendOptions(
          legendPosition: LegendPosition.right,
          showLegendsInRow: false,
          showLegends: true,
          legendTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: constatnt.myColors.black),
          legendShape: BoxShape.circle),
      chartValuesOptions: ChartValuesOptions(
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900]!.withOpacity(0.9),
        ),
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
        decimalPlaces: 0,
        chartValueBackgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget pie({required var context}) {
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

    return  Container(
          decoration: BoxDecoration(
              color: constatnt.myColors.secondary,
              borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(top: 25),
          width: MediaQuery.of(context).size.width / 1.3,
          height: MediaQuery.of(context).size.height / 3.56,
          child:
          
           income == true
              ? piechartIncome.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 13,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50.0),
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
                                                  sumOfCatogoriesFromTransBox: transbox
                                                      .keys
                                                      .cast<int>()
                                                      .where((Key) =>
                                                          transbox.get(Key)!.isIncome ==
                                                              true &&
                                                          transbox.get(Key)!.time ==
                                                              _yesterday)
                                                      .toList(),
                                                  isIncome: true)
                                              : Monthly == true
                                                  ? catgorieFetchingInc(
                                                      sumOfCatogoriesFromTransBox:
                                                          transbox.keys
                                                              .cast<int>()
                                                              .where((Key) =>
                                                                  transbox
                                                                          .get(Key)!
                                                                          .time
                                                                          .month ==
                                                                      month.month &&
                                                                  transbox.get(Key)!.isIncome == true)
                                                              .toList(),
                                                      isIncome: true)
                                                  : Custom == true
                                                      ? catgorieFetchingIncCustom()
                                                      : val(),
                                  color: Colors.green),
                            ),
                          ),
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
                          color: constatnt.myColors.black,
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
                                              transbox.get(Key)!.isIncome == false)
                                          .toList(),
                                      isIncome: false)
                                  : Today == true
                                      ? catgorieFetchingExp(
                                          sumOfCatogoriesFromTransBox: transbox.keys
                                              .cast<int>()
                                              .where((Key) =>
                                                  transbox.get(Key)!.isIncome ==
                                                      false &&
                                                  transbox.get(Key)!.time == _date)
                                              .toList(),
                                          isIncome: false)
                                      : Yesterday == true
                                          ? catgorieFetchingExp(
                                              sumOfCatogoriesFromTransBox: transbox
                                                  .keys
                                                  .cast<int>()
                                                  .where((Key) =>
                                                      transbox.get(Key)!.isIncome ==
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
                                                          .where((Key) =>
                                                              transbox
                                                                      .get(Key)!
                                                                      .time
                                                                      .month ==
                                                                  month.month &&
                                                              transbox
                                                                      .get(Key)!
                                                                      .isIncome ==
                                                                  false)
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
                          color: constatnt.myColors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
        );
      
  }

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

        return Container(
          // color: constatnt.myColors.yellow,
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
                      color: constatnt.myColors.Primarywhite,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 20,
                            color: constatnt.myColors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          formattedDate1,
                          style: TextStyle(
                            fontSize: 10,
                            color: constatnt.myColors.black,
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
                              color: constatnt.myColors.black,
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
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          )),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (cont, index) => Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: Divider(
          thickness: 3,
          color: constatnt.myColors.Primarywhite,
        ),
      ),
      itemCount: id.length,
      shrinkWrap: true,
    );
  }

  Widget transactionShow({required var context}) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
            color: constatnt.myColors.secondary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
              child: income == true
                  ? ValueListenableBuilder(
                      valueListenable: transbox.listenable(),
                      builder: (context, Box<Transactionmodel> transactionshow,
                          cntxt) {
                        List<int> today = transbox.keys
                            .cast<int>()
                            .where((Key) =>
                                transbox.get(Key)!.time == _date &&
                                transbox.get(Key)!.isIncome == true)
                            .toList();
                        List<int> all = transbox.keys
                            .cast<int>()
                            .where((Key) => transbox.get(Key)!.isIncome == true)
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
                                transbox.get(Key)!.time.month == month.month &&
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
                        int difference = endDate.difference(startDate).inDays;

                        List<int> rangeKey = [];
                        for (int i = 0; i <= difference; i++) {
                          rangeKey.addAll(transbox.keys
                              .cast<int>()
                              .where((Key) =>
                                  transbox.get(Key)!.time ==
                                      startDate.add(Duration(days: i)) &&
                                  transbox.get(Key)!.isIncome == true)
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
                                color: constatnt.myColors.black,
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
                              List<int> keyy = rangeKey.reversed.toList();
                              final key = keyy[index];
                              int difference =
                                  endDate.difference(startDate).inDays;
                              for (int i = 0; i <= difference; i++) {
                                rangeKey.addAll(transbox.keys
                                    .cast<int>()
                                    .where((Key) =>
                                        transbox.get(Key)!.time ==
                                            startDate.add(Duration(days: i)) &&
                                        transbox.get(Key)!.isIncome == true)
                                    .toList());
                              }

                              final Transactionmodel? transs =
                                  transbox.get(key);

                              final _date = transs!.time;

                              formattedDate = DateFormat('dd').format(_date);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6, bottom: 0, top: 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 10,
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
                                              color: constatnt
                                                  .myColors.Primarywhite,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: constatnt
                                                        .myColors.black,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  formattedDate1,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: constatnt
                                                        .myColors.black,
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
                                          // color: Colors.red,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  transs.categorie
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: constatnt
                                                          .myColors.black,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  transs.notes ?? "",
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#8A8A8A'),
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons
                                                            .rupeeSign,
                                                        color:
                                                            HexColor("#52AA54"),
                                                        size: 11,
                                                      ),
                                                      Text(
                                                        " ${transs.amount}",
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                "#52AA54"),
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                        color:
                                                            HexColor("#FE5355"),
                                                        size: 13,
                                                      ),
                                                      Text(
                                                        " ${transs.amount}",
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                "#FE5355"),
                                                            fontFamily:
                                                                "Poppins",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                              Box<Transactionmodel> transactionshow, cntxt) {
                            List<int> todayExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.time == _date &&
                                    transbox.get(Key)!.isIncome == false)
                                .toList();
                            List<int> allExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.isIncome == false)
                                .toList();
                            List<int> customExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.time == _date &&
                                    transbox.get(Key)!.isIncome == false)
                                .toList();
                            List<int> yesterdayExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.time == _yesterday &&
                                    transbox.get(Key)!.isIncome == false)
                                .toList();
                            List<int> monthlyExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.time.month ==
                                        month.month &&
                                    transbox.get(Key)!.isIncome == false)
                                .toList();
                            List<int> startExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.time == startDate &&
                                    transbox.get(Key)!.isIncome == false)
                                .toList();

                            List<int> endExp = transbox.keys
                                .cast<int>()
                                .where((Key) =>
                                    transbox.get(Key)!.time == endDate &&
                                    transbox.get(Key)!.isIncome == false)
                                .toList();
                            int difference =
                                endDate.difference(startDate).inDays;

                            List<int> rangeKeyExp = [];
                            for (int i = 0; i <= difference; i++) {
                              rangeKeyExp.addAll(transbox.keys
                                  .cast<int>()
                                  .where((Key) =>
                                      transbox.get(Key)!.time ==
                                          startDate.add(Duration(days: i)) &&
                                      transbox.get(Key)!.isIncome == false)
                                  .toList());
                            }

                            if (allExp.isEmpty) {
                              return Center(
                                child: Text(
                                  "No Transactions",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: HexColor("#CFF1EF").withOpacity(0.7),
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
                            if (Yesterday == true && yesterdayExp.isNotEmpty) {
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
                                    rangeKeyExp.addAll(transbox.keys
                                        .cast<int>()
                                        .where((Key) =>
                                            transbox.get(Key)!.time ==
                                                startDate
                                                    .add(Duration(days: i)) &&
                                            transbox.get(Key)!.isIncome ==
                                                false)
                                        .toList());
                                  }

                                  final Transactionmodel? transs =
                                      transbox.get(key);

                                  final _date = transs!.time;

                                  formattedDate =
                                      DateFormat('dd').format(_date);

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6, bottom: 0, top: 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
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
                                                  color: constatnt
                                                      .myColors.Primarywhite,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      formattedDate,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: constatnt
                                                            .myColors.black,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      formattedDate1,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: constatnt
                                                            .myColors.black,
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
                                              // color: Colors.red,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      transs.categorie
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color: constatnt
                                                              .myColors.black,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      transs.notes ?? "",
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              '#8A8A8A'),
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
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
                                itemCount: rangeKeyExp.length,
                                shrinkWrap: true,
                              );
                            }
                            if (Monthly == true && monthlyExp.isNotEmpty) {
                              return listView(id: monthlyExp);
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
                              color: constatnt.myColors.black,
                            ),
                          ),
                        ),
            )),
          ],
        ),
      ),
    );
  }
}
