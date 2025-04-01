import 'package:flutter/material.dart';
import 'package:task/models/database_helper.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/widgets/my_text_field.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _selectedDate = DateTime.now();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController status = TextEditingController();
  Databasehelper databasehelper = Databasehelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 0),
            Text(
              "Add New Task",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
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
              hint: "Priority",
              title: 'Priority',
              controller: priority,
            ),
            SizedBox(height: 10),
            MyTextField(
              hint: "Status",
              title: 'Status',
              controller: description,
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
                  int rep = await databasehelper.insertTask(
                    "INSERT INTO 'task' (title, description, dueDate, priority, status) VALUES ('${title.text}','${description.text}','${date.text}','${priority.text}','${status.text}')",
                  );
                  if (rep > 0) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  "Ajouter",
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
