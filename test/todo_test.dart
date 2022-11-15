/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list1/models/todo.dart';

void main() {
  // unit test for to_do model

  // test mockups : ARRANGE
  final mockTodo1 = Todo(
      id: 'mockId1',
      name: 'mockTodoName1',
      description: 'mockTodoDescription1',
      completed: 0);

  final Map<String, dynamic> mockTodo2 = {
    'id': "mockId1",
    'name': "mockTodoName1",
    'description': "mockTodoDescription1",
    'completed': 0,
  };

  final Map<String, dynamic> mockTodo3 = {
    'id': "null",
    'name': "null",
    'description': "null",
    'completed': 1,
  };

  final testTodo1 = Todo(completed: 0);
  final testTodo2 = Todo(completed: 1);



  test('test #1: check if model is working as it should', () {
    expect(mockTodo1.id, 'mockId1');
    expect(mockTodo1.name, 'mockTodoName1');
    expect(mockTodo1.description, 'mockTodoDescription1');
    expect(mockTodo1.completed, 0);
  });

  test("test #2: check if this is still working", () {
    expect(mockTodo2["id"], "mockId1" );
    expect(mockTodo2["name"], "mockTodoName1" );
    expect(mockTodo2["description"], "mockTodoDescription1" );
    expect(mockTodo2["completed"], 0 );
  });

  test("test #3: check if this is still working", () {
    expect(mockTodo3["id"], "null" );
    expect(mockTodo3["name"], "null" );
    expect(mockTodo3["description"], "null" );
    expect(mockTodo3["completed"], 1 );
  });

  test("Test #4: completed toggle must change if the value is either 0 or 1", () {

    // act
    var actualValueTestTodo1 = 1;
    var actualValueTestTodo2 = 0;

    // assert
    expect(testTodo1.toggleCompleted(), actualValueTestTodo1);
    expect(testTodo2.toggleCompleted(), actualValueTestTodo2);
  });

  test("test #5: test toMap()", () {

    Map<String,dynamic> testTodoMap = {
      'id': "mockId1",
      'name': "mockTodoName1",
      'description': "mockTodoDescription1",
      'completed': 0,
    };

    expect(mockTodo1.toMap(), testTodoMap);
  });

}
