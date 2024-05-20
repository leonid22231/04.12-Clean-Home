import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/Cleaners.dart';
import 'package:cleanhome/main/bottom_tabs/Help.dart';
import 'package:cleanhome/main/bottom_tabs/Orders.dart';
import 'package:cleanhome/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _Mainpage();
}

class _Mainpage extends State<Mainpage> {
  Future<UserModel>? userInfo;

  int bottomTab = 0;
  void selectBottomTab(int index) {
    setState(() {
      bottomTab = index;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          getCurrentPage(bottomTab),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  canvasColor: CustomTheme.primaryColors,
                ),
                child: Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)), color: CustomTheme.primaryColors),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: BottomNavigationBar(
                        elevation: 0,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        backgroundColor: CustomTheme.primaryColors,
                        type: BottomNavigationBarType.fixed,
                        items: [
                          BottomNavigationBarItem(
                              icon: Container(
                                decoration: BoxDecoration(color: bottomTab == 0 ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.home_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      bottomTab == 0
                                          ? Text(
                                              S.of(context).main,
                                              style: TextStyle(color: CustomTheme.primaryColors, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              label: ""),
                          BottomNavigationBarItem(
                              icon: Container(
                                decoration: BoxDecoration(color: bottomTab == 1 ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_cart_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      bottomTab == 1 ? Text(S.of(context).orders, style: TextStyle(color: CustomTheme.primaryColors, fontSize: 14.sp, fontWeight: FontWeight.bold)) : SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              label: ""),
                          BottomNavigationBarItem(
                              icon: Container(
                                decoration: BoxDecoration(color: bottomTab == 2 ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      bottomTab == 2 ? Text(S.of(context).settings, style: TextStyle(color: CustomTheme.primaryColors, fontSize: 14.sp, fontWeight: FontWeight.bold)) : SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              label: ""),
                        ],
                        currentIndex: bottomTab,
                        selectedItemColor: CustomTheme.primaryColors,
                        unselectedItemColor: Colors.white,
                        onTap: selectBottomTab,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future<UserModel> getUserInfo() async {
    Dio dio = Dio();
    final client = RestClient(dio);

    String? token = await getToken();

    UserModel userModel = await client.userInfo("Bearer $token");

    return userModel;
  }

  Widget getCurrentPage(int index) {
    switch (index) {
      case 0:
        return FutureBuilder<UserModel>(
            future: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Orders(snapshot.data!);
              } else {
                return const SizedBox();
              }
            });
      case 1:
        return FutureBuilder<UserModel>(
            future: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Cleaners(snapshot.data!);
              } else {
                return const SizedBox();
              }
            });
      case 2:
        return Help();
      default:
        return const SizedBox();
    }
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
