import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../api/models/UserListModel.dart';

class UserListPage extends StatefulWidget {
  RegionModel region;
  UserListPage(this.region, {super.key});

  @override
  State<StatefulWidget> createState() => _UserListPage();
}

class _UserListPage extends State<UserListPage> {
  String? search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).users,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.sp),
        child: FutureBuilder(
          future: getUsers(search),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      height: 20.sp,
                    ),
                    Text("${S.of(context).users}: " + (snapshot.data!.users.isEmpty ? S.of(context).not_founds : "")),
                    snapshot.data!.users.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data!.users.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  user(snapshot.data!.users[index]),
                                  SizedBox(
                                    height: 16.sp,
                                  )
                                ],
                              );
                            })
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 16.sp,
                    ),
                    Text("${S.of(context).cleaners}: " + (snapshot.data!.cleaners.isEmpty ? S.of(context).not_founds : "")),
                    snapshot.data!.cleaners.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data!.cleaners.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  user(snapshot.data!.cleaners[index]),
                                  SizedBox(
                                    height: 16.sp,
                                  )
                                ],
                              );
                            })
                        : SizedBox.shrink(),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(S.of(context).loading),
              );
            }
          },
        ),
      ),
    );
  }

  Future<UserListModel> getUsers(String? search) async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    String? token = await getToken();
    return client.getUsers("Bearer $token", widget.region.id!, search);
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
