import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/block/login_bloc.dart';
import 'package:cleanhome/entities/enums/Role.dart';
import 'package:cleanhome/entities/enums/Status.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/create_order.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlobalWidgets {
  static bool login = false;
  static Text orderStatus(OrderModel orderModel) {
    switch (statusFromString(orderModel.status)) {
      case Status.FINDING_CLEANER:
        {
          return Text(
            S.current.w_1,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
          );
        }
      case Status.FOUND_CLEANER:
        {
          return Text(
            S.current.w_2,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
          );
        }
      case Status.WORK_STARTED:
        {
          return Text(
            S.current.w_3,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
          );
        }
      case Status.WORK_FINISH:
        {
          return Text(
            S.current.w_4,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
          );
        }
      case Status.WORK_CANCEL:
        {
          return Text(
            S.current.w_5,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
          );
        }
      default:
        return Text(
          S.current.w_6,
          style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
        );
    }
  }

  static Status statusFromString(String str) {
    for (int i = 0; i < Status.values.length; i++) {
      if (Status.values[i].name == str) {
        return Status.values[i];
      }
    }
    return Status.FINDING_CLEANER;
  }

  static Role roleFromString(String str) {
    for (int i = 0; i < Role.values.length; i++) {
      if (Role.values[i].name == str) {
        return Role.values[i];
      }
    }
    return Role.USER;
  }

  static Widget emptyOrders(BuildContext context, UserModel userModel) {
    return Container(
      width: double.maxFinite,
      height: 210,
      decoration: BoxDecoration(
          color: Colors.white70,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.5, blurRadius: 1, offset: const Offset(0, 3)),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).w_8, style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 20),
            Text(S.of(context).lol, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.green,
                    side: const BorderSide(
                      color: Colors.green,
                    )),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrder(userModel.region!)));
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).start_order, style: TextStyle(color: Colors.white)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  static Widget order(OrderModel orderModel, bool view) {
    int hour = orderModel.countBathroom + orderModel.countRoom + 1;
    String startDate = DateFormat("EEEE, d MMMM", "Ru_ru").format(orderModel.startDate);
    startDate = startDate[0].toUpperCase() + startDate.substring(1);
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
            color: Colors.white70,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.5, blurRadius: 1, offset: const Offset(0, 5)),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
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
                        Text(orderModel.address.toString(), style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 14)),
                        view ? TextButton(onPressed: () {}, child: const Text("Подробнее", style: TextStyle(color: Colors.green))) : SizedBox()
                      ],
                    ),
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [GlobalWidgets.orderStatus(orderModel)],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> logout(BuildContext context) async {
    Dio dio = Dio();
    RestClient restClient = RestClient(dio);
    String? token = await GlobalWidgets.getToken();
    restClient.logout("Bearer $token").then((value) {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      print("Logout succes");
      FirebaseAuth.instance.signOut();
      loginBloc.add(LoginChangeStatusEvent(false));
    }).onError((error, stackTrace) {
      print("LogoutError $error");
    });
  }

  static Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
