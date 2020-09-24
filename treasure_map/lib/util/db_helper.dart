
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {

  final int version = 1;
  Database db;

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
          join(await getDatabasesPath(), 'mapp.db'),
          onCreate: (database, version) {
            database.execute('CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, lon DOUBLE, image TEXT)');
          },
          version: version,
      );
    }
    return db;
  }


  Future insertMockData() async {
    await openDb();
    await db.execute("INSERT INTO places VALUES (1, 'Beautiful park', 41.9294115, 12.5380785, '')");
    await db.execute("INSERT INTO places VALUES (2, 'Best pizza in the world', 41.9294115, 12.5268947, '')");
    await db.execute("INSERT INTO places VALUES (3, 'The best ice cream on earth', 41.9349061, 12.5339831, '')");
    List places = await db.rawQuery('SELECT * FROM places');
    print(places[0].toString());
  }
}