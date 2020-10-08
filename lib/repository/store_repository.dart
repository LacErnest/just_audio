import 'package:filex/model/record.dart';

abstract class StoreRepository {
  Future<void> saveRecord(Record record);
  Future<void> saveRecords(List<Record> records);
  Future<List<Record>> getRecords();
  Future<DateTime> getLastUpdate();
  Future<void> saveLastUpdate();
  Future<void> deleteRecord(Record record);
}
