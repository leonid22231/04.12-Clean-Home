import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/entities/enums/Role.dart';
import 'package:cleanhome/entities/enums/Status.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  final OrderModel order;
  final RegionModel region;
  final Role role;
  Order(this.order, this.region, this.role, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _Order();
  }
}

class _Order extends State<Order> {
  @override
  Widget build(BuildContext context) {
    Role role = widget.role;
    OrderModel orderModel = widget.order;
    OrderEntity orderEntity = OrderEntity(widget.region.priceRoom, widget.region.priceBathroom, 1 + orderModel.countRoom + orderModel.countBathroom, widget.region.priceSize, widget.region);
    orderEntity.countBathroom = orderModel.countBathroom;
    orderEntity.countRoom = orderModel.countRoom;
    orderEntity.setOptions(orderModel.options);
    if (orderModel.customPrice != null) {
      orderEntity.customPrice = orderModel.customPrice;
    }
    if (orderModel.size != null) {
      orderEntity.size = orderModel.size;
    }
    int hour = orderModel.countBathroom + orderModel.countRoom + 1;
    String startDate = DateFormat("EEEE, d MMMM", "Ru_ru").format(orderModel.startDate);

    startDate = startDate[0].toUpperCase() + startDate.substring(1);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 130,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(startDate),
                          Text("${DateFormat("HH:mm").format(orderModel.startDate)} — ${DateFormat("HH:mm").format(orderModel.startDate.copyWith(hour: orderModel.startDate.hour + hour))}"),
                          SizedBox(
                            height: 10,
                          ),
                          Text(orderModel.address.toString(), style: TextStyle(color: Colors.black.withOpacity(1), fontSize: 18)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [GlobalWidgets.orderStatus(orderModel)],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            getFirstButton(role, orderModel),
            getSecondButton(role, orderModel),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), border: Border.all(color: Color(0xffb9c5db))),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            S.of(context).price_clean,
                            style: TextStyle(fontSize: 16),
                          ),
                          fit: FlexFit.tight,
                        ),
                        orderEntity.customPrice == null
                            ? Text(
                                orderEntity.mainPrice.toInt().toString() + " ₸",
                                style: TextStyle(fontSize: 16),
                              )
                            : Text(
                                orderEntity.customPrice.toString() + " ₸",
                                style: TextStyle(fontSize: 16),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                                    child: Text(
                                      widget.order.options![index].name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    fit: FlexFit.tight,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "+" + widget.order.options![index].price.toInt().toString() + " ₸",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    flex: 0,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: Text(
                              S.of(context).main_price,
                              style: TextStyle(fontSize: 16),
                            ),
                            fit: FlexFit.tight),
                        orderEntity.customPrice == null
                            ? Text(
                                orderEntity.price.toInt().toString() + " ₸",
                                style: TextStyle(fontSize: 16),
                              )
                            : Text(
                                orderEntity.customPrice.toString() + " ₸",
                                style: TextStyle(fontSize: 16),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.all(10),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(
                          color: CustomTheme.primaryColors,
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Ink(
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(S.of(context).close, style: TextStyle(color: CustomTheme.primaryColors)),
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Widget getFirstButton(Role role, OrderModel orderModel) {
    switch (role) {
      case Role.USER:
        return Padding(
            padding: EdgeInsets.all(10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: CustomTheme.primaryColors,
                    side: const BorderSide(
                      color: Colors.black,
                    )),
                onPressed: () {},
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).move, style: TextStyle(color: Colors.white)),
                  ),
                )));
      case Role.CLEANER:
        {
          switch (GlobalWidgets.statusFromString(orderModel.status)) {
            case Status.FINDING_CLEANER:
              return Padding(
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
                        RestClient restClient = RestClient(dio);
                        String? token = await GlobalWidgets.getToken();

                        restClient.selectOrderToCleaner("Bearer $token", orderModel.id).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Ink(
                        width: double.maxFinite,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(S.of(context).confirm_, style: TextStyle(color: Colors.white)),
                        ),
                      )));
            case Status.FOUND_CLEANER:
              return Padding(
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
                        RestClient restClient = RestClient(dio);
                        String? token = await GlobalWidgets.getToken();

                        restClient.startOrder("Bearer $token", orderModel.id).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Ink(
                        width: double.maxFinite,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(S.of(context).start_work, style: TextStyle(color: Colors.white)),
                        ),
                      )));
            case Status.WORK_STARTED:
              return Padding(
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
                        RestClient restClient = RestClient(dio);
                        String? token = await GlobalWidgets.getToken();
                        restClient.finishOrder("Bearer $token", orderModel.id).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Ink(
                        width: double.maxFinite,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(S.of(context).end_work, style: TextStyle(color: Colors.white)),
                        ),
                      )));
            default:
              return SizedBox();
          }
        }

      default:
        return SizedBox();
    }
  }

  Widget getSecondButton(Role role, OrderModel orderModel) {
    switch (role) {
      case Role.USER:
        return Padding(
            padding: EdgeInsets.all(10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: CustomTheme.primaryColors,
                    )),
                onPressed: () async {
                  Dio dio = Dio();
                  RestClient client = RestClient(dio);
                  String? token = await getToken();

                  client.cancelOrder("Bearer $token", orderModel.id);
                  Navigator.pop(context);
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).cancel, style: TextStyle(color: CustomTheme.primaryColors)),
                  ),
                )));
      case Role.CLEANER:
        return SizedBox();
      default:
        return SizedBox();
    }
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
