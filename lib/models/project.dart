import 'package:isar/isar.dart';

import 'todo.dart';

part 'project.g.dart';

@collection
class Project {
  Id id = Isar.autoIncrement;
  late String name;
  @Backlink(to: 'project')
  final tasks = IsarLinks<Todo>();
}
