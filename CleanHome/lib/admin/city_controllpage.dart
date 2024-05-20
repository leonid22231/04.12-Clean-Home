import 'dart:ffi';

import 'package:cleanhome/admin/manager_page.dart';
import 'package:cleanhome/admin/options_edit.dart';
import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegionControll extends StatefulWidget {
  RegionModel region;
  bool online;
  RegionControll({required this.region, required this.online, super.key});
  @override
  State<StatefulWidget> createState() => _RegionControll();
}

class _RegionControll extends State<RegionControll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.region.name!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.sp),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height - (MediaQuery.of(context).padding.top + kToolbarHeight + 100),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).main_info,
                      style: TextStyle(color: Color(0xff6E6F79), fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          _showSimpleDialog(widget.region.priceRoom.toString(), widget.region.priceBathroom.toString(), widget.region.priceSize.toString());
                        },
                        icon: Icon(
                          Icons.edit,
                          color: CustomTheme.primaryColors,
                        ))
                  ],
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).price_room),
                    Text(
                      "${widget.region.priceRoom} ₸",
                      style: TextStyle(color: CustomTheme.primaryColors),
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).price_wash),
                    Text(
                      "${widget.region.priceBathroom} ₸",
                      style: TextStyle(color: CustomTheme.primaryColors),
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).price_1m),
                    Text(
                      "${widget.region.priceSize} ₸",
                      style: TextStyle(color: CustomTheme.primaryColors),
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 12.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).additional,
                      style: TextStyle(color: Color(0xff6E6F79), fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OptionsEdit(
                                        region: widget.region,
                                      ))).then((value) {
                            setState(() {
                              UpdateGlobalNotify().dispatch(context);
                            });
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: CustomTheme.primaryColors,
                        ))
                  ],
                ),
                SizedBox(
                  height: 16.sp,
                ),
                widget.region.options.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: widget.region.options.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Color(0xffF9F9F9), borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.water_drop_sharp,
                                            color: CustomTheme.primaryColors,
                                            size: 20.sp,
                                          ),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    widget.region.options[index].name,
                                                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                                                  ),
                                                  Text(
                                                    "${widget.region.options[index].price} ₸",
                                                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  widget.region.options[index].description != null && widget.region.options[index].description!.isNotEmpty
                                      ? Container(
                                          decoration: BoxDecoration(color: Color(0xffF3F5FB), borderRadius: BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: EdgeInsets.all(18.sp),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/info.svg",
                                                  height: 18.sp,
                                                  width: 18.sp,
                                                ),
                                                SizedBox(
                                                  width: 14.sp,
                                                ),
                                                Text(
                                                  "${widget.region.options[index].description}",
                                                  style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink()
                                ],
                              ),
                              SizedBox(
                                height: 22.sp,
                              )
                            ],
                          );
                        })
                    : Text(
                        S.of(context).option_not_found,
                        style: TextStyle(color: CustomTheme.primaryColors),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSimpleDialog(String a, b, c) {
    showDialog(
        context: context,
        builder: (context) {
          String? priceRoom = a;
          String? priceBathroom = b;
          String? priceSize = c;
          return SimpleDialog(
            title: Text('Редактировать'),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: priceRoom,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: S.of(context).price_room,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        priceRoom = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: priceBathroom,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: S.of(context).price_room,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        priceBathroom = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: priceSize,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: S.of(context).price_1m,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        priceSize = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String? token = await getToken();
                        client.editRegion("Bearer $token", widget.region.id!, double.parse(priceRoom!), double.parse(priceBathroom!), double.parse(priceSize!)).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(S.of(context).add),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }).then((value) {
      setState(() {
        UpdateNotify().dispatch(context);
      });
    });
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}

class UpdateNotify extends Notification {
  UpdateNotify();
}
