import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderInfo extends StatefulWidget {
  OrderEntity order;
  OrderModel? model;
  OrderInfo(this.order, {this.model, super.key});

  @override
  State<StatefulWidget> createState() {
    return _OrderInfo();
  }
}

class _OrderInfo extends State<OrderInfo> {
  @override
  Widget build(BuildContext context) {
    String date = DateFormat("EEEE, d MMMM в H:mm", "Ru_ru").format(widget.order.startDate!);
    String _date = date[0].toUpperCase() + date.substring(1) + " ~ " + widget.order.hour.toString() + " часа";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).you_order,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).apartaments_clean, style: TextStyle(fontSize: 24)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(_date, style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(widget.order.address_str, style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(S.of(context).pay, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisSize: MainAxisSize.max, children: [
                      Flexible(
                        child: Text(S.of(context).main_clean),
                        fit: FlexFit.tight,
                      ),
                      Flexible(
                        child: Text(widget.order.mainPrice.toInt().toString() + " р."),
                        flex: 0,
                      )
                    ]),
                    Text(
                      widget.order.countRoom.toString() + " ${S.of(context).room_and} " + widget.order.countBathroom.toString() + " санузел",
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.order.options!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(widget.order.options![index].name),
                                    fit: FlexFit.tight,
                                  ),
                                  Flexible(
                                    child: Text(widget.order.options![index].price.toInt().toString() + " ₸."),
                                    flex: 0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }),
                    Divider(),
                    Row(
                      children: [
                        Flexible(
                          child: Text("${S.of(context).price_result} "),
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Text(widget.order.price.toInt().toString() + " ₸."),
                          flex: 0,
                        )
                      ],
                    ),
                    widget.order.customPrice != null ? Divider() : SizedBox.shrink(),
                    widget.order.customPrice != null
                        ? Row(
                            children: [
                              Flexible(
                                child: Text("${S.of(context).you_price} "),
                                fit: FlexFit.tight,
                              ),
                              Flexible(
                                flex: 0,
                                child: Text(widget.order.customPrice.toString() + " ₸."),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Spacer(),
            widget.model == null
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: CustomTheme.primaryColors,
                            side: BorderSide.none),
                        onPressed: () async {
                          Dio dio = Dio();
                          final client = RestClient(dio);
                          String? token = await getToken();

                          await client.pushOrder("Bearer $token", widget.order.countRoom!, widget.order.countBathroom!, widget.order.address!.id, widget.order.startDate!, widget.order.customPrice, widget.order.size, widget.order.options_str);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Ink(
                          width: double.maxFinite,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(S.of(context).start_order, style: TextStyle(color: Colors.white)),
                          ),
                        )))
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}

class OrderCreated extends Notification {
  OrderCreated();
}
