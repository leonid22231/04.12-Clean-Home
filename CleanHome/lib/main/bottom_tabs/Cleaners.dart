import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/OrderInfo.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Cleaners extends StatefulWidget {
  UserModel userInfo;

  Cleaners(this.userInfo, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _Cleaners();
  }
}

class _Cleaners extends State<Cleaners> {
  Future<String?>? _token;

  @override
  void initState() {
    super.initState();
    _token = getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).orders,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: FutureBuilder(
        future: getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return Padding(
                padding: EdgeInsets.all(20.sp),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              OrderEntity order = OrderEntity(widget.userInfo.region!.priceRoom, widget.userInfo.region!.priceBathroom, 1 + snapshot.data![index].countBathroom + snapshot.data![index].countRoom, widget.userInfo.region!.priceSize, widget.userInfo.region);
                              order.setOptions(snapshot.data![index].options);
                              order.setAddress(snapshot.data![index].address);
                              order.setStartDate(snapshot.data![index].startDate);
                              order.countRoom = snapshot.data![index].countRoom;
                              order.countBathroom = snapshot.data![index].countBathroom;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInfo(order, model: snapshot.data![index])));
                            },
                            child: order(snapshot.data![index]),
                          ),
                          SizedBox(
                            height: 16.sp,
                          )
                        ],
                      );
                    }),
              );
            } else {
              return Center(
                child: Text(
                  S.of(context).orders_not_found,
                  style: TextStyle(fontSize: 20.sp, color: CustomTheme.primaryColors),
                ),
              );
            }
          } else {
            return Center(
              child: Text(S.of(context).loading),
            );
          }
        },
      ),
    );
  }

  Future<List<OrderModel>> getOrders() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    String? token = await GlobalWidgets.getToken();

    return client.findOrdersDone("Bearer $token");
  }

  Widget order(OrderModel orderModel) {
    return Container(
      height: 11.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xffF9F9F9)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      color: CustomTheme.primaryColors,
                    ),
                    SizedBox(
                      width: 10.sp,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).apartaments_clean,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        Text(
                          orderModel.address.toString(),
                          style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      DateFormat("dd MMM y", "ru").format(orderModel.createDate),
                      style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                    ),
                    Text(
                      DateFormat("hh:ss", "ru").format(orderModel.createDate),
                      style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlobalWidgets.orderStatus(orderModel),
                Text(
                  getPrice(orderModel) + " ₸",
                  style: TextStyle(fontSize: 16.sp),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String getPrice(OrderModel orderModel) {
    double price = widget.userInfo.region!.priceRoom * orderModel.countRoom + widget.userInfo.region!.priceBathroom * orderModel.countBathroom;
    if (orderModel.options.isNotEmpty) {
      orderModel.options.map((e) {
        price += e.price;
      }).toList();
    }
    return price.toString();
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
