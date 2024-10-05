import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_meetings/constants/color.dart';

class TimeBox extends StatefulWidget {
  const TimeBox({
    super.key,
    required this.onChanged,
    this.firstDate,
    this.selectedDate,
    this.lastDate,
    this.hint,
    this.formatDate,
    this.colorBorder,
  });

  final Function(DateTime) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? selectedDate;
  final String? hint;
  final String? formatDate;
  final Color? colorBorder;

  @override
  State<TimeBox> createState() => _TimeBoxState();
}

class _TimeBoxState extends State<TimeBox> {
  late Duration duration;
  final now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    duration = Duration(
        hours: widget.firstDate?.hour ?? 0,
        minutes: widget.firstDate?.minute ?? 0);
    super.initState();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    ).then((value) => widget.onChanged(DateTime(2024).add(duration)));
  }


  @override
  void didUpdateWidget(TimeBox oldWidget) {
    if(oldWidget.firstDate!=widget.firstDate){
      duration = Duration(
          hours: widget.firstDate?.hour ?? 0,
          minutes: widget.firstDate?.minute ?? 0);
    }
  }

  void _handleSelectTime() {
    _showDialog(
      CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        initialTimerDuration: duration,
        // This is called when the user changes the timer's
        // duration.
        onTimerDurationChanged: (Duration newDuration) {
          setState(() => duration = newDuration);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDateWithZeroTime = DateTime(now.year, now.month, now.day);
    return GestureDetector(
      onTap: _handleSelectTime,
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.border, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.selectedDate == null
                    ? widget.hint ?? "hh:mm"
                    : DateFormat("HH:mm")
                        .format(currentDateWithZeroTime.add(duration)),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black54,
                ))
          ],
        ),
      ),
    );
  }
}
