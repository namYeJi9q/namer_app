import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_words/english_words.dart';
import 'package:namer_app/pages/button/button.dart';
import 'package:namer_app/pages/datetime/datetime.dart';
import 'package:namer_app/pages/design/design.dart';
import 'package:namer_app/pages/lounge/lounge.dart';
import 'package:namer_app/pages/new_datetime/newdatetime.dart';
import 'package:namer_app/pages/population/population.dart';
import 'package:namer_app/pages/sampling/sampling.dart';
import 'package:namer_app/pages/sap/sap.dart';
import 'package:namer_app/pages/shimmer/news_page.dart';
import 'package:namer_app/pages/table/table.dart';
import 'package:namer_app/pages/textfield/textfield.dart';
import 'package:namer_app/pages/TextFiled/TextFiled.dart';
import 'nav_model.dart';
import 'pages/dashboard/dashboard.dart';

class MyController extends GetxController {
  static MyController get to => Get.find<MyController>();

  Rx<WordPair> current = WordPair.random().obs;
  RxList<WordPair> favorites = <WordPair>[].obs;

  Rx<Widget> currentWidget = Container(child: DashboardPage()).obs;
  Rx<Widget> currentDetail = Container().obs;

  late Rx<Widget> currentPost;
  Rx<String> currentMenu = "".obs;

  RxList navList = RxList();

  RxBool isAllClosed = true.obs;

  @override
  void onInit() {
    setNav();
    super.onInit();
  }

  void setNav() {
    navList = [
      Menu(name: "Dashboard", page: DashboardPage(), depth: 0),
      Menu(
        name: "PLC",
        depth: 0,
        subMenu: [
          Menu(name: "Population", page: PopulationPage(), depth: 1),
          Menu(name: "Sampling", depth: 1, subMenu: [
            Menu(name: "구매단가", page: SamplingPage(), depth: 2),
            Menu(name: "BOM", page: SamplingPage(), depth: 2),
            Menu(name: "거래처", page: SamplingPage(), depth: 2),
          ]),
        ],
      ),
      Menu(name: "Lounge", page: LoungePage(), depth: 0),
      Menu(name: "Table", page: TablePage(), depth: 0),
      Menu(name: "TextField", page: TextFieldPage(), depth: 0),
      Menu(name: "DateTime", page: DateTimePage(), depth: 0),
      Menu(name: "New DateTime", page: NewDateTimePage(), depth: 0),
      Menu(name: "Shimmer", page: NewsPage(), depth: 0),
      Menu(name: "Design", page: DesignPage(), depth: 0),
      Menu(name: "TextFieed", page: TextFiledPage(), depth: 0),
      Menu(name: "Button", page: ButtonPage(), depth: 0),
      Menu(name: "SAP", page: SapPage(), depth: 0),
      // Menu(name: "Checkbox", page: CheckBoxPage(), depth: 0),
    ].obs;
  }

  void changePage(Menu menu) {
    currentWidget.value = Container(child: menu.page);
    currentMenu.value = menu.name;
  }

  void changeDetail(Widget widget) {
    currentDetail.value = Container(child: widget);
  }

  void getNext() {
    current.value = WordPair.random();
  }

  void toggleFavorite() {
    if (favorites.contains(current.value)) {
      favorites.remove(current.value);
    } else {
      favorites.add(current.value);
    }
  }
}
