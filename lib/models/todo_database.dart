import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/models/todo.dart';

class TodoDatabase extends ChangeNotifier {
  static late Isar isar;
  static late IsarCollection<Todo> todosCollection;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoSchema],
      directory: dir.path,
    );
    todosCollection = isar.todos;
  }

  final List<Todo> todos = [];

  Future<void> addTodo(String text) async {
    final todo = Todo()..text = text;
    await isar.writeTxn(() => todosCollection.put(todo));
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    List<Todo> fetchedTodos = await todosCollection.where().findAll();
    todos.clear();
    todos.addAll(fetchedTodos);
    notifyListeners();
  }

  Future<void> updateNote(int id, String newText) async {
    final todo = await todosCollection.get(id);
    if (todo != null) {
      todo.text = newText;
      await isar.writeTxn(() => todosCollection.put(todo));
    }
    fetchTodos();
  }

  Future<void> checkTodo(int id, value) async {
    final todo = await todosCollection.get(id);
    if (todo != null) {
      todo.completed = value;
      await isar.writeTxn(() => todosCollection.put(todo));
    }
    fetchTodos();
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => todosCollection.delete(id));
    fetchTodos();
  }
}
