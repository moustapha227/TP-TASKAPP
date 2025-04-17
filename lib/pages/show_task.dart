import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/models/database_helper.dart';
import 'package:task/models/task.dart';
import 'package:task/models/task_provider.dart';
import 'package:task/pages/update_task.dart';
import 'package:task/services/local_notifications.dart';

class ShowTask extends StatefulWidget {
  final Task task;
  const ShowTask({super.key, required this.task});

  @override
  State<ShowTask> createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  bool notificationActive = false;
  @override
  Widget build(BuildContext context) {
    Databasehelper databasehelper = Databasehelper();
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Details d'une tâche",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          strutStyle: StrutStyle(fontSize: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Titre : ${widget.task.title}",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Description : ${widget.task.description}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                "Date d'échéance : ${widget.task.dueDate}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                "Priorité : ${widget.task.priority}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                "Statut : ${widget.task.status}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      taskProvider.updateTaskStatus(widget.task.id, "En cours");
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      "Marquer comme En cours",
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      taskProvider.updateTaskStatus(widget.task.id, "Terminée");
                      LocalNotifications.showSimpleNotification(
                        title: "Félicitations !",
                        body:
                            'Vous avez terminé la tâche : "${widget.task.title}"',
                        payload: "task_done",
                      );
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      "Marquer comme terminée",
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => UpdateTask(
                                  task: widget.task,
                                  id: widget.task.id,
                                  title: widget.task.title,
                                  description: widget.task.description,
                                  dueDate: widget.task.dueDate,
                                  priority: widget.task.priority,
                                  status: widget.task.status,
                                ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, size: 40),
                    ),

                    SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  "Voulez-vous supprimer cette tâche ?",
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      int rep = await databasehelper.deleteTask(
                                        widget.task,
                                      );
                                      if (rep > 0) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text(
                                      "Oui",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.inversePrimary,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Annuler",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.inversePrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: Icon(Icons.delete, size: 40),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: Text("Recevoir un rappel périodique"),
                value: notificationActive,
                onChanged: (bool value) async {
                  setState(() {
                    notificationActive = value;
                  });

                  if (value) {
                    await LocalNotifications.showPeriodicNotification(
                      title: "Rappel : ${widget.task.title}",
                      body: "N'oubliez pas votre tâche.",
                      payload: "${widget.task.id}",
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Notifications activées pour cette tâche",
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
