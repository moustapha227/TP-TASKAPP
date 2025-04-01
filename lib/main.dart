import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/pages/add_task.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/theme/theme_provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      //theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {"addTask": (context) => AddTask()},
    );
  }
}
