
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _singleton = LocalStorage._internal();

  LocalStorage._internal();

  factory LocalStorage() {
    return _singleton;
  }

  Future<void> saveTime(
      {required DateTime opening, required DateTime closing}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'time', [opening.toIso8601String(), closing.toIso8601String()]);
  }

  Future<List<DateTime>?> getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('time');
    if (data != null) {
     return data.map((e) => DateTime.parse(e)).toList();
    }
  }
}
