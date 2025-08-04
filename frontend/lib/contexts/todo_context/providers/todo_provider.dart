import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/contexts/todo_context/features/todo_feature/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final String baseUrl = 'http://localhost:3000';

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    final res = await http.get(Uri.parse('$baseUrl/todos'));
    _todos = (json.decode(res.body) as List)
        .map((e) => Todo.fromJson(e))
        .toList();

    notifyListeners();
  }

  Future<void> createTodo(
    String id,
    String title,
    String description,
    double created,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "title": title,
        "description": description,
        "created": created,
      }),
    );

    if (!(res.statusCode >= 200 && res.statusCode <= 299)) {
      throw "Todo create request failed";
    }

    await fetchTodos();
  }

  Future<void> updateTodo(String id, String title, String description) async {
    var res = await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"title": title, "description": description}),
    );

    if (!(res.statusCode >= 200 && res.statusCode <= 299)) {
      throw "Todo update request failed";
    }

    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].title = title;
      _todos[index].description = description;
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    var res = await http.delete(Uri.parse('$baseUrl/todos/$id'));

    if (!(res.statusCode >= 200 && res.statusCode <= 299)) {
      throw "Todo delete request failed";
    }

    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  Future<void> deleteTodos(List<String> ids) async {
    var res = await http.delete(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"ids": ids}),
    );

    if (!(res.statusCode >= 200 && res.statusCode <= 299)) {
      throw "Todo delete multiple, request failed";
    }

    for (var id in ids) {
      _todos.removeWhere((todo) => todo.id == id);
    }

    notifyListeners();
  }
}
