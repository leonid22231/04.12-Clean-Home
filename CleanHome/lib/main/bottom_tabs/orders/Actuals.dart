import 'dart:async';

import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/NewModel.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/main/bottom_tabs/Order.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class Actuals extends StatefulWidget{
  UserModel? userModel;
  Actuals(this.userModel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _Actuals();
  }

}
class _Actuals extends State<Actuals> {
  UserModel? userInfo;
  Future<List<OrderModel>>? orders;

  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    FirebaseMessaging.onMessage.listen((event) {
      if (event.data["action"] == "update") {
        setState(() {
        });
      }
    });
    userInfo = widget.userModel;
    if(userInfo!=null) {
      return SwipeRefresh.material(
          padding: EdgeInsets.all(10),
          onRefresh: () {
            setState(() {
              _controller.sink.add(SwipeRefreshState.hidden);
            });
          },
          stateStream: _stream,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white70,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        offset: const Offset(0, 3)
                    ),
                  ]
              ),
              child: FutureBuilder<List<NewModel>>(
                  future: Future.delayed(Duration.zero),
                  builder: (context, snapshot){
                    if(snapshot.data == null){
                      return const SizedBox();
                    }else{
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                            return news(snapshot.data![index]);
                          }
                      );
                    }
                  }),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<OrderModel>>(
                future: orders,
                builder: (context, snapshot){
                  if(snapshot.data!=null && snapshot.data!.length>0){
                    return Column(
                        children: [
                          ListView.builder(
                            primary: false,
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              return  GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Order(snapshot.data![index], userInfo!.region!, GlobalWidgets.roleFromString(userInfo!.roles!.first!))));
                                },
                                child: GlobalWidgets.order(snapshot.data![index], true),
                              );
                            },

                          )
                        ],
                      );
                  }else{
                    return GlobalWidgets.emptyOrders(context, userInfo!);
                  }
                })
          ],
        );
    }else{
      return SizedBox();
    }
  }
  



  Widget news(NewModel newModel) {
    return Padding(padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 140,
          height: 140,
          child: Container(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0, 1),
                  colors: <Color>[
                    Color(0x5FFBF7C2),
                    Color(0x5FF8F199),
                    Color(0x5FF5EB70),
                    Color(0x5FF3E751),
                    Color(0x5FF1E332),
                  ],
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: Colors.blueAccent,
                    width: 2
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.discount_outlined),
                  ),
                  Spacer(),
                  Text(newModel.title, style: const TextStyle(
                      color: Colors.black, fontSize: 14)),
                ],
              ),
            ),
          ),
        ));
  }
}
class NotifyEmptyOrders extends Notification{
  bool empty;
  NotifyEmptyOrders(this.empty);
}