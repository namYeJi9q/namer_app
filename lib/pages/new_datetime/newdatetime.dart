import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/config/color.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:namer_app/pages/new_datetime/newdatetime_controller.dart';

class NewDateTimePage extends StatefulWidget {
  NewDateTimePage({Key? key}) : super(key: key);

  @override
  State<NewDateTimePage> createState() => _NewDateTimePageState();
}

class _NewDateTimePageState extends State<NewDateTimePage> {
  final NewDateTimeController controller = Get.put(NewDateTimeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // StartTime Container
          _buildTimeContainer(
            controller.startDefaultValue,
            controller.selectedStartHour,
            controller.selectedStartMinute,
            controller.tempSelectedStartHour,
            controller.tempSelectedStartMinute,
            controller.selectedStartDateTime,
            true,
          ),
          const SizedBox(width: 10),
          Text("-"),
          const SizedBox(width: 10),
          // EndTime Container
          _buildTimeContainer(
            controller.endDefaultValue,
            controller.selectedEndHour,
            controller.selectedEndMinute,
            controller.tempSelectedEndHour,
            controller.tempSelectedEndMinute,
            controller.selectedEndDateTime,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeContainer(
    RxList<DateTime?> defaultValue,
    RxInt selectedHour,
    RxInt selectedMinute,
    RxInt tempSelectedHour,
    RxInt tempSelectedMinute,
    Rx<DateTime?> selectedDateTime,
    bool isStartTime,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Text(
                    _getValueText(
                      CalendarDatePicker2Type.single,
                      defaultValue,
                      selectedHour,
                      selectedMinute,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: borderColor,
                ),
                onPressed: () {
                  controller.isStart.value = isStartTime;
                  _showTimeDialog(context, isStartTime);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
    RxInt selectedHour,
    RxInt selectedMinute,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    // Add selected time to the displayed text
    valueText += ' ${selectedHour.value.toString().padLeft(2, '0')}:'
        '${selectedMinute.value.toString().padLeft(2, '0')}';

    return valueText;
  }

  void _showTimeDialog(BuildContext context, bool isStartTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: 500,
            height: 350,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: _buildDefaultSingleDatePickerWithValue(isStartTime),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _setTimeNumberValue(isStartTime),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (isStartTime) {
                  controller.selectedStartHour.value =
                      controller.tempSelectedStartHour.value;
                  controller.selectedStartMinute.value =
                      controller.tempSelectedStartMinute.value;
                  controller.startDefaultValue.value = [
                    controller.selectedStartDateTime.value
                  ].map((dateTime) => dateTime!).toList();
                } else {
                  controller.selectedEndHour.value =
                      controller.tempSelectedEndHour.value;
                  controller.selectedEndMinute.value =
                      controller.tempSelectedEndMinute.value;
                  controller.endDefaultValue.value = [
                    controller.selectedEndDateTime.value
                  ].map((dateTime) => dateTime!).toList();
                }
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue(bool isStartTime) {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: primaryMain,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: TextStyle(
        fontSize: 14,
        color: blackTextColor,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: TextStyle(
        fontSize: 14,
        color: blackTextColor,
      ),
      dayTextStyle: TextStyle(
        fontSize: 14,
        color: blackTextColor,
      ),
      disabledDayTextStyle: TextStyle(
        color: grayTextColor,
      ),
      selectableDayPredicate: (day) => true,
    );
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDatePicker2(
            config: config,
            value: isStartTime
                ? controller.startDefaultValue
                    .map((dateTime) => dateTime!)
                    .toList()
                : controller.endDefaultValue
                    .map((dateTime) => dateTime!)
                    .toList(),
            onValueChanged: (dates) => isStartTime
                ? controller.selectedStartDateTime.value =
                    dates.first ?? DateTime.now()
                : controller.selectedEndDateTime.value =
                    dates.first ?? DateTime.now(),
          ),
        ],
      ),
    );
  }

  Widget _setTimeNumberValue(bool isStartTime) {
    final RxInt tempSelectedHour = isStartTime
        ? controller.tempSelectedStartHour
        : controller.tempSelectedEndHour;
    final RxInt tempSelectedMinute = isStartTime
        ? controller.tempSelectedStartMinute
        : controller.tempSelectedEndMinute;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'HOUR',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 270,
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: List.generate(
                        24,
                        (index) {
                          final hour = index;
                          return SizedBox(
                            height: 38,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                if (isStartTime) {
                                  tempSelectedHour.value = hour;
                                } else {
                                  tempSelectedHour.value = hour;
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<CircleBorder>(
                                  CircleBorder(),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (isStartTime &&
                                        tempSelectedHour.value == hour) {
                                      return primaryMain;
                                    } else if (!isStartTime &&
                                        tempSelectedHour.value == hour) {
                                      return primaryMain;
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                              ),
                              child: Text(
                                '$hour',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isStartTime
                                      ? (tempSelectedHour.value == hour
                                          ? Colors.white
                                          : blackTextColor)
                                      : (tempSelectedHour.value == hour
                                          ? Colors.white
                                          : blackTextColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'MINUTE',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 270,
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: List.generate(
                        60,
                        (index) {
                          final minute = index;
                          return SizedBox(
                            height: 38,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                if (isStartTime) {
                                  tempSelectedMinute.value = minute;
                                } else {
                                  tempSelectedMinute.value = minute;
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<CircleBorder>(
                                  CircleBorder(),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (isStartTime &&
                                        tempSelectedMinute.value == minute) {
                                      return primaryMain;
                                    } else if (!isStartTime &&
                                        tempSelectedMinute.value == minute) {
                                      return primaryMain;
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                              ),
                              child: Text(
                                '$minute',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isStartTime
                                      ? (tempSelectedMinute.value == minute
                                          ? Colors.white
                                          : blackTextColor)
                                      : (tempSelectedMinute.value == minute
                                          ? Colors.white
                                          : blackTextColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
