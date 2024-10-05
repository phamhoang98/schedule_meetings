import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_meetings/constants/color.dart';

import '../../helper/local_storage.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/time_box.dart';

class RoomAvailabilitySetupScreen extends StatefulWidget {
  const RoomAvailabilitySetupScreen({super.key});

  @override
  State<RoomAvailabilitySetupScreen> createState() =>
      _RoomAvailabilitySetupScreenState();
}

class _RoomAvailabilitySetupScreenState
    extends State<RoomAvailabilitySetupScreen> {
  DateTime? start;
  DateTime? close;
  bool isEdit = false;

  @override
  void initState() {
    getTimeLocal();
    super.initState();
  }

  Future<void> getTimeLocal() async {
    LocalStorage sharedPrefs = LocalStorage();
    List<DateTime>? time = await sharedPrefs.getTime();
    start = time?.first ?? DateTime.now().copyWith(hour: 7, minute: 0);
    close = time?.last ?? DateTime.now().copyWith(hour: 19, minute: 0);
    setState(() {});
  }

  void changeTime({required DateTime time, required int type}) {
    setState(() {
      isEdit = true;
      if (type == 0) {
        start = time;
      } else {
        close = time;
      }
    });
  }

  Future<void> saveTime() async {
    if (start!.hour > close!.hour ||
        (start!.hour == close!.hour && start!.minute > close!.minute)) {
      return _showWaringTime();
    }
    _showDialog();
  }

  void _showWaringTime() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content:
              const Text('Closing time cannot be earlier than opening time'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Thực hiện hành động khi nhấn OK
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: const Text('Are you sure you want to change the time?'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((value) async {
      LocalStorage sharedPrefs = LocalStorage();
      if (value) {
        await sharedPrefs.saveTime(opening: start!, closing: close!);
      } else {
        List<DateTime>? time = await sharedPrefs.getTime();
        if (time != null) {
          start = time.first;
          close = time.last;
        }
      }
      setState(() {
        isEdit = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Room Availability Setup',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Input the opening and closing times',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 120,
                  child: Text(
                    'Opening:',
                  ),
                ),
                TimeBox(
                  firstDate: start,
                  selectedDate: start,
                  onChanged: (time) {
                    changeTime(time: time, type: 0);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 120,
                  child: Text('Closing:'),
                ),
                TimeBox(
                  firstDate: close,
                  selectedDate: close,
                  onChanged: (time) {
                    changeTime(time: time, type: 1);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              alignment: Alignment.center,
              child: ButtonOutline(
                onPressed: isEdit ? saveTime : null,
                text: 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
