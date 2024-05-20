import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/block/login_bloc.dart';
import 'package:cleanhome/entities/enums/Role.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/login/code_enter.dart';
import 'package:cleanhome/login/location_select.dart';
import 'package:cleanhome/login/number_enter.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  String currentPage = "location";
  String? allNumber;
  Role? role;
  String? autId;
  RegionModel? selectedRegion;
  @override
  Widget build(BuildContext context) {
    String? number;
    String? dialCode = "+7";
    return Scaffold(
        appBar: AppBar(
          leading: currentPage == "main"
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      currentPage = "location";
                    });
                  },
                )
              : currentPage == "code"
                  ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          currentPage = "main";
                        });
                      },
                    )
                  : SizedBox(),
          centerTitle: true,
          title: currentPage == "location"
              ? Text(
                  S.of(context).enter_city,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                )
              : SizedBox(),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getCurrentPage(currentPage),
              _getButton(currentPage),
            ],
          ),
        )));
  }

  Widget _getCurrentPage(String page) {
    switch (page) {
      case "location":
        {
          return NotificationListener<LocationSelected>(
            child: LocationSelect(),
            onNotification: (n) {
              selectedRegion = n.region;
              return true;
            },
          );
        }
      case "main":
        {
          return NotificationListener<NumberChange>(
            child: NumberEnter(),
            onNotification: (n) {
              allNumber = n.fullNum;
              role = n.role;
              return true;
            },
          );
        }
      case "code":
        {
          return NotificationListener<CodeFinish>(
            child: CodeEnter(
              number: allNumber!,
            ),
            onNotification: (n) {
              String code = n.code;
              FirebaseAuth auth = FirebaseAuth.instance;
              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: autId!, smsCode: code);
              Dio dio = Dio();
              RestClient client = RestClient(dio);
              auth.signInWithCredential(credential).then((value) async {
                await GlobalWidgets.getToken().then((value) async {
                  String? token = await FirebaseMessaging.instance.getToken();
                  await client.login("Bearer $value", role!.name, selectedRegion!.id!, token!).then((value) async {
                    final loginBloc = BlocProvider.of<LoginBloc>(context);
                    loginBloc.add(LoginChangeStatusEvent(true));
                  }).onError((error, stackTrace) async {
                    print(error);
                    FirebaseAuth.instance.signOut();
                    setState(() {
                      currentPage = "location";
                    });
                  });
                });
              });
              return true;
            },
          );
        }
      default:
        {
          return SizedBox();
        }
    }
  }

  Widget _getButton(String page) {
    switch (page) {
      case "location":
        {
          return SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                if (selectedRegion != null) {
                  setState(() {
                    currentPage = "main";
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(S.of(context).next),
              ),
            ),
          );
        }
      case "main":
        {
          return SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                print("Number " + allNumber!);
                FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: allNumber,
                    verificationCompleted: (PhoneAuthCredential credential) async {},
                    verificationFailed: (FirebaseAuthException e) {
                      print("Failed " + e.toString());
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      print("Code sended $verificationId , $resendToken");
                      autId = verificationId;
                      setState(() {
                        currentPage = "code";
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(S.of(context).send_code),
              ),
            ),
          );
        }
      default:
        return SizedBox();
    }
  }
}

class NotifyUserLogin extends Notification {
  Role? role;
  bool login;
  NotifyUserLogin(this.role, this.login);
}
