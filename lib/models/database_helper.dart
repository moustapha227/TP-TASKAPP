import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task/models/task.dart';

class Databasehelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialisation();
      return _db;
    } else {
      return _db;
    }
  }

  initialisation() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "taskdb");

    Database mydb = await openDatabase(path, onCreate: _createDB, version: 1);
    return mydb;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE task (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      dueDate TEXT,
      priority TEXT,
      status TEXT
    )
  ''');
  }

  Future<int> insertTask(Task task) async {
    Database? mydb = await db;
    int rep = await mydb!.insert(
      "Task",
      task.tojson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return rep;
  }

  Future<List<Task>?> getAllTask() async {
    Database? mydb = await db;
    final List<Map<String, dynamic>> maps = await mydb!.query("Task");

    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => Task.fromJson(maps[index]));
  }

  Future<List<Task>> getTaskbystatus(String status) async {
    Database? mydb = await db;

    final List<Map<String, dynamic>> maps = await mydb!.query(
      'task',
      where: 'status = ?',
      whereArgs: [status],
    );
    if (maps.isNotEmpty) {}
    return List.generate(maps.length, (index) => Task.fromJson(maps[index]));
  }

  Future<int> updatetTask(Task task) async {
    Database? mydb = await db;
    int rep = await mydb!.update(
      "Task",
      task.tojson(),
      where: 'id = ?',
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return rep;
  }

  Future<int> deleteTask(Task task) async {
    Database? mydb = await db;
    int rep = await mydb!.delete("Task", where: 'id = ?', whereArgs: [task.id]);
    return rep;
  }

  Future<int> updateTaskStatus(int id, String newStatus) async {
    Database? mydb = await db;
    return await mydb!.update(
      'task',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
