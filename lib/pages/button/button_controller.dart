import 'package:get/get.dart';

class ButtonController extends GetxController {
  RxList<String> checkBoxList = [
    "Ac",
    "Fuel Sensor",
    "Power",
    "Panic",
    "Camera",
    "Relay",
    "Other1",
    "Other2",
    "Other3",
    "Other4",
    "Other5",
    "Other6",
    "Duty Buttonddddddddddddd3",
  ].obs;
  RxList<String> singleCheckBoxList = [
    "1",
    "2",
    "3",
    "4",
    "5",
  ].obs;

  RxList<String> selectedCheckBox = RxList<String>();
  RxList<String> radioList = RxList<String>([
    "Radio 1",
    "Radio 2",
  ]);
  RxString selectedRadio = RxString("");
  RxString selectedSingleCheckBox = RxString("");

  @override
  void onInit() {
    super.onInit();
    if (checkBoxList.isNotEmpty) {
      checkBoxList.insert(0, 'ALL');
    }
    selectedSingleCheckBox.value = singleCheckBoxList[0];
    selectedRadio.value = radioList[0];
    // selectedCheckBox
    //     .addAll(List.generate(checkBoxList.length, (index) => false));
  }
}
