import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task/models/database_helper.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/widgets/my_text_field.dart';
import 'package:task/models/task.dart';

class UpdateTask extends StatefulWidget {
  final Task task;
  final id;
  final title;
  final description;
  final dueDate;
  final priority;
  final status;
  const UpdateTask({
    super.key,
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.priority,
    this.status,
    required this.task,
  });

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController status = TextEditingController();

  Databasehelper databasehelper = Databasehelper();

  DateTime _selectedDate = DateTime.now();

  List<String> priorityList = ["Faible", "Moyenne", "Elevee"];
  List<String> statusList = ["A faire", "En cours", "Terminée"];

  String selectedPriority = "Moyenne";
  String selectedStatus = "A faire";

  @override
  void initState() {
    title.text = widget.title;
    description.text = widget.description;
    date.text = widget.dueDate;
    priority.text = widget.priority;
    status.text = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Modifier une tâche",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          strutStyle: StrutStyle(fontSize: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 0),
            MyTextField(
              hint: "Enter your title",
              title: 'Title',
              controller: title,
            ),
            SizedBox(height: 10),
            MyTextField(
              hint: "Enter description",
              title: 'Description',
              controller: description,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: date,
              hint: DateFormat.yMd().format(_selectedDate),
              title: "Date",
              widget: IconButton(
                onPressed: () {
                  getDateFromUser(context);
                },
                icon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            SizedBox(height: 10),
            MyTextField(
              hint: selectedPriority,
              title: 'Priority',
              controller: priority,
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                style: TextStyle(color: Colors.white),
                underline: Container(height: 0),
                items:
                    priorityList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    selectedPriority = newvalue!;
                    priority.text = selectedPriority;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            MyTextField(
              hint: selectedStatus,
              title: 'Status',
              controller: status,
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                style: TextStyle(color: Colors.white),
                underline: Container(height: 0),
                items:
                    statusList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newvalue) {
                  setState(() {
                    selectedStatus = newvalue!;
                    status.text = selectedStatus;
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 17, 83, 138),
                //color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: MaterialButton(
                onPressed: () async {
                  // Création d’un objet Task à partir des valeurs saisies
                  Task updatedTask = Task(
                    id: widget.id,
                    title: title.text,
                    description: description.text,
                    dueDate: date.text,
                    priority: priority.text,
                    status: status.text,
                  );

                  // Appel de la méthode update
                  int rep = await databasehelper.updatetTask(updatedTask);

                  // Navigation si tout est ok
                  if (rep > 0) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  "Modifier",
                  style: TextStyle(
                    color: Colors.white,
                    //color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDateFromUser(BuildContext context) async {
    DateTime? _pikerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2525),
    );
    if (_pikerDate != null) {
      setState(() {
        _selectedDate = _pikerDate;
        date.text = DateFormat.yMd().format(_selectedDate);
      });
    } else {}
  }
}
