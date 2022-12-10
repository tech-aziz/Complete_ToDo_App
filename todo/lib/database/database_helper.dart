import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/model/todo_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database?> get db async {
    // If database exists, return database
    if (_database != null) {
      return _database;
    }

    // If database don't exists, create one
    _database = await initialDatabase();
    return _database;
  }

  // Create the database and the Todo table
  initialDatabase() async {
    Directory DpPath = await getApplicationDocumentsDirectory();
    String path = join(DpPath.path, 'Todos.db');
    openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    db.execute('''
        CREATE TABLE Todos(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          dateTime TEXT
        )
        ''');
  }

  // Insert Todo on database
  Future addToDoMethod(ToModel toModel) async {
    Database? database = await db;
    return await database!.insert("Todos", toModel.toJson());
  }

  // get Todo from database
  Future<List<ToModel>?> getToDoModel() async {
    Database? database = await db;
    var data = await database!.query("Todos", orderBy: "id");

    List<ToModel> toDoModels =
        data.map((toDoModel) => ToModel().toJson()).cast<ToModel>().toList();
    return toDoModels;
  }


  
}
