import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:remote_winery/src/domain/model/wine.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'wines.db');
    return await openDatabase(
      path,
      version: 1, 
      onCreate: _onCreate
  );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wines (
        id INTEGER PRIMARY KEY,
        nameOfProducer TEXT,
        type TEXT,
        yearOfProduction INTEGER,
        region TEXT,
        listOfIngredients TEXT,
        calories INTEGER,
        photoURL TEXT
      )
    ''');
  }

  Future<int> getNextWineID() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.rawQuery('SELECT MAX(id) + 1 as id FROM wines');
    if (maps.first['id'] == null) {
      return 1;
    }
    return maps.first['id'];
  }

  Future<int> insertWine(Wine wine) async {
    var dbClient = await database;
    return await dbClient.insert('wines', wine.toMap());
  }

  Future<Wine> getWine(int id) async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(
      'wines',
      columns: ['id', 'nameOfProducer', 'type', 'yearOfProduction', 'region', 'listOfIngredients', 'calories', 'photoURL'],
      where: 'id = ?',
      whereArgs: [id]
    );
    if (maps.isNotEmpty) {
      return Wine.fromMap(maps.first);
    }
    return Wine.empty();
  }

  Future<List<Wine>> getWines() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(
      'wines',
      columns: ['id', 'nameOfProducer', 'type', 'yearOfProduction', 'region', 'listOfIngredients', 'calories', 'photoURL']
    );
    return maps.map((wine) => Wine.fromMap(wine)).toList();
  }

  Future<int> deleteWine(int id) async {
    var dbClient = await database;
    return await dbClient.delete(
      'wines',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updateWine(Wine wine) async {
    var dbClient = await database;
    return await dbClient.update(
      'wines',
      wine.toMap(),
      where: 'id = ?',
      whereArgs: [wine.id]
    );
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}