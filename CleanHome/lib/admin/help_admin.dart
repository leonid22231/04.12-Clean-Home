import 'package:cleanhome/admin/add_manager.dart';
import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/NewModel.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme.dart';

class HelpAdmin extends StatefulWidget {
  RegionModel region;
  HelpAdmin(this.region, {super.key});

  @override
  State<StatefulWidget> createState() => _HelpAdmin();
}

class _HelpAdmin extends State<HelpAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(bottom: 40.sp),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).managers,
                style: const TextStyle(color: CustomTheme.primaryColors),
              ),
              SizedBox(
                height: 16.sp,
              ),
              FutureBuilder(
                  future: getMenegers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return SizedBox(
                          height: 40.h,
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Dismissible(
                                        key: Key(snapshot.data![index].id),
                                        background: Container(
                                          color: Colors.redAccent,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 10.sp),
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (_) async {
                                          if (_ == DismissDirection.endToStart) {
                                            Dio dio = Dio();
                                            RestClient client = RestClient(dio);
                                            String? token = await getToken();
                                            client.deleteManager("Bearer $token", snapshot.data![index].id).then((value) {
                                              setState(() {});
                                            });
                                          }
                                        },
                                        child: user(snapshot.data![index])),
                                    SizedBox(
                                      height: 16.sp,
                                    )
                                  ],
                                );
                              }),
                        );
                      } else {
                        return Text(S.of(context).not_found);
                      }
                    } else {
                      return Text(S.of(context).loading);
                    }
                  }),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: CustomTheme.primaryColors)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddManager(widget.region))).then((value) {
                      setState(() {});
                    });
                  },
                  child: Ink(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).select_manager, style: const TextStyle(color: CustomTheme.primaryColors)),
                    ),
                  )),
              SizedBox(
                height: 16.sp,
              ),
              Text(
                S.of(context).news,
                style: TextStyle(color: CustomTheme.primaryColors),
              ),
              SizedBox(
                height: 16.sp,
              ),
              FutureBuilder(
                  future: getNewsRegion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return SizedBox(
                          height: 40.h,
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Dismissible(
                                        key: Key(snapshot.data![index].id),
                                        background: Container(
                                          color: Colors.redAccent,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 10.sp),
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (_) async {
                                          if (_ == DismissDirection.endToStart) {
                                            Dio dio = Dio();
                                            RestClient client = RestClient(dio);
                                            String? token = await getToken();
                                            //TODO: NEWS EDITOR
                                            client.deleteManager("Bearer $token", snapshot.data![index].id).then((value) {
                                              setState(() {});
                                            });
                                          }
                                        },
                                        child: SizedBox()),
                                    SizedBox(
                                      height: 16.sp,
                                    )
                                  ],
                                );
                              }),
                        );
                      } else {
                        return Text(S.of(context).not_found);
                      }
                    } else {
                      return Text(S.of(context).loading);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget user(UserModel userModel) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xffF9F9F9)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel.id,
              style: TextStyle(fontSize: 14.sp),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).number_phone,
                  style: TextStyle(fontSize: 16.sp),
                ),
                Text("${userModel.phoneNumber}", style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<UserModel>> getMenegers() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    String? token = await getToken();
    return client.getMenegers("Bearer $token", widget.region.id!);
  }

  Future<List<NewModel>> getNewsRegion() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    String? token = await getToken();
    return client.regionNews("Bearer $token", widget.region.id!);
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
