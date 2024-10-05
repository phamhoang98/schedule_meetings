import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_meetings/screen/create_schedule/create_schedule_screen.dart';
import 'package:schedule_meetings/screen/home/bloc/home_bloc.dart';
import 'package:schedule_meetings/screen/meeting_schedule/meeting_schedule_screen.dart';
import 'package:schedule_meetings/screen/room_availability_setup/room_availability_setup.dart';

import '../../constants/color.dart';
import '../../model/nav_model.dart';
import '../../widgets/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const MeetingScheduleScreen(),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const RoomAvailabilitySetupScreen(),
        navKey: searchNavKey,
      ),
    ];
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return BlocProvider.value(
          value: BlocProvider.of<HomeBloc>(context),
          child: const CreateScheduleScreen(),
        );
      },
    ).then((value) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: items
            .map((page) =>
            Navigator(
              key: page.navKey,
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [MaterialPageRoute(builder: (context) => page.page)];
              },
            ))
            .toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 16),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () {
            _showDialog();
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: AppColor.green),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.add,
            color: AppColor.green,
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
        onTap: (index) {
          if (index == selectedTab) {
            items[index]
                .navKey
                .currentState
                ?.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              selectedTab = index;
            });
          }
        },
      ),
    );
  }
}
