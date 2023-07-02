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
  final TextEditingController _controller = TextEditingController();
  DbBase db = CsvDb();
  Future<List<TimeRecord>>? futureRead;
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');
  TimeRecord? recordingData;

  @override
  void initState() {
    futureRead = Future<List<TimeRecord>>(()async{
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
        child: Column(
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
                const SizedBox(width: 16,),
                ElevatedButton(
                  onPressed: () async {
                    await _startRecord(content: _controller.text);
                  },
                  child: const Text('開始'),
                ),
                const SizedBox(width: 16,),
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
                                  -1) >= 0;
                        })
                        .map((x) => _makeRow(x))
                        .toList(),
                  );
                }),
          ],
        ),
      ),
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
        DataCell(SelectableText(timeRecord.formattedStartDateTime)),
        DataCell(SelectableText(timeRecord.formattedEndDateTime)),
        DataCell(SelectableText(timeRecord.formattedSpanHour)),
        // DataCell(SelectableText(timeRecord.category)),
        DataCell(SelectableText(timeRecord.content)),
      ],
    );
  }

  _stopRecord()async {
    DateTime endTime = DateTime.now();
    if (recordingData == null) {
      return;
    }
    setState((){
      list.remove(recordingData);
      list.add(recordingData!.copyWith(endDateTime: endTime));
    });
    await db.create(recordingData!.copyWith(endDateTime: endTime));
    recordingData = null;
  }

  _startRecord({String content = ''})async {
    await _stopRecord();
    recordingData = TimeRecord.fromDateTime(
        startDateTime: DateTime.now(), category: 'テストPJ', content: content);
    setState(() {
      list.add(recordingData!);
    });
  }
}
