/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */
// essential imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:todo_list1/services/todo_datasource.dart';

// data model imports:
import 'models/todo.dart';

// providers
import 'providers/todo_list.dart';

// optional imports (helpers/ screens)
// screen sizes helper to minimize screen size defects
import 'package:todo_list1/screen_size_helper.dart';
import 'package:todo_list1/custom widgets/todo_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // form state = this is to indetify the state of the form
  final _formKey = GlobalKey<FormState>();

  // instantiate GetIt
  GetIt getIt = GetIt.instance;

  // instantiate controllers to handle inputs
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

  // declare variables
  String taskName = "";
  String taskDescription = "";

  TodoList tl = TodoList();

  @override
  void initState() {
    _controlName.addListener(() {
      taskName = _controlName.text;
    });
    _controlDescription.addListener(() {
      taskName = _controlDescription.text;
    });

    super.initState();
  }

  @override
  void dispose() {
    // Hive.box('todos_box').compact();
    Hive.close();
    super.dispose();
  }

  // opening an alert dialog to create a new to do list
  void _openAddTodoWidget() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text('Add a new Todo'),
          ),
        ),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 100,
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // title label text

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Text('Todo Name'),
                  ),

                  // title text form field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: TextFormField(
                      controller: _controlName,
                      decoration:
                          const InputDecoration(hintText: "your title here"),
                      inputFormatters: [
                        // dunno why this does not allow to input ANY CHARACTERS
                        // even with allow method
                        // FilteringTextInputFormatter.allow(
                        //   RegExp(r"""^(?=.*[A-Z0-9])[\w.,!"'?\/$ ]+$"""),
                        // )

                        // deny () and {} inputs
                        FilteringTextInputFormatter.deny(
                          RegExp(r"[{}]*[()]*[\[\]]*"),
                        ),
                      ],
                      onFieldSubmitted: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "must not be empty";
                        }
                      },
                    ),
                  ),

                  // content label text
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Text('Description'),
                  ),

                  // content text form field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "your todos description here"),
                      onFieldSubmitted: (value) {},
                      inputFormatters: [
                        // dunno why this does not allow to input ANY CHARACTERS
                        // even with allow method
                        // FilteringTextInputFormatter.allow(
                        //   RegExp(r"""^(?=.*[A-Z0-9])[\w.,!"'?\/$ ]+$"""),
                        // )

                        // deny () and {} inputs
                        FilteringTextInputFormatter.deny(
                          RegExp(r"[{}]*[()]*[\[\]]*"),
                        ),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "must not be empty";
                        }
                      },
                      controller: _controlDescription,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // go back button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text("Go back"),
                        ),
                      ),

                      // Submit button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // OLD WAY
                            // setState(() {
                            //   // pass in the to_do object by calling the constructor passing through the controller.text property
                            //   todos.add(To_do(
                            //     name: _controlName.text,
                            //     description: _controlDescription.text,
                            //   ));
                            // });

                            // other way
                            // context.read<TodoList>().add(
                            //       To_do(
                            //           name: _controlName.text,
                            //           description: _controlDescription.text),
                            //     );

                            // 13/11/2022
                            // this will be transfered to provider to_do_list.dart
                            // using getIt
                            // getIt<TodoDatasource>().addTodo(Todo(
                            //   name: _controlName.text,
                            //   description: _controlDescription.text,
                            //   completed: 0, // default
                            // ));
                            //
                            // _controlName.clear();
                            // _controlDescription.clear();
                            // setState(() {});

                            try {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // provider
                                Provider.of<TodoList>(context, listen: false)
                                    .addTodo(Todo(
                                  name: _controlName.text,
                                  description: _controlDescription.text,
                                  completed: 0, // default
                                ));
                                _controlName.clear();
                                _controlDescription.clear();
                              }
                            } catch (e) {
                              print("Error: $e");
                            } finally {
                              setState(() {});
                              tl.refresh();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Todo List'),
        // ===============================================================================
        // exercise 2
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            child: Consumer<TodoList>(builder: (context, model, child) {
              return Text(
                "total incomplete todos : ${model.countNotCompletedTodos()}",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
        ],
      ),
      //=====================================================================================

      body: SafeArea(
        child: Container(
          // lay outing
          // padding: const EdgeInsets.all(5.0),
          // margin: const EdgeInsets.all(20.0),
          width: displayWidth(context),
          height: displayHeight(context),

          //box decoration
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),

          // Provider Consumer. not loading instantaneously
          child: Consumer<TodoList>(
            builder: (context, model, child) {
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                    itemCount: model.todoCount,
                    itemBuilder: (BuildContext build, int i) {
                      return TodoWidget(todo: model.todos[i]);
                    }),
              );
            },
          ),

          // FutureBuilder. this loads as soon as onPressed fires
          // child: FutureBuilder(
          //   initialData: [],
          //   future: GetIt.I<TodoDatasource>().getAllTodo(),
          //   builder: (context, AsyncSnapshot snapshot) {
          //     return ListView.builder(
          //         itemCount: snapshot.data.length,
          //         itemBuilder: (context, index) {
          //           return TodoWidget(todo: snapshot.data[index]);
          //         });
          //   },
          // ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        // below is REFERENCING the function _openAddTodo
        onPressed: _openAddTodoWidget,

        // below is CALLING the function _openAddTodo
        // onPressed: (){
        //  _openAddTodo();
        // },

        focusElevation: 100.0,
        tooltip: 'add a new todo item',
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
