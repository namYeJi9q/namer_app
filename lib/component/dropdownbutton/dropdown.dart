import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/component/dropdownbutton/controller.dart';
import 'package:namer_app/config/color.dart';

const List<String> numberList = <String>['10개', '30개', '50개', '100개'];

class DropdownButtonWidget extends StatelessWidget {
  final List<String> list;
  DropdownButtonWidget({super.key, List<String>? list})
      : this.list = list ?? numberList;

  final DropdownController controller = DropdownController();
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: primaryMain, width: 1),
            borderRadius: BorderRadius.circular(4)),
        height: 28,
        width: 112,
        child: Obx(
          () => PopupMenuButton<String>(
            offset: Offset(0, 30),
            onSelected: (String value) {
              controller.changeValue(value);
            },
            itemBuilder: (BuildContext context) {
              return list.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                  ),
                );
              }).toList();
            },
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.dropdownValue.value == ""
                        ? list[0]
                        : controller.dropdownValue.value,
                    style: TextStyle(color: primaryMain),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: primaryMain,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
