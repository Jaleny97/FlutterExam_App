import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'exam_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE last_viewed (
            id INTEGER PRIMARY KEY,
            title TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveLastViewedPaper(int id, String title) async {
    final db = await initDb();
    await db.insert('last_viewed', {
      'id': id,
      'title': title,
      'timestamp': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> getLastViewedPaper() async {
    final db = await initDb();
    final result = await db.query(
      'last_viewed',
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }
}
