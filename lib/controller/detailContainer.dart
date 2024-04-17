import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  RxString pageName = "population_post".obs;
  //???? 이걸 나눠야할지? 하나로 가야할지 하나로가면 좀 길어지고 가독성 문제가.
  RxString samplingPageName = "sampling_post".obs;
  Rx<Widget>? currentDetail;
  RxString text = "".obs;

  List<String> pageHistory = [];

  TextEditingController textController = TextEditingController();

  void changeDetailPage(String name) {
    print(pageName);
    pageHistory.add(pageName.value);
    pageName.value = name;
    print(pageName);
  }

  void goBack() {
    if (pageHistory.isNotEmpty) {
      pageName.value = pageHistory.removeLast();
      print(pageHistory);
    }
  }

  sampingDetailPage(String name) {
    samplingPageName.value = name;
  }
}