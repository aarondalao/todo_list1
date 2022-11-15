/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list1/models/todo.dart';
import 'package:todo_list1/services/todo_datasource.dart';

// not needed anymore as id generation can be fixed as simple as .length.
// import 'package:uuid/uuid.dart';
// import 'dart:math';

class LocalHiveDatasource implements TodoDatasource {
  bool initialised = false;

  LocalHiveDatasource() {
    init();
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    Box myBox = await Hive.openBox('todos_box');
    initialised = true;
  }

  @override
  Future<bool> addTodo(Todo t) async {
    Box myBox = await Hive.openBox('todos_box');

    // instance of the model to map approach
    // conversion of todos model to map
    Map<String, dynamic> todoToMap = t.toMap();

    // convert total count of existing entries in the box to string
    String contentCountToString = myBox.length.toString();
    // int contentCount = myBox.length;
    // String contentCountToString = contentCount.toString();

    // assign the length of the box into the mapped data called todoToMap with key of 'id'
    todoToMap['id'] = contentCountToString;

    // id prefer put instead of add so i have a bit of control to the key
    // push the data with the key as the id of todoToMap, and the mapped data
    // myBox.add(todoToMap);
    myBox.put(todoToMap['id'], todoToMap);


    return true;
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    Box myBox = await Hive.openBox('todos_box');

    // for (var k in retrievedMapData.keys) {
    //   if (retrievedMapData[k]['id'] == t.id) {
    //     matchedId = k;
    //     // container = retrievedMapData[k];
    //   }
    // }
    //
    // myBox.deleteAt(matchedId);

    // List<Todo> myList = myBox.toMap();

    // different approach than the one Lecturer Aaron Clifford showed me
    // since they're using List. but the steps is still same

    // get the iterable List inside the box as a Map with type <dynamic, dynamic>
    // Map<dynamic, dynamic> retrievedMapData = myBox.toMap();

    // remove the item inside the map with an index of t.id,
    // retrievedMapData.remove(t.id);

    // refresh the box
    // myBox.deleteAll(myBox.keys);

    // insert each map items inside the box
    // retrievedMapData.forEach((key, value) {
    //   myBox.put(key, value);
    //
    // });

    // one last iteration from aaron's key notes 9/11/2022
    // get the contents of the box and store it as a list
    // below works if the id is int. no idea why it only works with that condition
    // List retrievedTodos = myBox.values.cast<Map<String, dynamic>>().toList();  <-- 9/11/2022

    List retrievedTodos = myBox.values.toList();


    // remove the item inside the map with an index of t.id,
    int i = int.parse(t.id!);
    retrievedTodos.removeAt(i);

    // refresh the box
    myBox.deleteAll(myBox.keys);

    // insert each list items inside the box
    for(int i = 0; i < retrievedTodos.length; i++){
      String indexToString = i.toString();
      myBox.put(indexToString,retrievedTodos[i]);
    }

    return true;
  }

  @override
  Future<List<Todo>> getAllTodo() async {
    Box myBox = await Hive.openBox('todos_box');
    if (myBox.isNotEmpty) {
      Map<dynamic, dynamic> retrievedMapData = myBox.toMap();



      return List.generate(retrievedMapData.length, (index) {
        String indexToString = index.toString();
        return Todo(
          id: retrievedMapData[indexToString]['id'],
          name: retrievedMapData[indexToString]['name'],
          description: retrievedMapData[indexToString]['description'],
          completed: retrievedMapData[indexToString]['completed'],
        );
      });
    } else {
      return <Todo>[];
    }

    // final data = myBox.keys.map((key) {
    //   final value = myBox.get(key);
    //   return Todo(
    //       id: key,
    //       name: value["name"],
    //       description: value['description'],
    //       completed: value['completed']);
    // }).toList();
    // return data;
  }

  // not used.
  @override
  Future<List<Map<String, Object?>>> getId(int i) async {
    Box myBox = await Hive.openBox('todos_box');
    final todoItem = myBox.getAt(i);

    return todoItem;
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    // open the box
    Box myBox = await Hive.openBox('todos_box');

    // prepare the new data and fill it into a map with a key of string and a value of dynamic
    final Map<String, dynamic> todoToMap = t.toMap();

    // put the new data with the key equal to the instance of to_do with a property of id,
    // and new mapped data
    myBox.put(t.id!, todoToMap);


    return true;
  }
}
