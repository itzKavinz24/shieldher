import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('shieldher.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath =
        await getDatabasesPath();

    final path =
        join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uid TEXT,
      name TEXT,
      phone TEXT,
      relationship TEXT
    )
    ''');

    await db.execute('''
      CREATE TABLE devices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deviceName TEXT,
        bleAddress TEXT,
        deviceType TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE alerts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        riskLevel TEXT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE police_stations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        latitude REAL,
        longitude REAL,
        district TEXT
      )
    ''');
  }
  



  Future close() async {
    final db = await instance.database;
    db.close();
  }
}