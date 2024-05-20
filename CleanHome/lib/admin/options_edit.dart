import 'package:cleanhome/admin/city_controllpage.dart';
import 'package:cleanhome/admin/option_add.dart';
import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

import '../theme.dart';

class OptionsEdit extends StatefulWidget {
  RegionModel region;
  OptionsEdit({required this.region, super.key});

  @override
  State<StatefulWidget> createState() => _OptionsEdit();
}

class _OptionsEdit extends State<OptionsEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).additional_options, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            Container(
              height: 70.h,
              width: double.infinity,
              child: FutureBuilder(
                future: getOptions(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Dismissible(
                                    key: Key(snapshot.data![index].id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) async {
                                      if (_ == DismissDirection.endToStart) {
                                        Dio dio = Dio();
                                        RestClient client = RestClient(dio);
                                        String? token = await getToken();
                                        client.deleteOption("Bearer $token", widget.region.id!, snapshot.data![index].id).then((value) {
                                          if (value.isNotEmpty) {
                                            toastification.show(context: context, title: Text(value), style: ToastificationStyle.flatColored, type: ToastificationType.error);
                                          }
                                          setState(() {});
                                        });
                                      }
                                    },
                                    background: Container(
                                      color: Colors.redAccent,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 15.sp),
                                          child: Icon(Icons.delete_forever),
                                        ),
                                      ),
                                    ),
                                    child: Column(
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
                                                              snapshot.data![index].name,
                                                              style: TextStyle(fontSize: 16.sp, color: Colors.black),
                                                            ),
                                                            Text(
                                                              "${snapshot.data![index].price} ₸",
                                                              style: TextStyle(fontSize: 14.sp, color: Colors.black),
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            snapshot.data![index].description != null && snapshot.data![index].description!.isNotEmpty
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
                                                            "${snapshot.data![index].description}",
                                                            style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink()
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 22.sp,
                                )
                              ],
                            );
                          });
                    } else {
                      return Text(S.of(context).op_not_found);
                    }
                  } else {
                    return Text(S.of(context).loading);
                  }
                },
              ),
            ),
            Spacer(),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: CustomTheme.primaryColors)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OptionAdd(region: widget.region))).then((value) {
                    setState(() {});
                  });
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).add_new_option, style: const TextStyle(color: CustomTheme.primaryColors)),
                  ),
                )),
            SizedBox(
              height: 15.sp,
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: CustomTheme.primaryColors,
                    side: BorderSide.none),
                onPressed: () async {
                  UpdateNotify().dispatch(context);
                  Navigator.pop(context);
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).save_changes, style: const TextStyle(color: Colors.white)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<List<OptionModel>> getOptions() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    String? token = await getToken();
    return client.getOptions("Bearer $token", widget.region.id!);
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
