import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:namer_app/component/textfield/search_textfield.dart';
import 'package:namer_app/config/color.dart';
import 'package:namer_app/config/themes.dart';
import 'package:namer_app/pages/sap/sap_controller.dart';

class SapPage extends StatelessWidget {
  const SapPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final SapController controller = Get.put(SapController());
    return Container(
      height: 280,
      child: Obx(() {
        return Row(
          children: [
            buildTableList(controller.beforeTableList,
                controller.selectedBeforeTableIndex, controller),
            buildButtonColumn(controller),
            buildTableList(controller.afterTableList,
                controller.selectedAfterTableIndex, controller,
                isAfter: true),
          ],
        );
      }),
    );
  }

  Widget buildTableList(
      RxList<String> tableList, RxInt selectedIndex, SapController controller,
      {bool isAfter = false}) {
    return Container(
      width: 300,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAfter ? '포함 테이블' : '테이블 검색',
            style: Themes.light.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          if (!isAfter)
            SizedBox(
              height: 38,
              child: SearchTextField(
                hintText: "테이블 검색",
                onSubmitted: controller.CallTableList,
                onPressed: controller.CallTableList,
              ),
            ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 200,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: borderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ListView.builder(
                itemCount: tableList.length,
                itemBuilder: (context, index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (isAfter) {
                          controller.selectedAfterTableIndex.value = index;
                        } else {
                          controller.selectedBeforeTableIndex.value = index;
                        }
                      },
                      child: Obx(
                        () {
                          return Container(
                            width: double.infinity,
                            color: selectedIndex.value == index
                                ? grayLight
                                : Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              tableList[index],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonColumn(SapController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70),
            buildButton(
              onTap: controller.RightButtonClicked,
              iconAsset: 'assets/icons/MdOutlineArrowDropDownCircle.svg',
              angle: pi,
              size: 24,
            ),
            buildButton(
              onTap: controller.LeftButtonClicked,
              iconAsset: 'assets/icons/MdOutlineArrowDropDownCircle.svg',
              size: 24,
            ),
            SizedBox(height: 20),
            buildButton(
              onTap: controller.DoubleRightButtonClicked,
              iconAsset: 'assets/icons/MdDoubleArrow.svg',
              angle: pi,
              size: 20,
            ),
            SizedBox(height: 3),
            buildButton(
              onTap: controller.DoubleLeftButtonClicked,
              iconAsset: 'assets/icons/MdDoubleArrow.svg',
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      {VoidCallback? onTap,
      String? iconAsset,
      double angle = 0,
      double size = 20}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Transform.rotate(
          angle: angle,
          child: SvgPicture.asset(
            iconAsset!,
            height: size,
            width: size,
          ),
        ),
      ),
    );
  }
}
