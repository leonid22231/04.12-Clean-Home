import 'package:cleanhome/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class Rewards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Rewards();
  }
}

class _Rewards extends State<Rewards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(S.of(context).bonus)],
    );
  }
}
