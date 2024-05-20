import 'dart:async';

import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class Done extends StatefulWidget{
  UserModel? userModel;

  Done(this.userModel);

  @override
  State<StatefulWidget> createState() {
    return _Done();
  }

}
class _Done extends State<Done>{
  UserModel? userInfo;
  Future<List<OrderModel>>? orders;

  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  void initState() {
    super.initState();
    orders = getOrders();
  }
  @override
  Widget build(BuildContext context) {
    userInfo = widget.userModel;

    return SwipeRefresh.material(
        stateStream: _stream,
        onRefresh: (){
          setState(() {
            orders = getOrders();
            _controller.sink.add(SwipeRefreshState.hidden);
          });
        },
    children: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder(
                future: orders,
                builder: (context, snapshot){
                  if(snapshot.data!=null && snapshot.data!.length>0) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return  GlobalWidgets.order(snapshot.data![index], false);
                      },
                    );
                  }else{
                    return GlobalWidgets.emptyOrders(context, userInfo!);
                  }
                }),
          ],
        ),
      )
    ],);
  }

  Future<List<OrderModel>> getOrders() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    String? token = await GlobalWidgets.getToken();

    return await client.findOrdersDone("Bearer $token");
  }
}