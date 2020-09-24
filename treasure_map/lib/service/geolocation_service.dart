
import 'package:geolocator/geolocator.dart';

class GeolocationService {

  Future<Position> getCurrentLocation() async {
    try {
      bool geolocationAvailable = await isLocationServiceEnabled();
      if (geolocationAvailable) {
        return await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      }
    } catch (err) {
      throw err;
    }
  }

}