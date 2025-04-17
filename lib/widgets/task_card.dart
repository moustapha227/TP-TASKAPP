import 'package:flutter/material.dart';
import 'package:task/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, size: 20, color: Colors.black54),
                SizedBox(width: 8),
                Text(task.dueDate, style: TextStyle(fontSize: 17)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Priorité : ", style: TextStyle(fontSize: 25)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.priority,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: Colors.black54,
                ),
                SizedBox(width: 8),
                Text("Statut : ", style: TextStyle(fontSize: 20)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
