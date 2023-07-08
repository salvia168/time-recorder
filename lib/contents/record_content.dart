import 'package:flutter/material.dart';

import '../consts/style_consts.dart';
import '../data/time_record.dart';
import '../logic/record_data.dart';

class RecordContent extends StatefulWidget {
  const RecordContent({super.key, required this.futureRead});

final Future<List<TimeRecord>> futureRead;

  @override
  State<RecordContent> createState() => _RecordContentState();
}

class _RecordContentState extends State<RecordContent> {
  final RecordData _recordData = RecordData();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<TimeRecord>>(
            future: widget.futureRead,
            builder: (context, snapshot) {
              return DataTable(
                columns: _makeColumns(),
                rows: _recordData.timeRecordList.map((x) => _makeRow(x))
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

    List<String> labels = ['日付','開始', '終了', '時間', '内容'];
    List<bool> isNumericList = [false,true, true, true, false];
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
        DataCell(SelectableText(timeRecord.formattedStartDate)),
        DataCell(SelectableText(timeRecord.formattedStartTime)),
        DataCell(SelectableText(timeRecord.formattedEndTime)),
        DataCell(SelectableText(timeRecord.formattedSpanHour)),
        // DataCell(SelectableText(timeRecord.category)),
        DataCell(SelectableText(timeRecord.content)),
      ],
    );
  }
}
