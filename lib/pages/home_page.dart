import 'package:flutter/material.dart';
import 'package:task/models/database_helper.dart';
import 'package:task/pages/show_task.dart';
import 'package:task/widgets/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Databasehelper databasehelper = Databasehelper();

  Future<List<Map<String, dynamic>>> getAllTask() async {
    List<Map<String, dynamic>> task = List<Map<String, dynamic>>.from(
      await databasehelper.getTask("SELECT * FROM 'task'"),
    );
    return task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addTask");
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      appBar: AppBar(elevation: 0),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20),
            child: Text(
              "MyTASK",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getAllTask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Aucune tâche trouvée"));
                } else {
                  List<Map<String, dynamic>> listTask = snapshot.data!;
                  return ListView.builder(
                    itemCount: listTask.length,
                    itemBuilder: (context, index) {
                      final task = listTask[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            "${task['title']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          subtitle: Text(
                            "Description : ${task['description']}",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowTask(task: task),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ShowTask(task: task),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
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
                                                int rep = await databasehelper
                                                    .deleteTask(
                                                      "DELETE FROM 'task' WHERE id=${task['id']}",
                                                    );

                                                if (rep > 0) {
                                                  Navigator.of(context).pop();
                                                  setState(() {});
                                                }
                                              },
                                              child: Text(
                                                "Oui",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
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
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
