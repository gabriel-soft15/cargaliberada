import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cargaliberada/models/productModel.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("SQLite não é suportado no Web");
    }
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'carga_liberada.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firebaseUid TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        avatarUrl TEXT,
        isGoogleUser INTEGER DEFAULT 0,
        role TEXT NOT NULL DEFAULT 'student',
        classId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firestoreId TEXT NOT NULL,
        nome TEXT NOT NULL,
        descricao TEXT,
        peso REAL NOT NULL,
        valorNfe REAL NOT NULL,
        remetenteCnpj TEXT NOT NULL,
        cidadeDestino TEXT NOT NULL
      )
    ''');
  }

  Future<int> createProduct(ProductModel product) async {
    final db = await database;
    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return maps.map((m) => ProductModel.fromMap(m)).toList();
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
