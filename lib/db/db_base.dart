import 'package:time_recorder/data/time_record.dart';

abstract class DbBase{
  DbBase();
  Future init();
  Future create(TimeRecord timeRecord);
  Future createAll(List<TimeRecord> timeRecords);
  Future<List<TimeRecord>> readAll();
}