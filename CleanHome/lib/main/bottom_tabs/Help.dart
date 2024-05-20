import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../block/login_bloc.dart';

class Help extends StatefulWidget {
  Help({super.key});

  @override
  State<StatefulWidget> createState() => _Help();
}

class _Help extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: CustomTheme.primaryColors,
                        side: BorderSide.none),
                    onPressed: () async {
                      print("Logout process");
                      GlobalWidgets.logout(context);
                    },
                    child: Ink(
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(S.of(context).logout, style: TextStyle(color: Colors.white)),
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
                        backgroundColor: Colors.redAccent,
                        side: BorderSide.none),
                    onPressed: () async {
                      Dio dio = Dio();
                      RestClient client = RestClient(dio);
                      String? token = await getToken();
                      client.deleteUser("Bearer $token", null).then((value) {
                        final loginBloc = BlocProvider.of<LoginBloc>(context);
                        FirebaseAuth.instance.signOut();
                        loginBloc.add(LoginChangeStatusEvent(false));
                      });
                    },
                    child: Ink(
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(S.of(context).delete_account, style: TextStyle(color: Colors.white)),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
