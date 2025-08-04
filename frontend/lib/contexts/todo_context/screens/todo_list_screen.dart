import 'package:flutter/material.dart';
import 'package:frontend/contexts/todo_context/features/todo_feature/models/todo.dart';

class TodoListScreen<T> extends StatelessWidget {
  final Widget Function(T item) listWidget;
  final List<Todo> todos;

  const TodoListScreen({
    super.key,
    required this.listWidget,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, index) {
        final T todo = todos[index] as T;
        return listWidget(todo);
      },
    );
  }
}
