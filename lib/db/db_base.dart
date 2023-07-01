import 'package:time_recorder/data/time_record.dart';

abstract class DbBase{
  DbBase();
  Future write(TimeRecord timeRecord);
  Future writeAll(List<TimeRecord> timeRecords);
  Future<List<TimeRecord>> read();
}