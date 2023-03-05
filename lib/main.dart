import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_db_task/model/user_model.dart';
import 'package:local_db_task/view/home_view.dart';
import 'package:local_db_task/viewModel/user_remote_local.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(ResultAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simform Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
          builder: (context, child) => const HomeScreen()),
    );
  }
}
