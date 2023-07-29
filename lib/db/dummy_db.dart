import 'package:flutter/src/foundation/annotations.dart';
import 'package:time_recorder/data/record_category.dart';
import 'package:time_recorder/data/record_subcategory.dart';
import 'package:time_recorder/db/db_base.dart';

import '../data/time_record.dart';

class DummyDb implements DbBase {
  final List<TimeRecord> _data = [];

  DummyDb() {
    for (int i = 0; i < 6; i++) {
      _data.add(TimeRecord.fromDateTime(
          startDateTime: DateTime.now().add(Duration(hours: i)),
          endDateTime: DateTime.now().add(Duration(hours: i + 1)),
          category: 'テスト',
          content: 'テスト'));
    }
  }

  @override
  Future<List<TimeRecord>> readAllTimeRecord() async {
    return _data;
  }

  @override
  Future createTimeRecord(TimeRecord timeRecord) async {
    _data.add(timeRecord);
  }

  @override
  Future createAllTimeRecord(List<TimeRecord> timeRecords) async {
    _data.addAll(timeRecords);
  }

  @override
  Future init() async {
    return await null;
  }

  @override
  Future<List<RecordCategory>> readAllCategory() async {
    return await <RecordCategory>[
    RecordCategory(id:0,name: 'test1'),
    RecordCategory(id:1,name:'test2'),
    RecordCategory(id:2,name:'test3'),
    ]; throw UnimplementedError();
  }

  @override
  Future<List<RecordSubcategory>> readAllSubcategory() async {
    return await <RecordSubcategory>[
      RecordSubcategory(
          parentId: 0, id: 0, name: 'category1'),
      RecordSubcategory(
          parentId: 0, id: 1, name: 'category2'),
      RecordSubcategory(
          parentId: 0, id: 2, name: 'category3'),
      RecordSubcategory(
          parentId: 0, id: 3, name: 'category4'),
      RecordSubcategory(
          parentId: 1, id: 4, name: 'category5'),
      RecordSubcategory(
          parentId: 1, id: 5, name: 'category6'),
      RecordSubcategory(
          parentId: 2, id: 6, name: 'category7'),
      RecordSubcategory(
          parentId: 2, id: 7, name: 'category8'),
    ];
  }
}