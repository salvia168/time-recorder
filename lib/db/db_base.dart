import 'package:flutter/foundation.dart';
import 'package:time_recorder/data/record_category.dart';
import 'package:time_recorder/data/record_subcategory.dart';
import 'package:time_recorder/data/time_record.dart';

abstract class DbBase {
  DbBase();

  Future init();

  Future createTimeRecord(TimeRecord timeRecord);

  Future createAllTimeRecord(List<TimeRecord> timeRecords);

  Future<List<TimeRecord>> readAllTimeRecord();

  Future<List<RecordCategory>> readAllCategory();

  Future<List<RecordSubcategory>> readAllSubcategory();
}
