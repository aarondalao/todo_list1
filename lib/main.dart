/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* resources used:
  https://www.youtube.com/watch?v=dB0dOnc2k10
  https://www.youtube.com/watch?v=JVpFNfnuOZM&list=PLMQAFLQy-nKch8Tk31y4i6MxMI9V9C-XO
  
* */

// essential imports
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//optional/ theming imports
import 'package:google_fonts/google_fonts.dart';

// providers
import 'package:provider/provider.dart';
import 'package:todo_list1/services/todo_datasource.dart';

// data model imports

import 'package:todo_list1/services/data_service_manager.dart';
import 'providers/todo_list.dart';

// screens imports
import 'package:todo_list1/homepage.dart';

// hive imports
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

GetIt myLocator = GetIt.instance;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  myLocator.registerLazySingleton<TodoDatasource>(() => DataServiceManager());
  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const TodoApp(
      myTitle: 'Todo List Application by Aaron Dalao',
    ),
  ));
}

class TodoApp extends StatelessWidget {
  final String myTitle;

  const TodoApp({
    super.key,
    required this.myTitle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // theming goes here
      theme: ThemeData(
        fontFamily: GoogleFonts.quicksand().fontFamily,
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.red[800],
        ),
        primarySwatch: Colors.deepPurple,
      ),
      title: myTitle,

      home: const Homepage(),
    );
  }
}
