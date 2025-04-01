import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<int> insertTask(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawInsert(sql);
    return rep;
  }

  Future<List<Map>> getTask(String sql) async {
    Database? mydb = await db;
    List<Map> rep = await mydb!.rawQuery(sql);
    return rep;
  }

  Future<int> updatetTask(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawUpdate(sql);
    return rep;
  }

  Future<int> deleteTask(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawDelete(sql);
    return rep;
  }
}
