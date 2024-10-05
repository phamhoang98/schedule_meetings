import 'package:flutter/material.dart';
import 'package:schedule_meetings/constants/color.dart';

class ItemSchedule extends StatelessWidget {
  const ItemSchedule(
      {super.key,
      this.isChoose = false,
      this.onEvent,
      required this.text,
      this.isDisable = false});

  final bool isChoose;
  final bool isDisable;
  final void Function()? onEvent;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEvent,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            color: isChoose ? AppColor.green : null,
            border:
                Border.all(color: isChoose ? AppColor.green : AppColor.border),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: isChoose ? FontWeight.w600 : null,
                color: isDisable
                    ? AppColor.border
                    : isChoose
                        ? AppColor.white
                        : null),
          ),
        ),
      ),
    );
  }
}
