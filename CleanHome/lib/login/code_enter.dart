import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CodeEnter extends StatefulWidget {
  String number;

  CodeEnter({required this.number, super.key});

  @override
  State<StatefulWidget> createState() {
    return _CodeEnter();
  }
}

class _CodeEnter extends State<CodeEnter> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).enter_code,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.sp,
          ),
          Text(
            "${S.of(context).enter_code_} ${widget.number}.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Center(
              child: Pinput(
            length: 6,
            controller: pinController,
            obscuringWidget: Icon(
              Icons.close,
              color: CustomTheme.primaryColors,
            ),
            obscureText: true,
            autofocus: true,
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (value) {
              CodeFinish(value).dispatch(context);
            },
          )),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class CodeFinish extends Notification {
  final String code;
  CodeFinish(this.code);
}
