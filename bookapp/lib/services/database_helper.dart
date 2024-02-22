import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {


  static Future<sql.Database> db() async {
    try {
      return sql.openDatabase(
        'flutterjunction.db',
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        },
      );
    }catch(e){
      print("An error occurred while opening the database: $e");
      throw Exception("Failed to open the database");
    }
  }

  static Future<void> createTables(sql.Database database) async {
    try {
      await database.execute("""CREATE TABLE book(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        author TEXT,
        comments TEXT,
        status INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    }catch(e){
      print("An error occurred while creating tables: $e");
    }
  }

  // Create new item
  static Future<int> createItem(String? title, String? author, String? comments, int? status) async {
    try {
      final db = await DatabaseHelper.db();
      final data = {
        'title': title,
        'author': author,
        'comments': comments,
        'status': status
      };
      final id = await db.insert('book', data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    } catch(e){
      print("An error occurred while creating a new item: $e");
      throw Exception("Failed to create a new item");
    }

    // When a UNIQUE constraint violation occurs,
    // the pre-existing rows that are causing the constraint violation
    // are removed prior to inserting or updating the current row.
    // Thus the insert or update always occurs.
  }


  //Get items based on book status
  static Future<List<Map<String, dynamic>>> getItems(int status) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('book', where: "status = ?",
          whereArgs: [status],
          orderBy: "createdAt DESC");
    } catch(e) {
      print("An error occurred while fetching items: $e");
      throw Exception("Failed to fetch items");
    }
  }

  // Get a single item by id
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    try {
      final db = await DatabaseHelper.db();
      return db.query('book', where: "id = ?", whereArgs: [id], limit: 1);
    } catch (e) {
      print("An error occurred while fetching an item: $e");
      throw Exception("Failed to fetch an item");
    }
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String author, String comments, int? status) async {
    try {
      final db = await DatabaseHelper.db();

      final data = {
        'title': title,
        'author': author,
        'comments': comments,
        'status': status,
        'createdAt': DateTime.now().toString()
      };

      final result =
      await db.update('book', data, where: "id = ?", whereArgs: [id]);
      return result;
    }catch(e){
      print("An error occurred while updating an item: $e");
      throw Exception("Failed to update an item");
    }
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("book", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print("An error occurred while deleting an item: $e");
      throw Exception("Failed to delete an item");
    }
  }

  //Get quantity of read books
  static Future<int> countBooksByStatus(int status) async {
    try {
      final db = await DatabaseHelper.db();
      final result = await db.rawQuery(
          'SELECT COUNT(*) FROM book WHERE status = ?', [status]);

      if (result.isNotEmpty) {
        return sql.Sqflite.firstIntValue(result)!;
      }
      return 0;
    }catch(e){
      print("An error occurred while fetching a number of items: $e");
      throw Exception("Failed to fetch a number of items");
    }
  }


}

