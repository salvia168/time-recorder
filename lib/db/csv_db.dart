import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:time_recorder/data/record_category.dart';
import 'package:time_recorder/data/record_subcategory.dart';
import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/db/db_base.dart';

import '../consts/value_consts.dart';

class CsvDb implements DbBase {
  File dbFile = File(ValueConsts.dbFileName);

  static const int numOfColsInLine = 4;

  @override
  Future<List<TimeRecord>> readAllTimeRecord() async {
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
  Future createTimeRecord(TimeRecord timeRecord) async {
    await dbFile.writeAsString(_createLine(timeRecord),
        mode: FileMode.writeOnlyAppend);
  }

  @override
  Future createAllTimeRecord(List<TimeRecord> timeRecords) async {
    StringBuffer sb = StringBuffer();
    for (var timeRecord in timeRecords) {
      sb.write(_createLine(timeRecord));
    }
    await dbFile.writeAsString(sb.toString(), mode: FileMode.writeOnlyAppend);
  }
  @override
  Future<List<RecordCategory>> readAllCategory()async{
    throw UnimplementedError();
  }

  @override
  Future<List<RecordSubcategory>> readAllSubcategory() {
    // TODO: implement readAllSubcategory
    throw UnimplementedError();
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
