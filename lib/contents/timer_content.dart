import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_recorder/consts/value_consts.dart';

import '../data/time_record.dart';
import '../db/csv_db.dart';
import '../db/db_base.dart';
import '../logic/record_data.dart';
import '../consts/style_consts.dart';

class TimerContent extends StatefulWidget {
  const TimerContent({super.key, required this.futureRead});
  // final Future<void> futureRead;
  final Future<List<TimeRecord>> futureRead;

  @override
  State<TimerContent> createState() => _TimerContentState();
}

class _TimerContentState extends State<TimerContent> {
  final RecordData _recordData = RecordData();
  final TextEditingController _controller = TextEditingController();
  final DbBase _db = CsvDb();
  final DateFormat _dateFormat = DateFormat(ValueConsts.dateFormatPattern);

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
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
              ),
            ),
            StyleConsts.sizedBoxW16,
            ElevatedButton(
              onPressed: () async {
                await _startRecord(content: _controller.text);
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
        // Row(
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         _startRecord(content: '朝会');
        //       },
        //       child: Text('朝会'),
        //     ),
        //     ElevatedButton(
        //       onPressed: _stopRecord,
        //       child: Text('停止'),
        //     ),
        //   ],
        // ),
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

    List<String> labels = ['開始', '終了', '時間', '内容'];
    List<bool> isNumericList = [true, true, true, false];
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
        DataCell(SelectableText(timeRecord.formattedStartTime)),
        DataCell(SelectableText(timeRecord.formattedEndTime)),
        DataCell(SelectableText(timeRecord.formattedSpanHour)),
        // DataCell(SelectableText(timeRecord.category)),
        DataCell(SelectableText(timeRecord.content)),
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
      _recordData.timeRecordList.add(_recordData.recordingData!.copyWith(endDateTime: endTime));
    });
    await _db.create(_recordData.recordingData!.copyWith(endDateTime: endTime));
    _recordData.recordingData = null;
  }

  _startRecord({String content = ''}) async {
    await _stopRecord();
    _recordData.recordingData = TimeRecord.fromDateTime(
        startDateTime: DateTime.now(), category: 'テストPJ', content: content);
    setState(() {
      _recordData.timeRecordList.add(_recordData.recordingData!);
    });
  }
}
