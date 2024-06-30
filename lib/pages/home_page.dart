import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/models/todo_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readTodos();
  }

  void readTodos() {
    context.read<TodoDatabase>().fetchTodos();
  }

  void createTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Tarea'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Comprar comida...',
          ),
        ),
        actions: [
          FilledButton.tonal(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text('Cancelar')),
          FilledButton.tonal(
              onPressed: () {
                context.read<TodoDatabase>().addTodo(textController.text);
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text('Crear'))
        ],
      ),
    );
  }

  void setChecked(int id, bool? value) {
    context.read<TodoDatabase>().checkTodo(id, value);
  }

  void deleteTask(int id) {
    context.read<TodoDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final todoDatabase = context.watch<TodoDatabase>();

    List<Todo> todos = todoDatabase.todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('T O - D O'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createTodo(),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return ListTile(
              title: Text(
                todo.text,
                style: TextStyle(
                  decoration: todo.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: todo.completed,
                    onChanged: (value) => setChecked(todo.id, value),
                  ),
                  IconButton(
                      onPressed: () => deleteTask(todo.id),
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
