import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_recorder/consts/value_consts.dart';
import 'package:time_recorder/data/record_category.dart';
import 'package:time_recorder/data/record_subcategory.dart';
import 'package:time_recorder/ui/parts/blink.dart';
import 'package:time_recorder/ui/parts/category_dropdown.dart';
import 'package:time_recorder/ui/parts/update_dialog.dart';

import '../../data/time_record.dart';
import '../../db/csv_db.dart';
import '../../db/db_base.dart';
import '../../logic/record_data.dart';
import '../../consts/style_consts.dart';

class TimerContent extends StatefulWidget {
  const TimerContent({super.key, required this.futureRead});

  // final Future<void> futureRead;
  final Future<List<TimeRecord>> futureRead;

  @override
  State<TimerContent> createState() => _TimerContentState();
}

class _TimerContentState extends State<TimerContent> {
  final RecordData _recordData = RecordData();

  // final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final DbBase _db = CsvDb();
  final DateFormat _dateFormat = DateFormat(ValueConsts.dateFormatPattern);
  RecordCategory? selectedCategory;
  RecordSubcategory? selectedSubcategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Blink(
              visible: _recordData.recordingData != null,
              duration: const Duration(seconds: 1),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  StyleConsts.sizedBoxW8,
                  Text('計測中',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            CategoryDropdown<RecordCategory>(
              selectedCategory: selectedCategory,
              categoryList: _recordData.categoryList,
              onChanged: (RecordCategory? newValue) {
                setState(() {
                  selectedSubcategory = null;
                  selectedCategory = newValue;
                });
              },
            ),
            // SizedBox(
            //   width: StyleConsts.value208,
            //   child: DropdownButton<RecordCategory>(
            //     itemHeight: StyleConsts.value72,
            //     hint: const Text('カテゴリー'),
            //     value: selectedCategory,
            //     items: _recordData.categoryList
            //         .map<DropdownMenuItem<RecordCategory>>(
            //             (RecordCategory category) =>
            //                 DropdownMenuItem<RecordCategory>(
            //                     value: category, child: Text(category.name)))
            //         .toList(),
            //     onChanged: (RecordCategory? newValue) {
            //       setState(() {
            //         selectedSubcategory =null;
            //         selectedCategory = newValue;
            //       });
            //     },
            //     isExpanded: true,
            //   ),
            // ),
            StyleConsts.sizedBoxW16,
            CategoryDropdown<RecordSubcategory>(
              label: 'サブカテゴリー',
              selectedCategory: selectedSubcategory,
              categoryList: _recordData.subcategoryList
                  .where((element) =>
                      element.parentId == (selectedCategory?.id ?? -1))
                  .toList(),
              onChanged: (RecordSubcategory? newValue) {
                setState(() {
                  selectedSubcategory = newValue;
                });
              },
            ),
            // SizedBox(
            //   width: StyleConsts.value208,
            //   child: DropdownButton<RecordSubcategory>(
            //     itemHeight: StyleConsts.value72,
            //     hint: const Text('サブカテゴリー'),
            //     value: selectedSubcategory,
            //     items: _recordData.subcategoryList
            //         .where((element) =>
            //             element.parentId == (selectedCategory?.id ?? -1))
            //         .map<DropdownMenuItem<RecordSubcategory>>(
            //             (RecordSubcategory category) =>
            //                 DropdownMenuItem<RecordSubcategory>(
            //                     value: category, child: Text(category.name)))
            //         .toList(),
            //     onChanged: (RecordSubcategory? newValue) {
            //       setState(() {
            //         selectedSubcategory = newValue;
            //       });
            //     },
            //     isExpanded: true,
            //   ),
            // ),
            StyleConsts.sizedBoxW16,
            SizedBox(
              width: StyleConsts.value208,
              child: TextField(
                decoration: const InputDecoration(labelText: '内容'),
                controller: _contentController,
              ),
            ),
            StyleConsts.sizedBoxW16,
            ElevatedButton(
              onPressed: () async {
                await _startRecord(
                    category: selectedCategory?.name ?? '',
                    content: _contentController.text);
              },
              child: const Text('開始'),
            ),
            StyleConsts.sizedBoxW16,
            ElevatedButton(
              onPressed: _stopRecord,
              child: const Text('停止'),
            ),
          ],
        ),
        StyleConsts.sizedBoxH32,
        Text(
          _dateFormat.format(DateTime.now()),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        StyleConsts.sizedBoxH16,
        FutureBuilder<List<TimeRecord>>(
            future: widget.futureRead,
            builder: (context, snapshot) {
              return DataTable(
                columns: _makeColumns(),
                rows: _recordData.timeRecordList
                    .where((element) {
                      var now = DateTime.now();
                      return (element.startDateTime?.compareTo(
                                  DateTime(now.year, now.month, now.day)) ??
                              -1) >=
                          0;
                    })
                    .map((x) => _makeRow(x))
                    .toList(),
              );
            }),
      ],
    );
  }

  List<DataColumn> _makeColumns() {
    List<DataColumn> columns = [];
    // List<String> labels = ['開始', '終了', '時間', 'カテゴリ', '内容'];
    // List<bool> isNumericList = [true, true, true, false, false];

    List<String> labels = ['', '開始', '終了', '時間', 'カテゴリ', 'サブカテゴリー', '内容', '編集'];
    List<bool> isNumericList = [
      false,
      true,
      true,
      true,
      false,
      false,
      false,
      false
    ];
    for (int i = 0; i < labels.length; i++) {
      columns.add(DataColumn(
        numeric: isNumericList[i],
        label: Expanded(
          child: Text(
            labels[i],
            style: StyleConsts.fontBold,
          ),
        ),
      ));
    }
    return columns;
  }

  DataRow _makeRow(TimeRecord timeRecord) {
    return DataRow(
      cells: <DataCell>[
        DataCell(timeRecord.isRecording
            ? const Icon(Icons.timer_outlined)
            : StyleConsts.sizedBox0),
        DataCell(SelectableText(timeRecord.formattedStartTime)),
        DataCell(SelectableText(timeRecord.formattedEndTime)),
        DataCell(SelectableText(timeRecord.formattedSpanHour)),
        DataCell(SelectableText(_recordData.categoryList
            .firstWhere((element) => element.id == timeRecord.categoryId,
                orElse: () => RecordCategory(name: ''))
            .name)),
        DataCell(SelectableText(_recordData.subcategoryList
            .firstWhere(
                (element) =>
                    element.parentId == timeRecord.categoryId &&
                    element.id == timeRecord.subcategoryId,
                orElse: () => RecordSubcategory(name: ''))
            .name)),
        DataCell(SelectableText(timeRecord.content)),
        DataCell(
          timeRecord.isRecording
              ? StyleConsts.sizedBox0
              : IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    TimeRecord? newTimeRecord = await showDialog<TimeRecord>(
                      context: context,
                      builder: (BuildContext context) => UpdateDialog(
                        timeRecord: timeRecord,
                      ),
                    );
                    if (newTimeRecord != null) {
                      var index =
                          _recordData.timeRecordList.indexOf(timeRecord);
                      setState(() {
                        _recordData.timeRecordList.remove(timeRecord);
                        _recordData.timeRecordList.insert(index, newTimeRecord);
                      });
                    }
                  },
                ),
        ),
      ],
    );
  }

  _stopRecord() async {
    DateTime endTime = DateTime.now();
    if (_recordData.recordingData == null) {
      return;
    }
    setState(() {
      _recordData.timeRecordList.remove(_recordData.recordingData);
      _recordData.timeRecordList.add(_recordData.recordingData!
          .copyWith(endDateTime: endTime, isRecording: false));
    });
    await _db.createTimeRecord(_recordData.recordingData!
        .copyWith(endDateTime: endTime, isRecording: false));
    setState(() {
      _recordData.recordingData = null;
    });
  }

  _startRecord({String category = '', String content = ''}) async {
    await _stopRecord();
    _recordData.recordingData = TimeRecord.fromDateTime(
        startDateTime: DateTime.now(),
        categoryId: selectedCategory?.id ?? -1,
        subcategoryId: selectedSubcategory?.id ?? -1,
        category: category,
        content: content,
        isRecording: true);
    setState(() {
      _recordData.timeRecordList.add(_recordData.recordingData!);
    });
  }

