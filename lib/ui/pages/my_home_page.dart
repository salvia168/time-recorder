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
  int _navigationIndex = 0;
  final RecordData _recordData = RecordData();
  DbBase db = CsvDb();
  Future<List<TimeRecord>> futureRead = Future<List<TimeRecord>>(() {
    return [];
  });

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
        appBar: AppBar(
          title: Text(widget.title),
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
