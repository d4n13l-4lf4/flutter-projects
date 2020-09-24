
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treasure_map/models/place.dart';
import 'package:treasure_map/util/db_helper.dart';

class PlaceService {
  final DbHelper _dbHelper = GetIt.I<DbHelper>();

  Future<List<Place>> getPlaces() async {
    final db = await _dbHelper.openDb();
    final List<Map<String, dynamic>> maps = await db.query('places');
    return List.generate(maps.length, (index) => Place(
      maps[index]['id'],
      maps[index]['name'],
      maps[index]['lat'],
      maps[index]['lon'],
      maps[index]['image'],
    ));
  }

  Future<int> insertPlace(Place place) async {
    final db = await this._dbHelper.openDb();
    int id = await db.insert('places', place.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> deletePlace(Place place) async {
    final db = await this._dbHelper.openDb();
    int result = await db.delete('places', where: "id = ?", whereArgs: [place.id]);
    return result;
  }

}