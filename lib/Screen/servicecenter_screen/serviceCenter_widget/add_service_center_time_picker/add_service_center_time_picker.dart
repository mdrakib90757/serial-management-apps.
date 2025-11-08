import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:SerialMan/utils/color.dart';

class CustomFieldWithTabs extends StatefulWidget {
  final TabController tabController;
  final TextEditingController textController;
  final ValueChanged<Time?> onStartTimeChanged;
  final ValueChanged<Time?> onEndTimeChanged;
  final Time? initialStartTime;
  final Time? initialEndTime;

  const CustomFieldWithTabs({
    super.key,
    required this.tabController,
    required this.textController,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    this.initialStartTime,
    this.initialEndTime,
  });
  @override
  State<CustomFieldWithTabs> createState() => _CustomFieldWithTabsState();
}

class _CustomFieldWithTabsState extends State<CustomFieldWithTabs> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Time? _startTime;
  Time? _endTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _onTabTapped(int index) {
    Time initialTime = index == 0
        ? (_startTime ??
              Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute))
        : (_endTime ??
              Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute));

    Navigator.of(context).push(
      showPicker(
        context: context,
        value: initialTime,
        onChange: (newTime) {
          setState(() {
            if (index == 0) {
              _startTime = newTime;
              widget.onStartTimeChanged(_startTime);
            } else {
              _endTime = newTime;
              widget.onEndTimeChanged(_endTime);
            }
          });
        },
        accentColor: AppColor().primariColor,
        okText: "OK",
        cancelText: "Cancel",
        is24HrFormat: false,
        iosStylePicker: false,
        okStyle: TextStyle(
          color: AppColor().primariColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        cancelStyle: TextStyle(
          color: AppColor().primariColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String startTimeText = _startTime != null
        ? DateFormat(
            'hh:mm a',
          ).format(DateTime(2023, 1, 1, _startTime!.hour, _startTime!.minute))
        : 'Start Time';
    final String endTimeText = _endTime != null
        ? DateFormat(
            'hh:mm a',
          ).format(DateTime(2023, 1, 1, _endTime!.hour, _endTime!.minute))
        : 'End time';

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Hour",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400, width: 1.0),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TabBar(
              controller: widget.tabController,
              onTap: _onTabTapped,
              tabs: [
                Tab(text: startTimeText),
                Tab(text: endTimeText),
              ],
              labelColor: AppColor().primariColor,
              unselectedLabelColor: Colors.black54,
              indicatorColor: AppColor().primariColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2.5,
            ),
          ),
        ],
      ),
    );
  }
}
