/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list1/models/todo.dart';
import 'package:todo_list1/services/todo_datasource.dart';

class LocalSQLiteDatasource implements TodoDatasource {
  late final Database database;
  bool initialised = false;

  LocalSQLiteDatasource() {
    init();
  }

  Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: ((db, version) async {
        return db.execute(
            'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, completed INTEGER)');
      }),
      version: 1,
    );
    initialised = true;
  }

  @override
  Future<bool> addTodo(Todo t) async {
    await database
        .insert('todos', t.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {});
    print("successful ======================================");
    return true;
  }

  @override
  Future<List<Todo>> getAllTodo() async {
    if (!initialised) return <Todo>[];

    List<Map<String, dynamic>> maps = await database.query('todos');

    print("===================================================================");
    print(maps);

    print("===================================================================");

    return List.generate(maps.length, (index) {
      return Todo(
        id: maps[index]['id'].toString(),
        name: maps[index]['name'],
        description: maps[index]['description'],
        completed: maps[index]['completed'],
      );
    });
  }

  @override
  Future<bool> deleteTodo(Todo t) async {

    await database.delete('todos', where: "id = ?", whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<Map<String, Object?>>> getId(int i) async {
    // var result = database.query('todos', where: 'id = ?', whereArgs: [i]);
    List<Map<String, Object?>> qwer =
        await database.rawQuery("SELECT * FROM todos WHERE id = $i");
    return qwer;
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    await database
        .update('todos', t.toMap(), where: "id = ? ", whereArgs: [t.id]);
    // todo: delete the print after test
    return true;
  }
}
