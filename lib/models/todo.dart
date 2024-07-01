import 'package:isar/isar.dart';
import 'package:todo/models/project.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;
  late String text;
  bool completed = false;
  final project = IsarLink<Project>();
}
