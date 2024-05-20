import 'package:cleanhome/entities/enums/Role.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NumberEnter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NumberEnter();
  }
}

class _NumberEnter extends State<NumberEnter> {
  String? dialCode = "+7";
  String number = "";
  int _tabTextIndexSelected = 0;
  bool checked = false;
  List<String> _listTextTabToggle = [];
  @override
  Widget build(BuildContext context) {
    _listTextTabToggle = [S.of(context).user, S.of(context).cleaner];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).number_phone,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15.sp,
        ),
        Text(
          S.of(context).enter_number_phone,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.sp),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 28.5.sp,
            color: Color(0xffF9F9F9),
            child: CountryCodePicker(
              padding: EdgeInsets.zero,
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: Color(0xffF9F9F9),
              onChanged: (_) {
                dialCode = _.dialCode!;
              },
              initialSelection: dialCode,
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
          Expanded(
              child: TextFormField(
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(contentPadding: EdgeInsets.all(12), fillColor: Color(0xffF9F9F9), filled: true, isDense: true, hintText: S.of(context).number_phone, border: OutlineInputBorder(borderSide: BorderSide.none)),
            onChanged: (tempNumber) {
              number = tempNumber;
              print("Role ${roleFromIndex(_tabTextIndexSelected)}");
              NumberChange(dialCode! + number, roleFromIndex(_tabTextIndexSelected)).dispatch(context);
            },
          )),
        ]),
        SizedBox(height: 20.sp),
        FlutterToggleTab(
          width: 90,
          borderRadius: 8,
          height: 50,
          selectedIndex: _tabTextIndexSelected,
          selectedBackgroundColors: [CustomTheme.primaryColors],
          selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          unSelectedTextStyle: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
          labels: _listTextTabToggle,
          selectedLabelIndex: (index) {
            setState(() {
              _tabTextIndexSelected = index;
            });
            NumberChange(dialCode! + number, roleFromIndex(_tabTextIndexSelected)).dispatch(context);
          },
          isScroll: true,
        ),
        SizedBox(
          height: 16.sp,
        ),
        Row(
          children: [
            Checkbox(
                value: checked,
                onChanged: (_) {
                  setState(() {
                    checked = !checked;
                  });
                }),
            Row(
              children: [
                Text(
                  S.of(context).confirm,
                  style: TextStyle(fontSize: 14.sp),
                ),
                TextButton(onPressed: () {}, child: Text(S.of(context).prefs, style: TextStyle(fontSize: 14.sp)))
              ],
            )
          ],
        ),
        SizedBox(
          height: 30.sp,
        ),
      ],
    );
  }

  Role roleFromIndex(int index) {
    switch (index) {
      case 0:
        return Role.USER;
      case 1:
        return Role.CLEANER;
    }
    return Role.USER;
  }
}

class NumberChange extends Notification {
  final String fullNum;
  Role role;
  NumberChange(this.fullNum, this.role);
}
