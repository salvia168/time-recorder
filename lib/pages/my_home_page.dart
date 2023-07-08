import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/db/csv_db.dart';
import 'package:time_recorder/db/db_base.dart';
import '../consts/style_consts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TimeRecord> list = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _updateStartTimeController =
      TextEditingController();
  final TextEditingController _updateEndTimeController =
      TextEditingController();
  final TextEditingController _updateSpanController = TextEditingController();
  final TextEditingController _updateContentController =
      TextEditingController();

  DbBase db = CsvDb();
  Future<List<TimeRecord>>? futureRead;
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');
  TimeRecord? recordingData;

  @override
  void initState() {
    futureRead = Future<List<TimeRecord>>(() async {
      await db.init();
      return await db.readAll();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: StyleConsts.padding32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: StyleConsts.value208,
                  child: TextField(
                    controller: _titleController,
                  ),
                ),
                StyleConsts.sizedBoxW16,
                ElevatedButton(
                  onPressed: () async {
                    await _startRecord(content: _titleController.text);
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
            FutureBuilder<List<TimeRecord>>(
                future: futureRead,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    list = snapshot.data!;
                  }
                  return DataTable(
                    showCheckboxColumn: true,
                    columns: _makeColumns(),
                    rows: list
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
        ),
      )),
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
            child: Center(
          child: Text(
            labels[i],
            style: StyleConsts.fontBold,
          ),
        )),
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
        DataCell(SelectableText(timeRecord.formattedStartDateTime)),
        DataCell(SelectableText(timeRecord.formattedEndDateTime)),
        DataCell(SelectableText(timeRecord.formattedSpanHour)),
        // DataCell(SelectableText(timeRecord.category)),
        DataCell(SelectableText(timeRecord.content)),
        DataCell(timeRecord.isRecording ? StyleConsts.sizedBox0 : IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _createUpdateDialog(timeRecord),
            );
          },
        )),
      ],
    );
  }

  Dialog _createUpdateDialog(TimeRecord timeRecord) {
    _updateStartTimeController.text=timeRecord.formattedStartDateTime;
    _updateEndTimeController.text=timeRecord.formattedEndDateTime;
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
                      width: StyleConsts.value80,
                      child: TextField(
                        enabled: false,
                        controller: _updateStartTimeController,
                        decoration: InputDecoration(
                          labelText: '開始',
                          hintText: timeRecord.formattedStartDateTime,
                          // suffix: IconButton(
                          //   icon: const Icon(Icons.schedule_outlined),
                          //   onPressed: () async {
                          //     await showTimePicker(
                          //       context: context,
                          //       initialTime: TimeOfDay(hour: 1, minute: 30),
                          //     );
                          //   },
                          // ),
                        ),
                      ),
                    ),
                    StyleConsts.sizedBoxW16,
                    SizedBox(
                      width: StyleConsts.value80,
                      child: TextField(
                        enabled: false,
                        controller: _updateEndTimeController,
                        decoration: InputDecoration(
                          labelText: '終了',
                          hintText: timeRecord.formattedEndDateTime,
                        ),
                      ),
                    ),
                    StyleConsts.sizedBoxW16,
                    SizedBox(
                      width: StyleConsts.value80,
                      child: TextField(
                        enabled: false,
                        controller: _updateSpanController,
                        decoration: InputDecoration(
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
                ElevatedButton(
                  onPressed: () {
                    var index = list.indexOf(timeRecord);
                    setState((){
                      list.remove(timeRecord);
                      list.insert(index, timeRecord.copyWith(content: _updateContentController.text));
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('編集'),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  _stopRecord() async {
    DateTime endTime = DateTime.now();
    if (recordingData == null) {
      return;
    }
    setState(() {
      list.remove(recordingData);
      list.add(recordingData!.copyWith(
        endDateTime: endTime,
        isRecording: false,
      ));
    });
    await db.create(recordingData!.copyWith(
      endDateTime: endTime,
      isRecording: false,
    ));
    recordingData = null;
  }

  _startRecord({String content = ''}) async {
    await _stopRecord();
    recordingData = TimeRecord.fromDateTime(
      startDateTime: DateTime.now(),
      category: 'テストPJ',
      content: content,
      isRecording: true,
    );
    setState(() {
      list.add(recordingData!);
    });
  }
}
