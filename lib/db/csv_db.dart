import 'dart:io';

import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/db/db_base.dart';

import '../consts/value_consts.dart';

class CsvDb implements DbBase {
  File dbFile = File(ValueConsts.dbFileName);

  static const int numOfColsInLine = 4;

  @override
  Future<List<TimeRecord>> readAll() async {
    List<TimeRecord> records = [];
    List<String> lines = await dbFile.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      if (i == 0 && line.contains('ver')) {
        continue;
      }
      List<String> cols = line.split(',');
      if (cols.length != numOfColsInLine) {
        throw Exception();
      }
      records.add(TimeRecord.fromString(
          startDateTime: cols[0],
          endDateTime: cols[1],
          category: cols[2],
          content: cols[3]));
    }
    return records;
  }

  @override
  Future create(TimeRecord timeRecord) async {
    await dbFile.writeAsString(_createLine(timeRecord),
        mode: FileMode.writeOnlyAppend);
  }

  @override
  Future createAll(List<TimeRecord> timeRecords) async {
    StringBuffer sb = StringBuffer();
    for (var timeRecord in timeRecords) {
      sb.write(_createLine(timeRecord));
    }
    await dbFile.writeAsString(sb.toString(), mode: FileMode.writeOnlyAppend);
  }

  @override
  Future init() async {
    if (!await dbFile.exists()) {
      await dbFile.writeAsString('ver. 0.0.1');
    }
  }

  String _createLine(TimeRecord timeRecord) {
    return '${timeRecord.startDateTime?.toString() ?? ValueConsts.invalidDateTime},${timeRecord.endDateTime?.toString() ?? ValueConsts.invalidDateTime},${timeRecord.category},${timeRecord.content}\n';
  }
}
