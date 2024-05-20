import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/Order.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WorkCleaner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorkCleaner();
  }
}

class _WorkCleaner extends State<WorkCleaner> {
  Future<List<OrderModel>>? orders;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.data["action"] == "update") {
        setState(() {
          orders = getOrders();
        });
      }
    });
    orders = getOrders();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).search_orders,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
      ),
      body: FutureBuilder(
          future: orders,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(S.of(context).orders_not_found),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(15.sp),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Dio dio = Dio();
                              RestClient restClient = RestClient(dio);
                              String? token = await GlobalWidgets.getToken();
                              UserModel userModel = await restClient.userInfo("Bearer $token");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Order(snapshot.data![index], userModel.region!, GlobalWidgets.roleFromString(userModel.roles!.first!)))).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
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
                                                  snapshot.data![index].address.toString(),
                                                  style: TextStyle(fontSize: 13.sp, color: Color(0xff6E6F79)),
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
                                              DateFormat("dd MMM y", "ru").format(snapshot.data![index].createDate),
                                              style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                                            ),
                                            Text(
                                              DateFormat("hh:ss", "ru").format(snapshot.data![index].createDate),
                                              style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.sp,
                          )
                        ],
                      );
                    }),
              );
            }
          }),
    );
  }

  Future<List<OrderModel>> getOrders() async {
    Dio dio = Dio();
    RestClient restClient = RestClient(dio);
    String? token = await GlobalWidgets.getToken();
    print("Token $token");
    return await restClient.findOrdersToCleaner("Bearer $token");
  }
}
