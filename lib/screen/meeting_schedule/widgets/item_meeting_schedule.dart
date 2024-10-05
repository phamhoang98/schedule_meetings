import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_meetings/model/schedule_model.dart';

import '../../../constants/color.dart';

class ItemMeetingSchedule extends StatelessWidget {
  const ItemMeetingSchedule({super.key, required this.model});

  final ScheduleModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.border),
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('name: ${model.name}'),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${DateFormat('HH:mm').format(model.start)} '
            '- ${DateFormat('HH:mm').format(model.start.add(Duration(minutes: model.durations)))}',
          ),
        ],
      ),
    );
  }
}
