import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_meetings/constants/color.dart';
import 'package:schedule_meetings/screen/meeting_schedule/widgets/item_meeting_schedule.dart';

import '../home/bloc/home_bloc.dart';

class MeetingScheduleScreen extends StatelessWidget {
  const MeetingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meeting Schedule Screen')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.green,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Meeting Schedule',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: state.schedules.length,
                      physics: const ClampingScrollPhysics(),

                      itemBuilder: (context, index) {
                        return ItemMeetingSchedule(
                          model: state.schedules[index],
                        );
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
