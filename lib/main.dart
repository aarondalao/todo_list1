/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* resources used for splash screen and icons:
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



main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerLazySingleton<TodoDatasource>(() => DataServiceManager());
  runApp(
    const TodoApp(
      myTitle: 'Todo List Application by Aaron Dalao',
    ),
  );
}

class TodoApp extends StatelessWidget {
  final String myTitle;

  const TodoApp({
    super.key,
    required this.myTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TodoList(),
      child: Consumer(
        builder: (context, tList, child) => MaterialApp(
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
        ),
      ),
    );
  }
}
