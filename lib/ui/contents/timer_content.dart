import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_recorder/consts/value_consts.dart';
import 'package:time_recorder/util/hm_formatter.dart';

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
  final TextEditingController _updateStartTimeController =
      TextEditingController();
  final TextEditingController _updateEndTimeController =
      TextEditingController();
  final TextEditingController _updateSpanController = TextEditingController();
  final TextEditingController _updateContentController =
      TextEditingController();

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

    List<String> labels = ['', '開始', '終了', '時間', '内容', '編集'];
    List<bool> isNumericList = [false, true, true, true, false, false];
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
        // DataCell(SelectableText(timeRecord.category)),
        DataCell(SelectableText(timeRecord.content)),
        DataCell(
          timeRecord.isRecording
              ? StyleConsts.sizedBox0
              : IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _createUpdateDialog(timeRecord),
                    );
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
      _recordData.timeRecordList
          .add(_recordData.recordingData!.copyWith(endDateTime: endTime,isRecording: false));
    });
    await _db.create(_recordData.recordingData!.copyWith(endDateTime: endTime, isRecording: false));
    _recordData.recordingData = null;
  }

  _startRecord({String content = ''}) async {
    await _stopRecord();
    _recordData.recordingData = TimeRecord.fromDateTime(
        startDateTime: DateTime.now(), category: 'テストPJ', content: content,isRecording: true);
    setState(() {
      _recordData.timeRecordList.add(_recordData.recordingData!);
    });
  }

  TextField _createTimeTextField(
      {required TextEditingController controller,
      required String labelText,
      required DateTime? dateTime}) {
    return TextField(
      controller: controller,
      inputFormatters: [HmFormatter()],
      decoration: InputDecoration(
          labelText: labelText,
          hintText:
              dateTime == null ? 'hh:mm' : DateFormat.Hm().format(dateTime),
          suffixIcon: IconButton(
            icon: const Icon(Icons.schedule_outlined),
            onPressed: () async {
              var time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: dateTime?.hour ?? 0,
                  minute: dateTime?.minute ?? 0,
                ),
              );
              if (time != null) {
                print(
                    '時間：${DateFormat.Hm().format(DateTime(1, 1, 1, time.hour, time.minute))}');
                controller.text = DateFormat.Hm()
                    .format(DateTime(1, 1, 1, time.hour, time.minute));
              }
            },
          )),
    );
  }

  Dialog _createUpdateDialog(TimeRecord timeRecord) {
    _updateStartTimeController.text = timeRecord.formattedStartTime;
    _updateEndTimeController.text = timeRecord.formattedEndTime;
    _updateSpanController.text = timeRecord.formattedSpanHour;
    _updateContentController.text = timeRecord.content;
    return Dialog(
      child: Padding(
          padding: StyleConsts.padding32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: StyleConsts.value128,
                        child: _createTimeTextField(
                          controller: _updateStartTimeController,
                          labelText: '開始',
                          dateTime: timeRecord.startDateTime,
                        ),
                      ),
                      StyleConsts.sizedBoxW16,
                      SizedBox(
                        width: StyleConsts.value128,
                        child: _createTimeTextField(
                          controller: _updateEndTimeController,
                          labelText: '終了',
                          dateTime: timeRecord.endDateTime,
                        ),
                      ),
                      StyleConsts.sizedBoxW16,
                      SizedBox(
                        width: StyleConsts.value80,
                        child: TextField(
                          enabled: false,
                          controller: _updateSpanController,
                          decoration: const InputDecoration(
                            labelText: '時間',
                          ),
                        ),
                      ),
                    ],
                  ),
                  StyleConsts.sizedBoxH32,
                  SizedBox(
                    width: StyleConsts.value208,
                    child: TextField(
                      controller: _updateContentController,
                      decoration: const InputDecoration(labelText: '内容'),
                    ),
                  ),
                  StyleConsts.sizedBoxH48,
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('キャンセル'),
                  ),
                  StyleConsts.sizedBoxW16,
                  TextButton(
                    onPressed: () {
                      var index =
                          _recordData.timeRecordList.indexOf(timeRecord);
                      setState(() {
                        _recordData.timeRecordList.remove(timeRecord);
                        _recordData.timeRecordList.insert(
                            index,
                            timeRecord.copyWith(
                                content: _updateContentController.text));
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('編集'),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
