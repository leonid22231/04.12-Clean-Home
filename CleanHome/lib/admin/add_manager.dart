import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/UserModel.dart';

class AddManager extends StatefulWidget {
  RegionModel region;
  AddManager(this.region);

  @override
  State<StatefulWidget> createState() => _AddManager();
}

class _AddManager extends State<AddManager> {
  String? search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).select_manager,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            Text(S.of(context).select_user),
            SizedBox(
              height: 16.sp,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(hintText: S.of(context).search_number, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
            SizedBox(
              height: 16.sp,
            ),
            FutureBuilder(
                future: getUsers(search),
                builder: (context, snapshot) {
                  print("${snapshot.error}");
                  if (snapshot.hasData) {
                    return snapshot.data!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Dio dio = Dio();
                                      RestClient client = RestClient(dio);
                                      String? token = await getToken();
                                      client.addManager("Bearer $token", widget.region.id!, snapshot.data![index].id).then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: user(snapshot.data![index]),
                                  ),
                                  SizedBox(
                                    height: 16.sp,
                                  )
                                ],
                              );
                            })
                        : Text(S.of(context).not_found);
                  } else {
                    return Text(S.of(context).loading);
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<List<UserModel>> getUsers(String? search) async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    String? token = await getToken();
    return client.getAllUsers("Bearer $token", search);
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
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
}
