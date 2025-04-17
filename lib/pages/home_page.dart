import 'package:flutter/material.dart';
import 'package:task/models/database_helper.dart';
import 'package:task/models/task.dart';
import 'package:task/pages/show_task.dart';
import 'package:task/widgets/drawer.dart';
import 'package:task/widgets/task_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Databasehelper databasehelper = Databasehelper();
  late Future<List<Task>?> _taskFuture;

  @override
  void initState() {
    super.initState();
    _taskFuture = databasehelper.getAllTask();
  }

  void _refreshTaskList() {
    setState(() {
      _taskFuture = databasehelper.getAllTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed("addTask");
          if (result == true) _refreshTaskList();
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      appBar: AppBar(
        titleSpacing: 20,
        backgroundColor: Colors.blue,
        title: Text(
          "Mes Tâches",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            // color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: BorderSide.strokeAlignCenter),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Expanded(
                child: FutureBuilder<List<Task>?>(
                  future: _taskFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Erreur: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("Aucune tâche trouvée"));
                    } else {
                      List<Task> listTask = snapshot.data!;
                      return ListView.builder(
                        itemCount: listTask.length,
                        itemBuilder: (context, index) {
                          final task = listTask[index];
                          return TaskCard(
                            task: task,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowTask(task: task),
                                ),
                              );
                              if (result == true) _refreshTaskList();
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getListTaskEncours() {}
}
