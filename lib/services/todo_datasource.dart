/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:todo_list1/models/todo.dart';

abstract class TodoDatasource {
  Future<List<Todo>> getAllTodo();
  Future<bool> addTodo(Todo t);
  Future<bool> deleteTodo(Todo t);
  Future<List<Map<String, Object?>>> getId(int i);
  Future<bool> updateTodo(Todo t);
}
