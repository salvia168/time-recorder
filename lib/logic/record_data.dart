import 'package:time_recorder/data/record_category.dart';
import 'package:time_recorder/data/record_subcategory.dart';

import '../data/time_record.dart';

class RecordData{

  static final _instance = RecordData._();

  List<TimeRecord> timeRecordList = [];
  List<RecordCategory> categoryList = [];
  List<RecordSubcategory> subcategoryList = [];
  TimeRecord? recordingData;

  RecordData._();

  factory RecordData(){
    return _instance;
  }
}