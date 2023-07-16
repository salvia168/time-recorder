import 'package:flutter/material.dart';

import 'consts/style_consts.dart';
import 'ui/pages/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(titleSpacing: StyleConsts.value32),
      ),
      home: const MyHomePage(title: 'タイム レコーダー'),
    );
  }
}