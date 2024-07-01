import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/database.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/todo.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final taskController = TextEditingController();

  void createTask(Project project) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Crear Tarea'),
              content: TextField(
                controller: taskController,
                decoration: const InputDecoration(hintText: 'Nombre tarea'),
              ),
              actions: [
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.pop(context);
                    taskController.clear();
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.pop(context);
                    debugPrint('Todo: ${taskController.text}');
                    context
                        .read<Database>()
                        .addTodo(project, taskController.text);
                    taskController.clear();
                  },
                  child: const Text('Crear'),
                )
              ],
            ));
  }

  void setChecked(int id, bool? value) {
    context.read<Database>().checkTodo(id, value);
  }

  void deleteTask(int id) {
    context.read<Database>().deleteTodo(id);
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<Database>();

    Project project = database.selectedProject;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createTask(project),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: project.tasks.length,
          itemBuilder: (context, index) {
            List<Todo> todos = project.tasks.toList();
            var task = todos[index];
            return ListTile(
              title: Text(
                task.text,
                style: TextStyle(
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: task.completed,
                      onChanged: (value) => setChecked(task.id, value)),
                  IconButton(
                      onPressed: () => deleteTask(task.id),
                      icon: const Icon(Icons.delete_outline))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
