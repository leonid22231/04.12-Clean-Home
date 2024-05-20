import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/addresses/select_address.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/select_options.dart';
import 'package:cleanhome/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrder extends StatefulWidget {
  final RegionModel regionModel;
  const CreateOrder(this.regionModel, {super.key});

  @override
  State<CreateOrder> createState() => _CreateOrder();
}

class _CreateOrder extends State<CreateOrder> {
  int countRoom = 1;
  int countBathroom = 1;
  String? customPrice, size;
  List<OptionModel>? selectedOptions;
  int mode = 0;
  Widget empty() {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    double priceRoom = widget.regionModel.priceRoom;
    double priceBathroom = widget.regionModel.priceBathroom;
    double price = 0;
    if (size == null || size!.isEmpty) {
      price = 1000 + countRoom * priceRoom + countBathroom * priceBathroom;
    } else {
      price = 1000 + (double.parse(size!).round() * widget.regionModel.priceSize);
    }
    if (selectedOptions != null && selectedOptions!.isNotEmpty) {
      selectedOptions!.map((e) {
        price += e.price;
      }).toList();
    }
    int hour = 1 + countRoom + countBathroom;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).start_order,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: 100.h - (MediaQuery.of(context).padding.top + kToolbarHeight),
            child: Column(
              children: [
                Container(
                  height: mode == 0 ? 31.h : 15.h,
                  width: double.maxFinite,
                  color: const Color(0xffE2E5F4).withOpacity(0.4),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 22.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).kek,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        mode == 0
                            ? Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            S.of(context).rooms,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          Text(
                                            "${S.of(context).price_one_room} ${widget.regionModel.priceRoom} ₸",
                                            style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: 30.w,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff0BB8E3).withOpacity(0.05)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 18.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 20.sp,
                                                width: 20.sp,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (countRoom > 1) {
                                                          countRoom--;
                                                        }
                                                      });
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: SvgPicture.asset(
                                                      "assets/minus.svg",
                                                      height: 20.sp,
                                                      width: 20.sp,
                                                    )),
                                              ),
                                              Text("${countRoom}"),
                                              SizedBox(
                                                height: 20.sp,
                                                width: 20.sp,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        countRoom++;
                                                      });
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: SvgPicture.asset(
                                                      "assets/plus.svg",
                                                      height: 20.sp,
                                                      width: 20.sp,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : empty(),
                        mode == 0
                            ? SizedBox(
                                height: 16.sp,
                              )
                            : empty(),
                        mode == 0
                            ? Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            S.of(context).kto,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          Text(
                                            "${S.of(context).price_one_kto} ${widget.regionModel.priceBathroom} ₸",
                                            style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: 30.w,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff0BB8E3).withOpacity(0.05)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 18.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 20.sp,
                                                width: 20.sp,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (countBathroom > 1) {
                                                          countBathroom--;
                                                        }
                                                      });
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: SvgPicture.asset(
                                                      "assets/minus.svg",
                                                      height: 20.sp,
                                                      width: 20.sp,
                                                    )),
                                              ),
                                              Text("${countBathroom}"),
                                              SizedBox(
                                                height: 20.sp,
                                                width: 20.sp,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        countBathroom++;
                                                      });
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: SvgPicture.asset(
                                                      "assets/plus.svg",
                                                      height: 20.sp,
                                                      width: 20.sp,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : empty(),
                        mode == 0
                            ? SizedBox(
                                height: 5.sp,
                              )
                            : empty(),
                        mode == 0
                            ? Align(
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).or,
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                                ),
                              )
                            : empty(),
                        mode == 0
                            ? SizedBox(
                                height: 5.sp,
                              )
                            : empty(),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).size,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Text(
                                      "${S.of(context).price_one_m} ${widget.regionModel.priceBathroom} ₸",
                                      style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 30.w,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff0BB8E3).withOpacity(0.05)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 14.sp),
                                    child: SizedBox(
                                      height: 3.h,
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == null || value.isEmpty) {
                                              mode = 0;
                                            } else {
                                              mode = 1;
                                              size = value;
                                            }
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        style: TextStyle(fontSize: 18.sp),
                                        decoration: InputDecoration(
                                          suffix: Text(S.of(context).kw_m),
                                          counterText: "",
                                          contentPadding: EdgeInsets.zero,
                                          isCollapsed: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 22.sp),
                    child: Column(
                      children: [
                        TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(14.sp),
                              fillColor: Color(0xffF9F9F9),
                              filled: true,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              focusColor: Colors.black,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              hintText: S.of(context).promo,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.sp),
                                child: SvgPicture.asset(
                                  "assets/code.svg",
                                  height: 12.sp,
                                  width: 12.sp,
                                ),
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xffCBCBCB),
                              )),
                        ),
                        SizedBox(
                          height: 16.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            OrderEntity order = OrderEntity(priceRoom, priceBathroom, hour, widget.regionModel.priceSize, widget.regionModel);
                            order.countRoom = countRoom;
                            order.countBathroom = countBathroom;
                            if (size != null && size!.isNotEmpty) {
                              order.size = double.parse(size!);
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectOptions(order, widget.regionModel.options, selectedOptions))).then((value) {
                              setState(() {
                                selectedOptions = value;
                              });
                            });
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffF9F9F9)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 18.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.of(context).additional,
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                      Text(S.of(context).dop, style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)))
                                    ],
                                  ),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.arrow_forward_ios_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.sp,
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffF9F9F9)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 18.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${S.of(context).result}:",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Text(S.of(context).kto_price, style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)))
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${price} ₸",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.sp,
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffF9F9F9)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 18.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${S.of(context).or}:",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Text(S.of(context).price_, style: TextStyle(fontSize: 14.sp, color: Color(0xff6E6F79)))
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 15.w,
                                        height: 5.h,
                                        child: Center(
                                          child: TextFormField(
                                            onChanged: (value) {
                                              customPrice = value;
                                            },
                                            textAlign: TextAlign.center,
                                            maxLength: 5,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: 18.sp),
                                            scrollPadding: EdgeInsets.zero,
                                            decoration: InputDecoration(
                                              counterText: "",
                                              isCollapsed: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text("₸")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.all(22.sp),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: CustomTheme.primaryColors,
                            side: BorderSide.none),
                        onPressed: () {
                          OrderEntity order = OrderEntity(widget.regionModel.priceRoom, widget.regionModel.priceBathroom, countBathroom + countRoom, widget.regionModel.priceSize, widget.regionModel);
                          order.countRoom = countRoom;
                          order.countBathroom = countBathroom;
                          if (customPrice != null && customPrice!.isNotEmpty) {
                            order.customPrice = double.parse(customPrice!);
                          }
                          if (size != null && size!.isNotEmpty) {
                            order.size = double.parse(size!);
                          }
                          if (selectedOptions != null && selectedOptions!.isNotEmpty) {
                            order.setOptions(selectedOptions!);
                          } else {
                            List<OptionModel> options = [];
                            order.setOptions(options);
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectAddress(order, region: widget.regionModel)));
                        },
                        child: Ink(
                          width: double.maxFinite,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(S.of(context).next, style: TextStyle(color: Colors.white)),
                          ),
                        )))
              ],
            )),
      ),
    );
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
