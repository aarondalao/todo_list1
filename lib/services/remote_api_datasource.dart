/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_list1/models/todo.dart';
import 'package:todo_list1/services/todo_datasource.dart';
import '../firebase_options.dart';

class RemoteApiDatasource extends TodoDatasource {
  late FirebaseDatabase database;
  late Future initTask;

  RemoteApiDatasource() {
    initTask = Future(() async {
      if (!Firebase.apps.isEmpty && Firebase.apps.length != 0) {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      } else {
        await Firebase.initializeApp();
      }
      database = FirebaseDatabase.instance;
    });
  }

  @override
  Future<bool> addTodo(Todo t) async {
    await initTask;
    final Map<String, dynamic> data = t.toMap();
    DatabaseReference ref = database.ref('todos');

    ref.push().set(data);
    return true;
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    DatabaseReference ref = database.ref().child("todos/${t.id!}");

    ref.remove();

    return true;
  }

  @override
  Future<List<Todo>> getAllTodo() async {
    await initTask;
    List<Todo> todos = <Todo>[];
    final DataSnapshot snapshot = await database.ref('todos').get();

    if (!snapshot.exists) {
      throw Exception(
          "Invalid Request - Cannot find snapshot ${snapshot.ref.path}");
    }
    // 11/11/2022 #1
    final data = Map<String,dynamic>.from(snapshot.value! as Map<dynamic,dynamic>);

    // Map<String,dynamic> x = data.map((key, value) => MapEntry(key as String, value as List));

    data.forEach((key, value) {
      value["id"] = key;
      todos.add(Todo.fromJson(value));
    });

    // 9/11/2022
    // Map<String,dynamic>.from(snapshot.value as Map).forEach((key, value) {
    //   print(value);
    //   print(value['id']);
    //   value['id'] = key;
    //   todos.add(Todo.fromJson(value));
    // });

    return todos;
  }


  // not used
  @override
  Future<List<Map<String, Object?>>> getId(int i) async {
    // DatabaseReference ref = database.ref();
    // final DataSnapshot snapshot = await ref.child('todos').get();
    // if (!snapshot.exists) {
    //   throw Exception(
    //       "Invalid Request - Cannot find snapshot: ${snapshot.ref.path}");
    // }

    throw UnimplementedError();
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    // open data reference with the relative path of "todos/your selected key/id>"
    DatabaseReference ref = database.ref().child("todos/${t.id!}");

    // prepare the data by converting it to a map
    Map<String, dynamic> updatedData = t.toMap();

    // push the updated map data to RTDB
    ref.update(updatedData)
        .then((value) {

    }).catchError((err){
      print(err);
    });

    return true;
  }
}
