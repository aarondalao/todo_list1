/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject{
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int? completed = 0;

  Todo({
    this.id,
    this.name,
    this.description,
    this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed': completed,
    };
  }

  factory Todo.fromJson(Map<dynamic, dynamic> fechedData) {
    return Todo(
      id: fechedData['id'],
      name: fechedData['name'],
      description: fechedData['description'],
      completed: fechedData['completed'] ?? 0,
    );
  }


  // sqflite DOES NOT SUPPORT BOOL DATA TYPE.
  // therefore, 1's and 0's for truthy and falsy will do.

  int toggleCompleted() {
    if (completed == 0) {
      completed = completed! + 1;
    } else {
      completed = completed! - 1;
    }
    return completed!;
  }
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(
      id: reader.read(0),
      name: reader.read(1),
      description: reader.read(2),
      completed: reader.read(3),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.completed);
  }
}
