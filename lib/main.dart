import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/database.dart';
import 'package:todo/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Database(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
