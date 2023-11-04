

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'info_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('sample_CRUD');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hive Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false,
        home:  InfoScreen());
  }
}
