
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_map/locator/locator.dart';
import 'package:treasure_map/models/place.dart';
import 'package:treasure_map/screen/manage_places.dart';
import 'package:treasure_map/service/geolocation_service.dart';
import 'package:treasure_map/service/place_service.dart';
import 'package:treasure_map/ui/place_dialog.dart';
import 'package:treasure_map/util/db_helper.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treasure Map',
      home: MainMap(),
    );
  }
}


class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final GeolocationService _geolocationService = GetIt.I<GeolocationService>();
  final PlaceService _placeService = GetIt.I<PlaceService>();
  GoogleMapController mapController;
  List<Marker> markers = [];

  final CameraPosition position = CameraPosition(
    target: LatLng(-0.2103968, -78.4910514),
    zoom: 12,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    _getCurrentLocation().then((pos) {
      addMarker(pos, 'currpos', 'You are here');
    }).catchError((err) => print(err.toString()));
    //_dbHelper.insertMockData();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The Treasure Map'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(builder: (context) => ManagePlaces());
                  Navigator.push(context, route);
                }
            )
          ],
        ),
        body: Container(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: position,
              markers: Set<Marker>.of(markers),
            )
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location),
          onPressed: () {
            int here = markers.indexWhere((p) => p.markerId == MarkerId('currpos'));
            Place place;
            if (here == -1) {
              place = Place(0, '', 0, 0, '');
            } else {
              LatLng pos = markers[here].position;
              place = Place(0, '', pos.latitude, pos.longitude, '');
            }
            PlaceDialog dialog = PlaceDialog(place, true);
            showDialog(
              context: context,
              builder: (context) => dialog.buildAlert(context),
            );
          },
        )
    );
  }

  Future _getCurrentLocation() async {
    try {
      Position _position = Position(latitude: this.position.target.latitude, longitude: this.position.target.longitude);
      _position = await this._geolocationService.getCurrentLocation();
      return _position;
    } catch (err) {
      print(err);
    }
  }

  Future _getData() async {
    List<Place> _places = await _placeService.getPlaces();
    _places.forEach((pos) {
      addMarker(Position(latitude: pos.lat, longitude: pos.lon), pos.id.toString(), pos.name);
    });

    setState(() {
      markers = markers;
    });
  }

  void addMarker(Position pos, String markerId, String markerTitle) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(
          title: markerTitle),
      icon: (markerId == 'currpos')
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    markers.add(marker);
    setState(() {
      markers = markers;
    });
  }
}
