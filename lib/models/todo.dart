import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;
  late String text;
  bool completed = false;
}
