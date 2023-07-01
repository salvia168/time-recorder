import '../data/time_record.dart';

class DummyDb{
  List<TimeRecord> _data=[];
  DummyDb(){
    for(int i=0;i<6;i++){
      _data.add(TimeRecord.init(startDateTime: DateTime.now().add(Duration(hours: i)),endDateTime: DateTime.now().add(Duration(hours: i+1)),category:'テスト',content:'テスト'));
    }
  }

  List<TimeRecord> getList(){
    return _data;
  }
}