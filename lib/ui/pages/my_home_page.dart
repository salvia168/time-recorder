import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_recorder/ui/contents/record_content.dart';
import 'package:time_recorder/ui/contents/timer_content.dart';
import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/db/csv_db.dart';
import 'package:time_recorder/db/db_base.dart';
import 'package:time_recorder/logic/record_data.dart';
import '../../consts/style_consts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<TimeRecord> list = [];

  int _navigationIndex = 0;
  final RecordData _recordData = RecordData();

  // List<TimeRecord> list = [];
  // final TextEditingController _controller = TextEditingController();
  DbBase db = CsvDb();
  Future<List<TimeRecord>> futureRead = Future<List<TimeRecord>>(() {
    return [];
  });

  // final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');
  // TimeRecord? recordingData;

  @override
  void initState() {
    futureRead = Future<List<TimeRecord>>(() async {
      await db.init();
      _recordData.timeRecordList = await db.readAll();
      return _recordData.timeRecordList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// <<<<<<< HEAD
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SingleChildScrollView(
//           child: Padding(
//         padding: StyleConsts.padding32,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: [
//                 SizedBox(
//                   width: StyleConsts.value208,
//                   child: TextField(
//                     controller: _titleController,
//                   ),
//                 ),
//                 StyleConsts.sizedBoxW16,
//                 ElevatedButton(
//                   onPressed: () async {
//                     await _startRecord(content: _titleController.text);
//                   },
//                   child: const Text('開始'),
//                 ),
//                 StyleConsts.sizedBoxW16,
//                 ElevatedButton(
//                   onPressed: _stopRecord,
//                   child: const Text('停止'),
//                 ),
//               ],
//             ),
//             // Row(
//             //   children: [
//             //     ElevatedButton(
//             //       onPressed: () {
//             //         _startRecord(content: '朝会');
//             //       },
//             //       child: Text('朝会'),
//             //     ),
//             //     ElevatedButton(
//             //       onPressed: _stopRecord,
//             //       child: Text('停止'),
//             //     ),
//             //   ],
//             // ),
//             Text(
//               _dateFormat.format(DateTime.now()),
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             FutureBuilder<List<TimeRecord>>(
//                 future: futureRead,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     list = snapshot.data!;
//                   }
//                   return DataTable(
//                     showCheckboxColumn: true,
//                     columns: _makeColumns(),
//                     rows: list
//                         .where((element) {
//                           var now = DateTime.now();
//                           return (element.startDateTime?.compareTo(
//                                       DateTime(now.year, now.month, now.day)) ??
//                                   -1) >=
//                               0;
//                         })
//                         .map((x) => _makeRow(x))
//                         .toList(),
//                   );
//                 }),
//           ],
//         ),
//       )),
//     );
//   }

  // List<DataColumn> _makeColumns() {
  //   List<DataColumn> columns = [];
  //   // List<String> labels = ['開始', '終了', '時間', 'カテゴリ', '内容'];
  //   // List<bool> isNumericList = [true, true, true, false, false];
  //
  //   List<String> labels = ['', '開始', '終了', '時間', '内容', '編集'];
  //   List<bool> isNumericList = [false, true, true, true, false, false];
  //   for (int i = 0; i < labels.length; i++) {
  //     columns.add(DataColumn(
  //       numeric: isNumericList[i],
  //       label: Expanded(
  //           child: Center(
  //         child: Text(
  //           labels[i],
  //           style: StyleConsts.fontBold,
  //         ),
  //       )),
  //     ));
  //   }
  //   return columns;
  // }
  //
  // DataRow _makeRow(TimeRecord timeRecord) {
  //   return DataRow(
  //     cells: <DataCell>[
  //       DataCell(timeRecord.isRecording
  //           ? const Icon(Icons.timer_outlined)
  //           : StyleConsts.sizedBox0),
  //       DataCell(SelectableText(timeRecord.formattedStartDateTime)),
  //       DataCell(SelectableText(timeRecord.formattedEndDateTime)),
  //       DataCell(SelectableText(timeRecord.formattedSpanHour)),
  //       // DataCell(SelectableText(timeRecord.category)),
  //       DataCell(SelectableText(timeRecord.content)),
  //       DataCell(timeRecord.isRecording ? StyleConsts.sizedBox0 : IconButton(
  //         icon: const Icon(Icons.edit_outlined),
  //         onPressed: () {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) => _createUpdateDialog(timeRecord),
  //           );
  //         },
  //       )),
  //     ],
  //   );
  // }
  //
  // TextField _createTimeTextField({required TextEditingController controller,required String labelText,required DateTime? dateTime}){
  //   return TextField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       labelText: labelText,
  //       hintText: dateTime == null ? 'hh:mm' : DateFormat.Hm().format(dateTime),
  //       suffixIcon: IconButton(
  //         icon: const Icon(Icons.schedule_outlined),
  //         onPressed: ()async{
  //           var time = await showTimePicker(context: context,initialTime: TimeOfDay(hour: dateTime?.hour ?? 0,minute: dateTime?.minute ?? 0,),);
  //           if(time!=null){
  //             print('時間：${DateFormat.Hm().format(DateTime(1,1,1,time.hour,time.minute))}');
  //             controller.text = DateFormat.Hm().format(DateTime(1,1,1,time.hour,time.minute));
  //           }
  //         },
  //       )
  //     ),
  //   );
  // }
  //
  // _stopRecord() async {
  //   DateTime endTime = DateTime.now();
  //   if (recordingData == null) {
  //     return;
  //   }
  //   setState(() {
  //     list.remove(recordingData);
  //     list.add(recordingData!.copyWith(
  //       endDateTime: endTime,
  //       isRecording: false,
  //     ));
  //   });
  //   await db.create(recordingData!.copyWith(
  //     endDateTime: endTime,
  //     isRecording: false,
  //   ));
  //   recordingData = null;
  // }
  //
  // _startRecord({String content = ''}) async {
  //   await _stopRecord();
  //   recordingData = TimeRecord.fromDateTime(
  //     startDateTime: DateTime.now(),
  //     category: 'テストPJ',
  //     content: content,
  //     isRecording: true,
  //   );
  //   setState(() {
  //     list.add(recordingData!);
  //   });
// =======
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: (){

              },
            ),
          ],
        ),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.timer_outlined),
                  selectedIcon: Icon(Icons.timer),
                  label: Text('計測'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: Text('記録'),
                ),
              ],
              selectedIndex: _navigationIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _navigationIndex = index;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: StyleConsts.padding32,
                  child: _createContent(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _createContent() {
    if (_navigationIndex == 1) {
      return RecordContent(futureRead: futureRead);
    } else {
      return TimerContent(
        futureRead: futureRead,
      );
    }
// >>>>>>> master
  }
}
