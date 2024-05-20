import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateAddress extends StatefulWidget {
  RegionModel region;

  CreateAddress(this.region, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateAddress();
  }
}

class _CreateAddress extends State<CreateAddress> {
  String street = "", house = "", frame = "", entrance = "", apartment = "", intercom = "", floor = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.of(context).add_address,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                enabled: false,
                initialValue: widget.region.name,
                decoration: InputDecoration(filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              ),
              SizedBox(
                height: 20.sp,
              ),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: S.of(context).street, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                        onChanged: (value) {
                          street = value;
                        },
                      )),
                  SizedBox(width: 10.sp),
                  Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: S.of(context).house, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                        onChanged: (value) {
                          house = value;
                        },
                      ))
                ],
              ),
              SizedBox(height: 20.sp),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    decoration: InputDecoration(hintText: S.of(context).str, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                    onChanged: (value) {
                      frame = value;
                    },
                  )),
                  SizedBox(width: 10.sp),
                  Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: S.of(context).pod, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                        onChanged: (value) {
                          entrance = value;
                        },
                      )),
                ],
              ),
              SizedBox(height: 20.sp),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    decoration: InputDecoration(hintText: S.of(context).kw, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                    onChanged: (value) {
                      apartment = value;
                    },
                  )),
                  SizedBox(width: 10.sp),
                  Flexible(
                      child: TextFormField(
                    decoration: InputDecoration(hintText: S.of(context).dom, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                    onChanged: (value) {
                      intercom = value;
                    },
                  )),
                ],
              ),
              SizedBox(height: 20.sp),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    decoration: InputDecoration(hintText: S.of(context).et, filled: true, fillColor: Color(0xffF9F9F9), contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 20.sp), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                    onChanged: (value) {
                      floor = value;
                    },
                  ))
                ],
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
                    final client = RestClient(dio);
                    String? token = await getToken();
                    await client.pushAddress("Bearer $token", street, house, frame, entrance, apartment, intercom, floor);
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Ink(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).add_address_, style: TextStyle(color: Colors.white)),
                    ),
                  ))
            ],
          ),
        ));
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}

class AddressCreated extends Notification {
  AddressCreated();
}
