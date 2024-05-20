import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/NewModel.dart';
import 'package:cleanhome/api/models/OrderModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/OrderInfo.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/create_order.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Orders extends StatefulWidget {
  UserModel userInfo;
  Orders(this.userInfo, {super.key});
  @override
  State<StatefulWidget> createState() {
    return _Orders();
  }
}

class _Orders extends State<Orders> {
  UserModel? userInfo;
  bool empty = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userInfo = widget.userInfo;
    final controller = PageController(viewportFraction: 1.0, keepPage: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).hello,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.sp),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffE2E5F4)),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/notification.svg",
                      height: 20.sp,
                      width: 20.sp,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffE2E5F4)),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/question.svg",
                      height: 20.sp,
                      width: 20.sp,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 25.sp, right: 25.sp, top: 25.sp, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: getRegionNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: 55.sp,
                            child: PageView.builder(
                                controller: controller,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 55.sp,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: CustomTheme.primaryColors),
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/background.svg",
                                          height: 55.sp,
                                          width: double.maxFinite,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(25.sp),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].title,
                                                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 14.sp,
                                              ),
                                              Text(snapshot.data![index].info, style: TextStyle(color: Colors.white, fontSize: 16.sp))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            height: 55.sp,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.sp),
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  count: snapshot.data!.length,
                                  effect: ExpandingDotsEffect(
                                    activeDotColor: Colors.white,
                                    dotHeight: 8.sp,
                                    dotWidth: 8.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return SizedBox.shrink(
                        child: Text(S.of(context).not_found),
                      );
                    }
                  } else {
                    print("Not loading");
                    return SizedBox.shrink(
                      child: Text(S.of(context).loading),
                    );
                  }
                }),
            SizedBox(
              height: 15.sp,
            ),
            Text(S.of(context).active_orders),
            SizedBox(
              height: 20.sp,
            ),
            FutureBuilder(
                future: getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return Container(
                        height: 25.h,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              OrderEntity order = OrderEntity(userInfo!.region!.priceRoom, userInfo!.region!.priceBathroom, snapshot.data![index].countBathroom + snapshot.data![index].countRoom, userInfo!.region!.priceSize, userInfo!.region);
                              order.setOptions(snapshot.data![index].options);
                              order.countRoom = snapshot.data![index].countRoom;
                              order.countBathroom = snapshot.data![index].countBathroom;
                              order.customPrice = snapshot.data![index].customPrice;
                              if (snapshot.data![index].size != null) {
                                order.size = snapshot.data![index].size;
                              }
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      order.setAddress(snapshot.data![index].address);
                                      order.setStartDate(snapshot.data![index].startDate);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInfo(order, model: snapshot.data![index])));
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GlobalWidgets.orderStatus(snapshot.data![index]),
                                                order.customPrice == null
                                                    ? Text(
                                                        order.price.toString() + " ₸",
                                                        style: TextStyle(fontSize: 16.sp),
                                                      )
                                                    : Text(
                                                        order.customPrice.toString() + " ₸",
                                                        style: TextStyle(fontSize: 16.sp),
                                                      )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                ],
                              );
                            }),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).active_orders_not_found,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: CustomTheme.primaryColors),
                        ),
                      );
                    }
                  } else {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).loading,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: CustomTheme.primaryColors),
                      ),
                    );
                  }
                }),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 23.sp),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrder(userInfo!.region!)));
                },
                child: Container(
                  width: double.maxFinite,
                  height: 15.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: CustomTheme.primaryColors,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 20.sp),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).start_order,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            Text(
                              S.of(context).lol,
                              style: TextStyle(fontSize: 15.sp, color: Colors.white),
                            )
                          ],
                        )),
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<OrderModel>> getOrders() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    String? token = await GlobalWidgets.getToken();
    return client.findOrders("Bearer $token");
  }

  Future<List<NewModel>> getRegionNews() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    String? token = await GlobalWidgets.getToken();
    return await client.regionNews("Bearer $token", userInfo!.region!.id!);
  }
}
