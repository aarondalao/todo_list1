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
    'id': null,
    'name': null,
    'description': null,
    'completed': 1,
  };

  final testTodo1 = Todo(completed: 0);
  final testTodo2 = Todo(completed: 1);

  test('test #1: check if model is working as it should', () {
    print("test #1: check model is working with mocked values");
    print("""
    Display actual mock data:
    id: 'mockId1'
    name: 'mockTodoName11'
    description: "mockTodoDescription1"
    completed: 0
    """);

    expect(mockTodo1.id, equals('mockId1'),
        reason: "the expected value should match the actual value");
    expect(mockTodo1.name, equals("mockTodoName1"),
        reason: "the expected value should match the actual value");
    expect(mockTodo1.description, equals('mockTodoDescription1'),
        reason: "the expected value should match the actual value");
    expect(mockTodo1.completed, equals(0),
        reason: "the expected value should match the actual value");
    print("==================================================================");
  });

  test("test #2: check if this is still working", () {
    print("test #2: check model is working with null values");
    print("""
    Display actual mock data:
    id: null
    name: null
    description: null
    completed: 1
    """);
    expect(mockTodo2["id"], equals(null),
        reason: "the expected value should match the actual value");
    expect(mockTodo2["name"], equals(null),
        reason: "the expected value should match the actual value");
    expect(mockTodo2["description"], equals(null),
        reason: "the expected value should match the actual value");
    expect(mockTodo2["completed"], equals(1),
        reason: "the expected value should match the actual value");
    print("==================================================================");
  });

  test("Test #3: completed toggle must change if the value is either 0 or 1",
      () {
    // act
    var actualValueTestTodo1 = 1;
    var actualValueTestTodo2 = 0;

    print("""
      Display actual mock data:
      actualValueTestTodo1 is = $actualValueTestTodo1
      actualValueTestTodo2 is = $actualValueTestTodo2
    """);
    // assert
    expect(testTodo1.toggleCompleted(), equals(actualValueTestTodo1),
        reason: "the expected value should match the actual value");
    expect(testTodo2.toggleCompleted(), equals(actualValueTestTodo2),
        reason: "the expected value should match the actual value");
    print("==================================================================");
  });

  test("test #4: test toMap()", () {
    Map<String, dynamic> testTodoMap = {
      'id': "mockId1",
      'name': "mockTodoName1",
      'description': "mockTodoDescription1",
      'completed': 0,
    };

    print("""
    Display actual mock data:
      testTodoMap = {
      'id': "mockId1",
      'name': "mockTodoName1",
      'description': "mockTodoDescription1",
      'completed': 0,
    };
    """);

    expect(mockTodo1.toMap(), equals(testTodoMap),
        reason: "the expected value should match the actual value");
  });
}
