import 'package:flutter/material.dart';

class ShowTask extends StatelessWidget {
  final Map<String, dynamic> task;
  const ShowTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails de la tâche")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Titre : ${task['title']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Description : ${task['description']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Date d'échéance : ${task['dueDate']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Priorité : ${task['priority']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text("Statut : ${task['status']}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
