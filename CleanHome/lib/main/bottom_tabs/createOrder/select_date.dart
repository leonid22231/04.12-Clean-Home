import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/OrderInfo.dart';
import 'package:cleanhome/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class SelectDate extends StatefulWidget {
  OrderEntity order;

  SelectDate(this.order);

  @override
  State<StatefulWidget> createState() {
    return _SelectDate();
  }
}

class _SelectDate extends State<SelectDate> {
  DateTime startDate = DateTime.now();
  late OrderEntity order;
  @override
  Widget build(BuildContext context) {
    order = widget.order;
    double price = order.price;
    int hour = order.hour;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).date_and_time,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Text(S.of(context).select_date_and_time, style: const TextStyle(fontSize: 20)),
            )),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    onDateChange: (date) {
                      setState(() {
                        startDate = startDate.copyWith(day: date.day, month: date.month);
                      });
                    },
                    selectionColor: Colors.blueAccent,
                    selectedTextColor: Colors.white,
                    daysCount: 14,
                    locale: "Ru_ru",
                    height: 90,
                  ),
                  TextButton(
                      onPressed: () {
                        _showDialog();
                      },
                      child: Text(DateFormat("HH:mm").format(startDate), style: TextStyle(fontSize: 22))),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: CustomTheme.primaryColors,
                              side: BorderSide.none),
                          onPressed: () {
                            order.setStartDate(startDate);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInfo(order)));
                          },
                          child: Ink(
                            width: double.maxFinite,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(S.of(context).next, style: TextStyle(color: Colors.white)),
                            ),
                          )))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
              initialDateTime: startDate,
              use24hFormat: true,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (_) {
                setState(() {
                  startDate = _;
                });
              }),
        ),
      ),
    );
  }
}
