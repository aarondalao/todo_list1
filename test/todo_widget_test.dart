/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list1/main.dart';
import 'package:todo_list1/homepage.dart';

void main(){

  testWidgets("todo list widget has a title and a message", (WidgetTester tester) async{

    // trigger a frame using title
    await tester.pumpWidget(const TodoApp(myTitle: "hello world this is a test!"));
  });
}