import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/project.dart';
import 'package:todo/models/database.dart';
import 'package:todo/pages/project_page.dart';

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
    readProjects();
  }

  void readProjects() {
    context.read<Database>().fetchProjects();
  }

  void createProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Proyecto'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Nombre proyecto...',
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
                context.read<Database>().addProject(textController.text);
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text('Crear'))
        ],
      ),
    );
  }

  void deleteProject(int id) {
    context.read<Database>().deleteProject(id);
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<Database>();

    List<Project> projects = database.projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createProject(),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];

            return ListTile(
              title: Text(
                project.name,
              ),
              trailing: IconButton(
                  onPressed: () => deleteProject(project.id),
                  icon: const Icon(Icons.delete_outline)),
              onTap: () {
                database.selectedProject = project;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectPage(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
