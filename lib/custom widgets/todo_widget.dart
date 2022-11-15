/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */
// essential imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:todo_list1/providers/todo_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list1/services/data_service_manager.dart';
import 'package:todo_list1/services/todo_datasource.dart';

import '../models/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;

  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  // form state = this is to indetify the state of the form
  final _formKey = GlobalKey<FormState>();

  bool? completedSwitch = false; // default

  TodoList tl = TodoList();
  GetIt getIt = GetIt.instance;

  // instantiate controllers to handle inputs
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _updateTodoWidget();
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: "update",
            ),
          ],
        ),

        // swipe right to engage Delete Action Pane
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              deleteConfirmation();
            },
          ),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                deleteConfirmation();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "delete",
            ),
          ],
        ),
        child: CheckboxListTile(
          activeColor: Colors.deepPurple[100],
          controlAffinity: ListTileControlAffinity.leading,
          // align the checkbox to the left
          title: Text(widget.todo.name!),
          subtitle: Text("${widget.todo.description} "),
          value: completedSwitch,
          onChanged: (newValue) {
            Provider.of<TodoList>(context, listen: false)
                .toggleTask(widget.todo);
            setState(() {
              completedSwitch = newValue;
              // todo
              // Provider.of<TodoList>(context, listen: false).updateTodo(widget.todo);
            });
          },
        ),
      ),
    );
  }

  void deleteConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text("Hang on a sec..."),
                  )),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                        "Skipping your todos i see ey, are you sure though? "),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("nope")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              try {
                                getIt<TodoDatasource>().deleteTodo(widget.todo);

                                Navigator.of(context, rootNavigator: true).pop(
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${widget.todo.name} deleted"))));
                              } catch (e) {
                                print("Error: $e");
                              } finally {
                                setState(() {});
                                tl.refresh();
                              }
                            },
                            child: const Text("yep")),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  void _updateTodoWidget() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text('Update this Todo'),
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
                      inputFormatters: [
                        // dunno why this does not allow to input ANY CHARACTERS
                        // even with allow method
                        // FilteringTextInputFormatter.allow(
                        //   RegExp(r"""^(?=.*[A-Z0-9])[\w.,!"'?\/$ ]+$"""),
                        // )

                        // deny () and {} inputs
                        FilteringTextInputFormatter.deny(
                          RegExp(r"[{}]*[()]*"),
                        ),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "must not be empty";
                        }
                      },
                      controller: _controlName,
                      decoration: InputDecoration(hintText: widget.todo.name),
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
                      controller: _controlDescription,
                      decoration:
                          InputDecoration(hintText: widget.todo.description),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text('Go back'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            try {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // provider
                                Provider.of<TodoList>(context, listen: false)
                                    .updateTodo(Todo(
                                  id: widget.todo.id,
                                  name: _controlName.text,
                                  description: _controlDescription.text,
                                  completed: widget.todo.completed,
                                ));
                                _controlName.clear();
                                _controlDescription.clear();
                              }

                              Navigator.of(context, rootNavigator: true).pop(
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                content: Text("${widget.todo.name} updated"),
                              )));
                            } catch (e) {
                              print("Error: $e");
                            } finally {
                              setState(() {});
                              tl.refresh();
                            }

                            // getIt<DataServiceManager>()
                            //     .updateTodo(Todo(
                            //   id: widget.todo.id,
                            //   name: _controlName.text,
                            //   description: _controlDescription.text,
                            //   completed: widget.todo.completed,
                            // ))
                            //     .then((value) {
                            //   tl.refresh();
                            //   Navigator.of(context, rootNavigator: true).pop(
                            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //           content: Text("${widget.todo.name} updated"))));
                            // });
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
}