// Dialog _createUpdateDialog(TimeRecord timeRecord) {
//   _updateStartTimeController.text = timeRecord.formattedStartTime;
//   _updateEndTimeController.text = timeRecord.formattedEndTime;
//   _updateSpanController.text = timeRecord.formattedSpanHour;
//   _updateContentController.text = timeRecord.content;
//   return Dialog(
//     child: Padding(
//         padding: StyleConsts.padding32,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: StyleConsts.value128,
//                       child: TimeTextField(
//                         context: context,
//                         controller: _updateStartTimeController,
//                         labelText: '開始',
//                         dateTime: timeRecord.startDateTime,
//                       ),
//                     ),
//                     StyleConsts.sizedBoxW16,
//                     SizedBox(
//                       width: StyleConsts.value128,
//                       child: TimeTextField(
//                         context: context,
//                         controller: _updateEndTimeController,
//                         labelText: '終了',
//                         dateTime: timeRecord.endDateTime,
//                       ),
//                     ),
//                     StyleConsts.sizedBoxW16,
//                     SizedBox(
//                       width: StyleConsts.value80,
//                       child: TextField(
//                         enabled: false,
//                         controller: _updateSpanController,
//                         decoration: const InputDecoration(
//                           labelText: '時間',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 StyleConsts.sizedBoxH32,
//                 SizedBox(
//                   width: StyleConsts.value208,
//                   child: TextField(
//                     controller: _updateContentController,
//                     decoration: const InputDecoration(labelText: '内容'),
//                   ),
//                 ),
//                 StyleConsts.sizedBoxH48,
//               ],
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('キャンセル'),
//                 ),
//                 StyleConsts.sizedBoxW16,
//                 TextButton(
//                   onPressed: () {
//                     var index =
//                         _recordData.timeRecordList.indexOf(timeRecord);
//                     setState(() {
//                       _recordData.timeRecordList.remove(timeRecord);
//                       _recordData.timeRecordList.insert(
//                           index,
//                           timeRecord.copyWith(
//                               content: _updateContentController.text));
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: const Text('編集'),
//                 ),
//               ],
//             ),
//           ],
//         )),
//   );
// }

// void updateData(
//     String startTime, String endTime, String content, TimeRecord timeRecord) {
//   var index = _recordData.timeRecordList.indexOf(timeRecord);
//   setState(() {
//     _recordData.timeRecordList.remove(timeRecord);
//     _recordData.timeRecordList.insert(
//         index, timeRecord.copyWith(content: _updateContentController.text));
//   });
// }
}
