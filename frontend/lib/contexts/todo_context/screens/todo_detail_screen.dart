import 'package:flutter/material.dart';
import 'package:frontend/contexts/todo_context/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodoDetailScreen extends StatefulWidget {
  final String todoId;
  const TodoDetailScreen({super.key, required this.todoId});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late TextEditingController _controller;
  late TextEditingController _descriptionController;
  late DateTime dateTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final todo = Provider.of<TodoProvider>(
      context,
      listen: false,
    ).todos.firstWhere((t) => t.id == widget.todoId);
    _controller = TextEditingController(text: todo.title);
    _descriptionController = TextEditingController(text: todo.description);

    dateTime = DateTime.fromMillisecondsSinceEpoch(
      (todo.created * 1000).toInt(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    String dtStr = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit ToDo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Created on: $dtStr"),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Text("Title"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? "Title can not be empty"
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  label: Text("Description"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  try {
                    await todoProvider.updateTodo(
                      widget.todoId,
                      _controller.text,
                      _descriptionController.text,
                    );
                    if (context.mounted) Navigator.pop(context);
                  } catch (_) {}
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
