import 'package:flutter/material.dart';
import 'package:task/models/task.dart';
import 'database_helper.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Databasehelper databasehelper = Databasehelper();

  Future<void> updateTaskStatus(int id, String newStatus) async {
    await databasehelper.updateTaskStatus(id, newStatus);
    notifyListeners();
  }

  Future<List<Task>> taskbystatus(String status) async {
    return await databasehelper.getTaskbystatus(status);
  }

  Future<void> inserTask(Task task) async {
    await databasehelper.insertTask(task);
    notifyListeners();
  }

  Future<void> updatetTask(Task task) async {
    await databasehelper.updatetTask(task);
    notifyListeners();
  }
}
