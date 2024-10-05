import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_meetings/constants/color.dart';
import 'package:schedule_meetings/helper/extension.dart';
import 'package:schedule_meetings/screen/create_schedule/widgets/item_schedule.dart';
import 'package:schedule_meetings/screen/home/bloc/home_bloc.dart';
import 'package:schedule_meetings/widgets/dropdown_custom.dart';

import '../../helper/data_helper.dart';
import '../../helper/local_storage.dart';
import '../../model/schedule_model.dart';
import '../../widgets/button_custom.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  TextEditingController controller = TextEditingController();
  DatabaseHelper dbHelper = DatabaseHelper();
  late DateTime startRoom;
  late DateTime closeRoom;
  List<ScheduleModel> items = [];
  List<ScheduleModel> listGenerate = [];
  ScheduleModel? timeCurrent;

  @override
  void initState() {
    getRoomTime();
    getDataFromDB();
    super.initState();
  }

  Future<void> getRoomTime() async {
    LocalStorage sharedPrefs = LocalStorage();
    List<DateTime>? time = await sharedPrefs.getTime();
    startRoom = time?.first ?? DateTime.now().copyWith(hour: 7, minute: 0);
    closeRoom = time?.last ?? DateTime.now().copyWith(hour: 19, minute: 0);
  }

  Future<void> getDataFromDB() async {
    items = await dbHelper.getItems();
  }

  void generateTime(int durations) {
    listGenerate.clear();
    timeCurrent = null;
    var timeStart = startRoom;
    while (
        isBeforeTime(timeStart.add(Duration(minutes: durations)), closeRoom) ||
            isAtSameMomentAsTime(
                timeStart.add(Duration(minutes: durations)), closeRoom)) {
      listGenerate
          .add(ScheduleModel(name: '', start: timeStart, durations: durations));
      timeStart = timeStart.add(const Duration(minutes: 10));
    }
    var itemsDB = items;
    for (int i = 0; i < listGenerate.length; i++) {
      for (int j = 0; j < itemsDB.length; j++) {
        if (isAfterTime(listGenerate[i].start, itemsDB[j].start) &&
                isBeforeTime(
                    listGenerate[i].start,
                    itemsDB[j]
                        .start
                        .add(Duration(minutes: itemsDB[j].durations))) ||
            isAfterTime(
                    listGenerate[i]
                        .start
                        .add(Duration(minutes: listGenerate[i].durations)),
                    itemsDB[j].start) &&
                isBeforeTime(
                    listGenerate[i].start,
                    itemsDB[j]
                        .start
                        .add(Duration(minutes: itemsDB[j].durations)))) {
          listGenerate[i] = listGenerate[i].copyWith(exist: true);
        }
      }
    }
    setState(() {});
  }

  Future<void> createSchedule() async {
    BlocProvider.of<HomeBloc>(context)
        .add(CreateSchedule(model: timeCurrent!, name: controller.text));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create Schedule Screen',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Name'),
            const SizedBox(
              height: 4,
            ),
            TextField(
              controller: controller,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});
                if (controller.text.trim().isEmpty) {
                  controller.clear();
                }
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {});
                } else {
                  controller.clear();
                }
              },
              autofocus: true,
              cursorColor: AppColor.primary,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(12),
                hintText: "input name schedule",
                filled: true,
                fillColor: AppColor.white,
                hintStyle: TextStyle(color: AppColor.hind),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: AppColor.primary)),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Duration'),
            const SizedBox(
              height: 4,
            ),
            DropdownCustom(
              items:
                  List.generate(12, (index) => ((index + 1) * 10).toString()),
              onSelected: (value) {
                generateTime((((value ?? 0) + 1) * 10));
              },
            ),
            const SizedBox(
              height: 16,
            ),
            if (listGenerate.isNotEmpty) const Text('Choose Time: '),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: (1 / .4),
                crossAxisSpacing: 6,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                children: List.generate(listGenerate.length, (index) {
                  return ItemSchedule(
                    isChoose: timeCurrent?.start == listGenerate[index].start,
                    isDisable: listGenerate[index].exist ?? false,
                    text:
                        '${DateFormat('HH:mm').format(listGenerate[index].start)} '
                        '- ${DateFormat('HH:mm').format(listGenerate[index].start.add(Duration(minutes: listGenerate[index].durations)))}',
                    onEvent: () {
                      setState(() {
                        if (listGenerate[index].exist != true) {
                          timeCurrent = listGenerate[index];
                        }
                      });
                    },
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 24,
            ),
            ButtonOutline(
              maxWidth: true,
              onPressed:
                  controller.text.trim().isNotEmpty && timeCurrent != null
                      ? createSchedule
                      : null,
              text: 'Create',
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
