/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

// essential imports
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// models
import 'package:todo_list1/models/todo.dart';

// needed for UnmodifiableListView
import 'dart:collection';
import 'package:todo_list1/services/todo_datasource.dart';

import '../services/data_service_manager.dart';

class TodoList extends ChangeNotifier {
  GetIt getIt = GetIt.instance;

  // This is our data model. which holds our data which is a list of To_do’s
  List<Todo> _todos = [];

  // This is an immutable returned list for presenting in the UI
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  // constructor for the refresh method
  TodoList() {
    refresh();
  }

  // a total or court property getter
  int get todoCount {
    return _todos.length;
  }

  // GetIt method refresh
  Future<void> refresh() async {
    _todos = await GetIt.I<TodoDatasource>().getAllTodo();
    notifyListeners();
  }


  Future<void> addTodo(Todo t) async{
    getIt<TodoDatasource>().addTodo(t);
    notifyListeners();
  }

  Future<void> updateTodo(Todo t) async {
    getIt<TodoDatasource>().updateTodo(t);
    notifyListeners();
  }

  Future<void> deleteTodo(Todo t) async {
    getIt<TodoDatasource>().deleteTodo(t);
    notifyListeners();
  }

  // exercise #2
  int countNotCompletedTodos() {
    var totalCount = _todos.where((t) => t.completed == 0).length;
    return totalCount;
    // notifyListeners();
  }

  // exercise 3
  void toggleTask(Todo todo) {
    final taskIndex = _todos.indexOf(todo);
    _todos[taskIndex].toggleCompleted();
    notifyListeners();
  }

// toggle completed tasks/todos
// void toggleTodo(Todo todo){
//   final todoIndex = _todos.indexOf(todo);
//   _todos[todoIndex].toggleCompleted();
//   notifyListeners();
// }

// disregard bottom part as this is using strictly for provider package
//==============================================================================
// void updateTodo(Todo todo){
//   Todo listTodo = _todos.firstWhere((t) => t.name == todo.name);
//   listTodo = todo;
//
//   notifyListeners();
// }
//
// void addTodo(Todo todo){
//   _todos.add(todo);
//   notifyListeners();
// }
//
// void removeALlTodo(){
//   _todos.clear();
//   notifyListeners();
// }
//
// void removeTodo(Todo todo){
//   _todos.remove(todo);
//   notifyListeners();
// }
// =========================END===============================================

}
