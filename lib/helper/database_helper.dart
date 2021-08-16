import 'package:restaurant_app/models/restaurant_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static String _tableName = "favorite_restaurant";

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(join(path, 'database_restaurant.db'),
        onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY, name TEXT, description TEXT, pictureId TEXT, city TEXT, rating REAL
      )''',
      );
    }, version: 1);
    return db;
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    final Database db = await database;
    await db.insert(_tableName, restaurant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("INSERT SUCCESS");
  }

  Future<List<Restaurant>> showFavorite() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(_tableName);
    return List.generate(
        data.length,
        (index) => Restaurant(
              id: data.elementAt(index)["id"],
              city: data.elementAt(index)["city"],
              name: data.elementAt(index)["name"],
              description: data.elementAt(index)["description"],
              pictureId: data.elementAt(index)["pictureId"],
              rating: data.elementAt(index)["rating"],
            ));
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
