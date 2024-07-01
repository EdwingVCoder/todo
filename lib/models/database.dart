import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/todo.dart';

class Database extends ChangeNotifier {
  static late Isar isar;
  static late IsarCollection<Project> projectsCollection;
  static late IsarCollection<Todo> todosCollection;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ProjectSchema, TodoSchema],
      directory: dir.path,
    );
    projectsCollection = isar.projects;
    todosCollection = isar.todos;
  }

  final List<Project> projects = [];
  late Project selectedProject;

  //* Project Functions

  // Create Project
  Future<void> addProject(String text) async {
    final project = Project()..name = text;
    await isar.writeTxn(() => projectsCollection.put(project));
    fetchProjects();
  }

  Future<void> getProject(int id) async {
    final project = await projectsCollection.get(id);
    selectedProject = project!;
    notifyListeners();
  }

  // Get Projects
  Future<void> fetchProjects() async {
    List<Project> fetchedProjects = await projectsCollection.where().findAll();
    projects.clear();
    projects.addAll(fetchedProjects);
    notifyListeners();
  }

  // Update Project
  Future<void> updateProject(int id, String newName) async {
    final project = await projectsCollection.get(id);
    if (project != null) {
      project.name = newName;
      await isar.writeTxn(() => projectsCollection.put(project));
    }
    fetchProjects();
  }

  // Delete Project
  Future<void> deleteProject(int id) async {
    await isar.writeTxn(() => projectsCollection.delete(id));
    fetchProjects();
  }

  //* Todos Functions
  Future<void> addTodo(Project project, String text) async {
    Todo todo = Todo()..text = text;
    int todoId = await isar.writeTxn(() => todosCollection.put(todo));
    todo = (await todosCollection.get(todoId))!;
    project.tasks.add(todo);
    await isar.writeTxn(() => project.tasks.save());
    getProject(selectedProject.id);
  }

  Future<void> checkTodo(int id, value) async {
    final todo = await todosCollection.get(id);
    if (todo != null) {
      todo.completed = value;
      await isar.writeTxn(() => todosCollection.put(todo));
    }
    getProject(selectedProject.id);
  }

  Future<void> deleteTodo(int id) async {
    await isar.writeTxn(() => todosCollection.delete(id));
    getProject(selectedProject.id);
  }
}
