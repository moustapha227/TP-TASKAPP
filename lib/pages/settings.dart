import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task/models/task_provider.dart';
import 'package:task/services/local_notifications.dart';
import 'package:task/theme/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool globalNotificationsActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.only(left: 25, right: 20, top: 10),
        decoration: BoxDecoration(
          //color: const Color.fromARGB(255, 249, 250, 250),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                CupertinoSwitch(
                  value:
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).isDarkMode,
                  onChanged:
                      (value) =>
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).toggleTheme(),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activer Notifications",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                CupertinoSwitch(
                  value: globalNotificationsActive,
                  onChanged: (bool value) async {
                    setState(() {
                      globalNotificationsActive = value;
                    });
                    if (!value) {
                      await LocalNotifications.cancelAllNotifications();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Toutes les notifications ont été désactivées",
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Notifications activées")),
                      );
                    }
                  },
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final taskProvider = Provider.of<TaskProvider>(
                  context,
                  listen: false,
                );
                final taskEncours = await taskProvider.taskbystatus("En cours");
                if (taskEncours.isNotEmpty) {
                  print(" erreur");
                  LocalNotifications.showPeriodicNotification(
                    title: "Rappel",
                    body: "vous avez ${taskEncours.length} en cours",
                    payload: "En cours",
                  );
                }
              },
              label: Text(
                "Activer Notifications pour les taches en cours",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
