import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Todo {
  late String _id;
  String title;
  String description;
  double created;

  String get id => _id;

  Todo({
    String? id,
    required this.title,
    required this.description,
    required this.created,
  }) {
    _id = id ?? uuid.v4();
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      created: json['created'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'created': created};
  }
}
