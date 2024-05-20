import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionAdd extends StatefulWidget {
  RegionModel region;
  OptionAdd({required this.region, super.key});

  @override
  State<StatefulWidget> createState() => _OptionAdd();
}

class _OptionAdd extends State<OptionAdd> {
  String? name, description, price;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).add_new_option,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.sp),
        child: Column(
          children: [
            Text(S.of(context).add_new_option_info),
            SizedBox(
              height: 16.sp,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: S.of(context).name, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              onChanged: (value) {
                name = value;
              },
            ),
            SizedBox(
              height: 16.sp,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: S.of(context).op_not_required, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              onChanged: (value) {
                description = value;
              },
            ),
            SizedBox(
              height: 16.sp,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: S.of(context).price, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              onChanged: (value) {
                price = value;
              },
            ),
            Spacer(),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: CustomTheme.primaryColors,
                    side: BorderSide.none),
                onPressed: () async {
                  Dio dio = Dio();
                  RestClient client = RestClient(dio);
                  String? token = await getToken();
                  client.addOption("Bearer $token", widget.region.id!, name!, description, double.parse(price!)).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).add, style: const TextStyle(color: Colors.white)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
