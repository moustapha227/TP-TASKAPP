import 'package:flutter/material.dart';
import 'package:task/models/database_helper.dart';
import 'package:task/models/task.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/services/local_notifications.dart';
import 'package:task/widgets/my_text_field.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _selectedDate = DateTime.now();
  bool isNotificationEnabled = false;

  TextEditingController id = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController status = TextEditingController();
  Databasehelper databasehelper = Databasehelper();

  List<String> priorityList = ["Faible", "Moyenne", "Élevée"];
  List<String> statusList = ["À faire", "En cours", "Terminée"];
  String selectedPriority = "Moyenne";
  String selectedStatus = "À faire";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Ajouter une tâche",
          strutStyle: StrutStyle(fontSize: 40),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyTextField(
              hint: "Entrez le titre",
              title: 'Titre',
              controller: title,
            ),
            SizedBox(height: 20),
            MyTextField(
              hint: "Entrez la description",
              title: 'Description',
              controller: description,
            ),
            SizedBox(height: 20),
            MyTextField(
              controller: date,
              hint: DateFormat.yMd().format(_selectedDate),
              title: "Date",
              widget: IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SizedBox(height: 20),
            MyTextField(
              hint: selectedPriority,
              title: 'Priorité',
              controller: priority,
              widget: DropdownButton(
                value: selectedPriority,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 28,
                underline: SizedBox(),
                items:
                    priorityList.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    selectedPriority = newvalue!;
                    priority.text = selectedPriority;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            MyTextField(
              hint: selectedStatus,
              title: 'Statut',
              controller: status,
              widget: DropdownButton(
                value: selectedStatus,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 28,
                underline: SizedBox(),
                items:
                    statusList.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    selectedStatus = newvalue!;
                    status.text = selectedStatus;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            SwitchListTile(
              title: Text("Activer les rappels périodiques"),
              value: isNotificationEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationEnabled = value;
                });
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  if (title.text.isNotEmpty &&
                      description.text.isNotEmpty &&
                      date.text.isNotEmpty &&
                      priority.text.isNotEmpty &&
                      status.text.isNotEmpty) {
                    Task newTask = Task(
                      id: id.hashCode,
                      title: title.text,
                      description: description.text,
                      dueDate: date.text,
                      priority: priority.text,
                      status: status.text,
                    );
                    int rep = await databasehelper.insertTask(newTask);
                    if (isNotificationEnabled) {
                      await LocalNotifications.showPeriodicNotification(
                        title: "Rappel : ${newTask.title}",
                        body: newTask.description,
                        payload: "${newTask.id}",
                      );
                    }

                    if (rep > 0) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                        (route) => false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Veuillez remplir tous les champs"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF11538A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Ajouter",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2525),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        date.text = DateFormat.yMd().format(_selectedDate);
      });
    }
  }
}
