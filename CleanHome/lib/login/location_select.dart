import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/api/models/RegionModel.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:searchable_listview/searchable_listview.dart';

class LocationSelect extends StatefulWidget {
  const LocationSelect({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LocationSelect();
  }
}

class _LocationSelect extends State<LocationSelect> {
  Future<List<RegionModel>>? regions;
  RegionModel? selectedRegion;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
          setState(() {
            if (selectedRegion != region) {
              selectedRegion = region;
              LocationSelected(selectedRegion!).dispatch(context);
            } else {
              selectedRegion = null;
            }
          });
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
        loadingWidget: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text('Загрузка городов...')
          ],
        ),
        emptyWidget: const SizedBox(),
        asyncListCallback: () async {
          regions = getRegions();
          return await getRegions();
        },
        asyncListFilter: (query, List<RegionModel> list) {
          return list.where((element) => element.name!.toLowerCase().contains(query.toLowerCase())).toList();
        },
      ),
    );
  }

  Future<List<RegionModel>> getRegions() async {
    Dio dio = Dio();
    final client = RestClient(dio);
    return await client.regions();
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
}

class LocationSelected extends Notification {
  final RegionModel region;
  LocationSelected(this.region);
}
