import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/db/dummy_db.dart';
import '../consts/style_consts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TimeRecord> list = [];
  TimeRecord? recordingData;

  @override
  void initState() {
    super.initState();
    list = DummyDb().getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  recordingData = TimeRecord.init(startDateTime:DateTime.now(),category:'テストPJ', content:'朝会');
                  setState((){
                      list.add(recordingData!);
                  });
                },
                child: Text('朝会'),
              ),
              ElevatedButton(onPressed: (){
                if(recordingData==null){ return; }
                setState((){
                  list = list.map((e){
                    if(e.startDateTime==recordingData?.startDateTime){
                      return e.copyWith(endDateTime: DateTime.now());
                    }
                    return e;
                  }).toList();
                });
                recordingData = null;
              }, child: Text('停止')),
            ],
          ),
          Text('2023/10/12'),
          DataTable(
            showCheckboxColumn: true,
            columns: makeColumns(),
            rows: list.map((x) => makeRow(x)).toList(),
          )
        ],
      ),
    );
  }

  List<DataColumn> makeColumns() {
    List<DataColumn> columns = [];
    List<String> labels = ['開始', '終了', '時間', 'カテゴリ', '内容'];
    List<bool> isNumericList = [true, true, true, false, false];
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

  DataRow makeRow(TimeRecord timeRecord) {
    return DataRow(
      cells: <DataCell>[
        DataCell(SelectableText(timeRecord.formattedStartDateTime)),
        DataCell(SelectableText(timeRecord.formattedEndDateTime)),
        DataCell(SelectableText(timeRecord.formattedSpanHour)),
        DataCell(SelectableText(timeRecord.category)),
        DataCell(SelectableText(timeRecord.content)),
      ],
    );
  }
}
