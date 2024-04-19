import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/component/accordion.dart';
import 'package:namer_app/component/button/outline_button.dart';
import 'package:namer_app/component/checkbox/multi_checkbox.dart';
import 'package:namer_app/component/checkbox/radio.dart';
import 'package:namer_app/component/detail_sheet.dart';
import 'package:namer_app/component/filter/filter-button/filter_button.dart';
import 'package:namer_app/component/filter/filter-frame/filter_frame.dart';
import 'package:namer_app/component/filter/filter-row/filter_row.dart';
import 'package:namer_app/component/frame.dart';
import 'package:namer_app/component/table/basic-table/basic_table.dart';
import 'package:namer_app/component/toast.dart';
import 'package:namer_app/controller/detailContainer.dart';
import 'package:namer_app/main_controller.dart';
import 'package:namer_app/pages/Dropdown/DropdownPage.dart';
import 'package:namer_app/pages/button/button_controller.dart';
import 'package:namer_app/pages/population/detail/main.dart';
import 'package:namer_app/pages/population/population_controller.dart';
import 'package:namer_app/pages/table/table.dart';

class PopulationPage extends StatelessWidget {
  final ButtonController btn_controller = Get.put(ButtonController());
  final DetailController detail_controller = Get.find<DetailController>();
  final PopulationController controller = Get.put(PopulationController());
  PopulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FrameWidget(
        title: 'PLC/${MyController.to.currentMenu.value}',
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
                width: Get.width,
                child: Text(
                  'Population',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              FilterFrame(children: [
                FilterRow(
                  title: "DBMS Server",
                  child: MultiCheckBoxPage(
                      checkBoxList: btn_controller.checkBoxList,
                      selectedCheckBox: btn_controller.selectedCheckBox),
                ),
                FilterRow(
                  title: "Type",
                  child: RadioPage(
                    radioList: btn_controller.radioList,
                    selectedRadio: btn_controller.selectedRadio,
                  ),
                ),
                FilterRow(
                  title: btn_controller.title,
                  child: MultiCheckBoxPage(
                    checkBoxList: btn_controller.checkBoxList,
                    selectedCheckBox: btn_controller.selectedCheckBox,
                  ),
                ),
                Accordion(),
                FilterButton(children: [
                  DropdownMenuPage(list: ['10개', '30개', '50개', '100개']),
                  ButtonWidget("초기화", () {}).blue(),
                  ButtonWidget("조회", () {}).blue(),
                  ButtonWidget("XLSX", () {
                    ToastWidget("다시 시도해주세요.").green();
                  }).green(),
                ])
              ]),
              SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ButtonWidget('로그 합치기', () {
                  detail_controller.pageName.value = 'select';
                  DetailSheet(
                    child: PopulationDetailWidget(),
                  );
                }).blue(),
              ]),
              BasicTable(
                header: controller.basicTableDataHeader,
                data: controller.basicTableData,
                width: controller.basicTableDataWidth,
                detail: (int index) {
                  controller.rowClick(index);
                  detail_controller.pageName.value = 'log';
                  print('here');
                  DetailSheet(
                    child: PopulationDetailWidget(),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
