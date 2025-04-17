import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/models/task_provider.dart';
import 'package:task/pages/add_task.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/services/local_notifications.dart';
import 'package:task/theme/theme_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Niamey'));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
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
      routes: {"addTask": (context) => AddTask()},
    );
  }
}
