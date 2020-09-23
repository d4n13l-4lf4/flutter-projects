import 'package:path/path.dart';
import 'package:shopping_list/models/list_item.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  final int version = 1;
  Database db;

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
          database.execute('CREATE TABLE IF NOT EXISTS lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
          database.execute('CREATE TABLE IF NOT EXISTS items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
        },
        version: version,
      );
    }
    return db;
  }

  Future testDb() async {
    db = await openDb();
    await db.execute("INSERT INTO lists VALUES (0, 'Fruit', 2)");
    await db.execute("INSERT INTO items VALUES (0, 0, 'Apples', '2 Kg', 'Better if they are green')");
    List lists = await db.rawQuery("SELECT * FROM lists");
    List items = await db.rawQuery('SELECT * FROM items');
    print(lists[0].toString());
    print(items[0].toString());
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await this.db.insert(
      'lists',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> updateItem(ListItem item) async {
    int id = await db.update('items', item.toMap());
    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db.query('lists');
    return List.generate(maps.length, (i) => ShoppingList(
      maps[i]['id'],
      maps[i]['name'],
      maps[i]['priority'],
    ));
  }

  Future<List<ListItem>> getItems(int listId) async {
    final List<Map<String, dynamic>> maps = await db.query('items', where: 'idList = ?', whereArgs: [listId]);
    return List.generate(maps.length, (index) => ListItem(
        maps[index]['id'],
        maps[index]['idList'],
        maps[index]['name'],
        maps[index]['note'],
        maps[index]['quantity']
    ));
  }

  Future<int> deleteList(ShoppingList list) async {
    int result;
    await db.transaction((Transaction txn) async {
      result = await txn.delete("items", where: "idList = ?", whereArgs: [list.id]);
      result = await txn.delete("lists", where: "id = ?", whereArgs: [list.id]);
    });
    return result;
  }

  Future<int> deleteListItem(int id) async {
    return await db.delete('items', where: "id = ?", whereArgs: [id]);
  }
}