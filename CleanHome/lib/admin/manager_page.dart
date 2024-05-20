import 'package:cleanhome/admin/city_controllpage.dart';
import 'package:cleanhome/admin/help_admin.dart';
import 'package:cleanhome/admin/userlist_page.dart';
import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/api/models/UserModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/Help.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme.dart';

class ManagerPage extends StatefulWidget {
  RegionModel? region;
  ManagerPage({this.region, super.key});

  @override
  State<ManagerPage> createState() => _ManagerPage();
}

class _ManagerPage extends State<ManagerPage> {
  int bottomTab = 0;
  void selectBottomTab(int index) {
    setState(() {
      bottomTab = index;
    });
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)), color: CustomTheme.primaryColors),
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
                                      const Icon(Icons.home_outlined),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      bottomTab == 0
                                          ? Text(
                                              S.of(context).main,
                                              style: const TextStyle(color: CustomTheme.primaryColors, fontWeight: FontWeight.bold),
                                            )
                                          : const SizedBox()
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
                                      Icon(Icons.person),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      bottomTab == 1 ? Text(S.of(context).users, style: TextStyle(color: CustomTheme.primaryColors, fontWeight: FontWeight.bold, fontSize: 12.sp)) : SizedBox()
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
                                      Icon(Icons.settings),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      bottomTab == 2 ? Text(S.of(context).settings, style: TextStyle(fontSize: 14.sp, color: CustomTheme.primaryColors, fontWeight: FontWeight.bold)) : SizedBox()
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
        return widget.region == null
            ? FutureBuilder<UserModel>(
                future: getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return NotificationListener<UpdateNotify>(
                        onNotification: (m) {
                          setState(() {});
                          return true;
                        },
                        child: RegionControll(
                          region: snapshot.data!.region!,
                          online: false,
                        ));
                  } else {
                    return const SizedBox();
                  }
                })
            : NotificationListener<UpdateNotify>(
                onNotification: (m) {
                  UpdateGlobalNotify().dispatch(context);
                  return true;
                },
                child: FutureBuilder(
                  future: RestClient(Dio()).regions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data!.length; i++) {
                        if (snapshot.data![i].id == widget.region!.id) {
                          return RegionControll(
                            region: snapshot.data![i]!,
                            online: false,
                          );
                        }
                      }
                      return SizedBox.shrink();
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ));
      case 1:
        return widget.region == null
            ? FutureBuilder<UserModel>(
                future: getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return UserListPage(snapshot.data!.region!);
                  } else {
                    return const SizedBox();
                  }
                })
            : UserListPage(widget.region!);
      case 2:
        return widget.region == null ? Help() : HelpAdmin(widget.region!);

      default:
        return const SizedBox();
    }
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}

class UpdateGlobalNotify extends Notification {
  UpdateGlobalNotify();
}
