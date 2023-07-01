import 'dart:io';

import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/db/db_base.dart';

import '../consts/value_consts.dart';

class CsvDb implements DbBase{
  static const int numOfColsInLine = 4;
  @override
  Future<List<TimeRecord>> read() async {
    List<TimeRecord> records = [];
    List<String> lines=  await File(ValueConsts.dbFileName).readAsLines();
    for(var line in lines){
      List<String> cols = line.split(',');
      if(cols.length != numOfColsInLine) {
        throw Exception();
      }
       records.add(TimeRecord.fromString(startDateTime: cols[0],endDateTime: cols[1], category: cols[2], content: cols[3]));
    }
    return records;
  }

  @override
  Future write(TimeRecord timeRecord) async {
    await File(ValueConsts.dbFileName).writeAsString(makeLine(timeRecord),mode:FileMode.writeOnlyAppend);
  }

  @override
  Future writeAll(List<TimeRecord> timeRecords) async {
    StringBuffer sb = StringBuffer();
    for (var timeRecord in timeRecords) {
      sb.write(makeLine(timeRecord));
    }
    await File(ValueConsts.dbFileName).writeAsString(sb.toString());

  }

  String makeLine(TimeRecord timeRecord){
    return '${timeRecord.startDateTime?.toString()??ValueConsts.invalidDateTime},${timeRecord.endDateTime?.toString()??ValueConsts.invalidDateTime},${timeRecord.category},${timeRecord.content}\n';
  }

}