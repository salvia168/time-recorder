import '../data/time_record.dart';

class RecordData{

  static final _instance = RecordData._();

  List<TimeRecord> timeRecordList = [];
  TimeRecord? recordingData;

  RecordData._();

  factory RecordData(){
    return _instance;
  }
}