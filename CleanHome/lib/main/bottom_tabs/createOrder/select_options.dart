import 'package:cleanhome/api/models/OptionModel.dart';
import 'package:cleanhome/entities/OrderEntity.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/main/bottom_tabs/createOrder/addresses/select_address.dart';
import 'package:cleanhome/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectOptions extends StatefulWidget {
  OrderEntity order;
  final List<OptionModel> options;
  final List<OptionModel>? selectedOptions;
  SelectOptions(this.order, this.options, this.selectedOptions, {super.key});
  @override
  State<StatefulWidget> createState() {
    return _SelectOptions();
  }
}

class _SelectOptions extends State<SelectOptions> {
  double addPrice = 0;
  List<OptionModel> option = [];
  @override
  Widget build(BuildContext context) {
    OrderEntity order = widget.order;
    order.setOptions(option);
    if (widget.selectedOptions != null && widget.selectedOptions!.isNotEmpty) {
      option = widget.selectedOptions!;
    }
    List<OptionModel> options = widget.options;
    List<bool> selected = [];
    options.map((e) => selected.add(false)).toList();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.of(context).additional,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(22.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).dop,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(
                  height: 16.sp,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        print(index);
                        return Column(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelect(options[index])) {
                                        option.remove(options[index]);
                                      } else {
                                        option.add(options[index]);
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: isSelect(options[index]) ? CustomTheme.primaryColors : Color(0xffF9F9F9), borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.water_drop_sharp,
                                            color: isSelect(options[index]) ? Colors.white : CustomTheme.primaryColors,
                                            size: 20.sp,
                                          ),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    options[index].name,
                                                    style: TextStyle(fontSize: 16.sp, color: isSelect(options[index]) ? Colors.white : Colors.black),
                                                  ),
                                                  Text(
                                                    "${options[index].price} ₸",
                                                    style: TextStyle(fontSize: 14.sp, color: isSelect(options[index]) ? Colors.white : Colors.black),
                                                  )
                                                ],
                                              )),
                                          Checkbox(
                                              side: BorderSide(color: Color(0xffAEAEB2), width: 1),
                                              shape: CircleBorder(),
                                              value: isSelect(options[index]),
                                              onChanged: (_) {
                                                setState(() {
                                                  if (_!) {
                                                    setState(() {
                                                      option.add(options[index]);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      option.remove(options[index]);
                                                    });
                                                  }
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                options[index].description != null && options[index].description!.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(color: Color(0xffF3F5FB), borderRadius: BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: EdgeInsets.all(18.sp),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/info.svg",
                                                height: 18.sp,
                                                width: 18.sp,
                                              ),
                                              SizedBox(
                                                width: 14.sp,
                                              ),
                                              Text(
                                                "${options[index].description}",
                                                style: TextStyle(fontSize: 16.sp, color: Color(0xff6E6F79)),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                            SizedBox(
                              height: 22.sp,
                            )
                          ],
                        );
                      }),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: CustomTheme.primaryColors,
                            side: BorderSide.none),
                        onPressed: () {
                          Navigator.of(context).pop(option);
                        },
                        child: Ink(
                          width: double.maxFinite,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(S.of(context).l, style: TextStyle(color: Colors.white)),
                          ),
                        )))
              ],
            ),
          ),
        ));
  }

  bool isSelect(OptionModel optionModel) {
    for (int i = 0; i < option.length; i++) {
      if (option[i] == optionModel) {
        return true;
      }
    }
    return false;
  }
}
