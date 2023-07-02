import 'package:time_recorder/db/db_base.dart';

import '../data/time_record.dart';

class DummyDb implements DbBase{
  List<TimeRecord> _data=[];
  DummyDb(){
    for(int i=0;i<6;i++){
      _data.add(TimeRecord.fromDateTime(startDateTime: DateTime.now().add(Duration(hours: i)),endDateTime: DateTime.now().add(Duration(hours: i+1)),category:'テスト',content:'テスト'));
    }
  }

  @override
  Future<List<TimeRecord>> readAll()async{
    return _data;
  }

  @override
  Future create(TimeRecord timeRecord) async {
    _data.add(timeRecord);
  }

  @override
  Future createAll(List<TimeRecord> timeRecords) async {
    _data.addAll(timeRecords);
  }

  @override
  Future init() async{
    return await null;
  }
}