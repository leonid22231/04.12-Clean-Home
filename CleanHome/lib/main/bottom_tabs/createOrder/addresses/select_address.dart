import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/AddressModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/addresses/create_address.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/select_date.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectAddress extends StatefulWidget {
  OrderEntity order;
  RegionModel region;
  SelectAddress(this.order, {required this.region, super.key});

  @override
  State<StatefulWidget> createState() {
    return _SelectAddresses();
  }
}

class _SelectAddresses extends State<SelectAddress> {
  bool create = false;
  AddressModel? selectedAddress;
  @override
  Widget build(BuildContext context) {
    print(selectedAddress);
    OrderEntity order = widget.order;
    double price = order.price;
    int hour = order.hour;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).select_address,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(22.sp),
          child: Column(
            children: [
              FutureBuilder(
                  future: getAddresses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        if (selectedAddress == null) {
                          selectedAddress = snapshot.data!.first;
                        }
                        return Container(
                          color: Colors.transparent,
                          width: double.maxFinite,
                          height: 65.h,
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Dismissible(
                                          direction: DismissDirection.endToStart,
                                          confirmDismiss: (_) async {
                                            if (_ == DismissDirection.startToEnd) {
                                              return false;
                                            }
                                          },
                                          background: Container(
                                            width: double.maxFinite,
                                            height: 20.sp,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      color: Colors.redAccent,
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 15.sp),
                                                          child: Icon(
                                                            Icons.delete_forever,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                          key: Key(snapshot.data![index].id),
                                          onDismissed: (_) async {
                                            if (_ == DismissDirection.endToStart) {
                                              Dio dio = Dio();
                                              RestClient client = RestClient(dio);
                                              String? token = await GlobalWidgets.getToken();

                                              client.userAddressesDelete("Bearer $token", snapshot.data![index].id).then((value) {
                                                setState(() {});
                                              });
                                            }
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedAddress = snapshot.data![index];
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(color: selectedAddress?.id == snapshot.data![index].id ? CustomTheme.primaryColors : Color(0xffF9F9F9), borderRadius: BorderRadius.circular(8)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 18.sp),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.house, color: selectedAddress?.id == snapshot.data![index].id ? Colors.white : Colors.black),
                                                    SizedBox(
                                                      width: 10.sp,
                                                    ),
                                                    Text(
                                                      snapshot.data![index].toString(),
                                                      style: TextStyle(fontSize: 16.sp, color: selectedAddress?.id == snapshot.data![index].id ? Colors.white : Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    )
                                  ],
                                );
                              }),
                        );
                      } else {
                        print("Нету");
                        return Center(
                          child: Text(
                            S.of(context).address_not_found,
                            style: TextStyle(fontSize: 22.sp, color: CustomTheme.primaryColors),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Text(S.of(context).loading),
                      );
                    }
                  }),
              Spacer(),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: CustomTheme.primaryColors)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAddress(widget.region))).then((value) {
                      setState(() {});
                    });
                  },
                  child: Ink(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).add_address, style: TextStyle(color: CustomTheme.primaryColors)),
                    ),
                  )),
              SizedBox(
                height: 16.sp,
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: CustomTheme.primaryColors,
                      side: BorderSide.none),
                  onPressed: () {
                    order.setAddress(selectedAddress!);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectDate(order)));
                  },
                  child: Ink(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).next, style: TextStyle(color: Colors.white)),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<List<AddressModel>> getAddresses() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    String? token = await getToken();

    return client.userAddresses("Bearer $token");
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
