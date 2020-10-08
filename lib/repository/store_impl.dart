import 'dart:convert';

import 'package:filex/data/repository/store_repository.dart';
import 'package:filex/model/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keyRecords = 'records';
const keyLastUpdate = 'last_update';

class StoreImpl extends StoreRepository {
  @override
  Future<List<Record>> getecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(keyRecords);
    if (list != null && list.isNotEmpty) {
      final records = list
          .map(
            (e) => Record.fromJson(
              jsonDecode(e),
            ),
          )
          .toList();
      return records;
    }
    return <Record>[];
  }

  @override
  Future<void> saveRecord(Record record) async {
    final list = (await getRecords());
    for (Record item in list) {
      if (item.id == record.id) {
        throw Exception('record already saved');
      }
    }
    list.add(record);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      keyRecords,
      list.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  Future<void> saveRecords(List<Record> records) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      keyRecords,
      records.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  Future<DateTime> getLastUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getInt(keyLastUpdate);
    if (data != null && data > 0) {
      return DateTime.fromMillisecondsSinceEpoch(data);
    }
    return null;
  }

  @override
  Future<void> saveLastUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(keyLastUpdate, DateTime.now().millisecondsSinceEpoch);
  }
}
