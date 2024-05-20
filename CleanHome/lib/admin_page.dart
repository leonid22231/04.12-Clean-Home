import 'package:cleanhome/admin/manager_page.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'api/RestClient.dart';
import 'api/models/RegionModel.dart';

class AdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  Future<List<RegionModel>>? regions;
  RegionModel? selectedRegion;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).control_city,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.sp),
        child: Column(
          children: [
            SizedBox(
              height: 70.h,
              child: SearchableList<RegionModel>.async(
                builder: (list, index, item) {
                  return region(item);
                },
                onPaginate: () async {
                  regions = getRegions();
                },
                onRefresh: () async {
                  regions = getRegions();
                },
                onItemSelected: (region) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationListener<UpdateGlobalNotify>(
                              onNotification: (m) {
                                setState(() {});
                                return true;
                              },
                              child: ManagerPage(
                                region: region,
                              ))));
                },
                seperatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                style: TextStyle(color: Colors.white),
                searchTextController: _controller,
                defaultSuffixIconColor: CustomTheme.primaryColors,
                inputDecoration: InputDecoration(
                  counterStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  hoverColor: Colors.white,
                  contentPadding: EdgeInsets.all(12.sp),
                  focusColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: S.of(context).search_city,
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: null,
                  suffix: null,
                  suffixIconConstraints: null,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  fillColor: CustomTheme.primaryColors,
                  filled: true,
                  icon: null,
                  border: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                loadingWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(S.of(context).load_city)
                  ],
                ),
                emptyWidget: const SizedBox(),
                asyncListCallback: () async {
                  regions = getRegions();
                  return regions;
                },
                asyncListFilter: (query, List<RegionModel> list) {
                  return list.where((element) => element.name!.toLowerCase().contains(query.toLowerCase())).toList();
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
                onPressed: () async {
                  _showSimpleDialog();
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).add_city, style: const TextStyle(color: CustomTheme.primaryColors)),
                  ),
                )),
            SizedBox(
              height: 14.sp,
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: CustomTheme.primaryColors,
                    side: BorderSide.none),
                onPressed: () async {
                  GlobalWidgets.logout(context);
                },
                child: Ink(
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(S.of(context).exit, style: const TextStyle(color: Colors.white)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<List<RegionModel>> getRegions() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    return client.regions();
  }

  Widget region(RegionModel regionModel) {
    bool isChecked = false;
    if (selectedRegion != null && regionModel == selectedRegion) {
      isChecked = true;
    } else {
      isChecked = false;
    }
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xffF9F9F9)),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              activeColor: CustomTheme.primaryColors,
              side: BorderSide(color: CustomTheme.primaryColors),
              value: isChecked,
              onChanged: (_) {},
            ),
          ),
          Text(regionModel.name!)
        ],
      ),
    );
  }

  void _showSimpleDialog() {
    String? priceRoom, priceBathroom, name, priceSize;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(S.of(context).add_city),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: S.of(context).name,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: S.of(context).price_room,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        priceRoom = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: S.of(context).price_wash,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        priceBathroom = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: S.of(context).price_1m,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )),
                      onChanged: (value) {
                        priceSize = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String? token = await getToken();
                        client.createRegion("Bearer $token", name!, double.parse(priceRoom!), double.parse(priceBathroom!), double.parse(priceSize!)).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(S.of(context).add),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }).then((value) {
      setState(() {
        regions = getRegions();
      });
    });
  }

  Future<String?> getToken() async {
    IdTokenResult? token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return token?.token;
  }
}
