import 'package:flutter/material.dart';
import 'package:frontend/contexts/todo_context/features/todo_feature/models/todo.dart';
import 'package:frontend/contexts/todo_context/providers/todo_provider.dart';
import 'package:frontend/contexts/todo_context/screens/todo_detail_screen.dart';
import 'package:frontend/contexts/todo_context/screens/todo_list_screen.dart';
import 'package:frontend/shared/components/checkbox_component.dart';
import 'package:frontend/shared/data_structures/list_objects_struct.dart';
import 'package:frontend/shared/dialogs/warning_dialog.dart';
import 'package:frontend/shared/functions/run_and_display_snackbar.dart';
import 'package:frontend/shared/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()..fetchTodos()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.mode,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: HomePage(title: 'To Do'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ListObjectsStruct<Todo> _listObjectsStruct = ListObjectsStruct();

  List<AppBar> appbars = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.todos;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    Color backgroundColor = Theme.of(context).colorScheme.onPrimary;

    Widget switchThemeWidget = Switch(
      value: themeProvider.mode != ThemeMode.light,
      onChanged: (value) => themeProvider.toggleTheme(!value),
    );

    appbars = [
      AppBar(
        backgroundColor: backgroundColor,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                for (var todo in todos) {
                  bool contains = _listObjectsStruct.contains(
                    (obj) => obj.id == todo.id,
                  );

                  if (contains) continue;

                  _listObjectsStruct.add(todo);
                }
              });
            },
            icon: Icon(Icons.select_all_rounded),
          ),
          switchThemeWidget,
        ],
      ),
      AppBar(
        backgroundColor: backgroundColor,
        title: Text("${_listObjectsStruct.objects.length} Selected"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _listObjectsStruct.clear();
              });
            },
            icon: Icon(Icons.close),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                for (var todo in todos) {
                  bool contains = _listObjectsStruct.contains(
                    (obj) => obj.id == todo.id,
                  );

                  if (contains) continue;

                  _listObjectsStruct.add(todo);
                }
              });
            },
            icon: Icon(Icons.select_all_rounded),
          ),
          IconButton(
            onPressed: () async {
              List<String> titles = _listObjectsStruct.objects
                  .map((obj) => obj.title)
                  .toList();

              showWarningDialog(
                context: context,
                title: Text("Delete Todo"),
                content: Text(
                  "Warning! Are you sure you want to delete to-do: {{ $titles }} ",
                ),
                commit: () async {
                  setState(() async {
                    runAndDisplaySnackbar(
                      context: context,
                      onSuccessSnackBar: () =>
                          SnackBar(content: Text("to-dos have been deleted")),
                      onErrorSnackBar: (error) =>
                          SnackBar(content: Text(error.toString())),
                      func: () async {
                        await todoProvider.deleteTodos(
                          _listObjectsStruct.objects
                              .map((obj) => obj.id)
                              .toList(),
                        );
                        setState(() {
                          _listObjectsStruct.clear();
                        });
                      },
                    );
                  });
                },
              );
              try {} catch (_) {}
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
          switchThemeWidget,
        ],
      ),
    ];

    return Scaffold(
      appBar: appbars[_listObjectsStruct.objects.isEmpty ? 0 : 1],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("${todos.length} To-Dos"),
            ),
            Expanded(
              child: TodoListScreen<Todo>(
                todos: todos,
                listWidget: (item) {
                  return Row(
                    children: [
                      Expanded(
                        child: CheckboxComponent(
                          value: _listObjectsStruct.contains(
                            (obj) => obj.id == item.id,
                          ),
                          widget: ListTile(
                            title: Text(item.title),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TodoDetailScreen(todoId: item.id),
                                ),
                              );
                            },
                          ),
                          onChanged: (state) {
                            setState(() {
                              if (state) {
                                bool contains = _listObjectsStruct.contains(
                                  (obj) => obj.id == item.id,
                                );

                                if (contains) return;
                                _listObjectsStruct.add(item);
                              } else {
                                _listObjectsStruct.remove((obj) {
                                  return obj.id == item.id;
                                });
                              }
                            });
                          },
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          showWarningDialog(
                            context: context,
                            title: Text("Delete Todo"),
                            content: Text(
                              "Warning! Are you sure you want to delete to-do: {{ ${item.title} }} ",
                            ),
                            commit: () async {
                              setState(() async {
                                runAndDisplaySnackbar(
                                  context: context,
                                  onSuccessSnackBar: () => SnackBar(
                                    content: Text(
                                      "to-do: {{ ${item.title} }} has been deleted",
                                    ),
                                  ),
                                  onErrorSnackBar: (error) =>
                                      SnackBar(content: Text(error.toString())),
                                  func: () async {
                                    await todoProvider.deleteTodo(item.id);

                                    _listObjectsStruct.remove(
                                      (obj) => obj.id == item.id,
                                    );
                                  },
                                );
                              });
                            },
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showCreateTodoDialog(context),
      ),
    );
  }

  Future<void> showCreateTodoDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 600,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? "Title can not be empty"
                        : null,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await todoProvider.createTodo(
                    uuid.v4(),
                    titleController.text.trim(),
                    descController.text.trim(),
                    (DateTime.now().millisecondsSinceEpoch / 1000),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
