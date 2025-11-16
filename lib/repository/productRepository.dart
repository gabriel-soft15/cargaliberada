import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cargaliberada/models/productModel.dart';
import 'package:cargaliberada/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  final _col = FirebaseFirestore.instance.collection('products');

  Future<Database?> get _db async {
    if (kIsWeb) return null;
    return DatabaseHelper.instance.database;
  }

  // Firestore
  Future<void> upsertFirestore(ProductModel p) async {
    await _col.doc(p.firestoreId).set(p.toFirestore(), SetOptions(merge: true));
  }

  Future<List<ProductModel>> getAllFirestore() async {
    final snap = await _col.orderBy('updatedAt', descending: true).get();
    return snap.docs
        .map((d) => ProductModel.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<void> deleteFromFirestore(String id) async {
    await _col.doc(id).delete();
  }

  // Local (SQLite)
  Future<int> insertLocal(ProductModel p) async {
    final db = await _db;
    if (db == null) return 0;
    return await db.insert('products', p.toMap());
  }

  Future<List<ProductModel>> getAllLocal() async {
    final db = await _db;
    if (db == null) return [];
    final res = await db.query('products');
    return res.map((m) => ProductModel.fromMap(m)).toList();
  }

  Future<int> updateLocal(ProductModel p) async {
    final db = await _db;
    if (db == null || p.id == null) return 0;
    return await db.update(
      'products',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<int> deleteLocal(int id) async {
    final db = await _db;
    if (db == null) return 0;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
