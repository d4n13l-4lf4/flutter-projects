import 'package:get_it/get_it.dart';
import 'package:treasure_map/models/place.dart';
import 'package:treasure_map/service/geolocation_service.dart';
import 'package:treasure_map/service/place_service.dart';
import 'package:treasure_map/util/db_helper.dart';

void setupLocator() {
  GetIt.I.registerSingleton<GeolocationService>(GeolocationService());
  GetIt.I.registerSingleton<DbHelper>(DbHelper());
  GetIt.I.registerSingleton<PlaceService>(PlaceService());
}