
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:treasure_map/models/place.dart';
import 'package:treasure_map/screen/camera_screen.dart';
import 'package:treasure_map/service/place_service.dart';

class PlaceDialog {
  final PlaceService _placeService = GetIt.I<PlaceService>();
  final txtName = TextEditingController();
  final txtLat = TextEditingController();
  final txtLon = TextEditingController();
  final bool isNew;
  final Place place;

  PlaceDialog(this.place, this.isNew);

  Widget buildAlert(BuildContext context) {
    txtName.text = place.name;
    txtLat.text = place.lat.toString();
    txtLon.text  = place.lon.toString();

    return AlertDialog(
      title: Text('Place'),
      content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: txtName,
                decoration: InputDecoration(
                    hintText: 'Name'
                ),
              ),
              TextField(
                controller: txtLat,
                decoration: InputDecoration(
                    hintText: 'Latitude'
                ),
              ),
              TextField(
                  controller: txtLon,
                  decoration: InputDecoration(
                    hintText: 'Longitude',
                  )
              ),
              (place.image != '')
                  ? Container(child: Image.file(File(place.image)))
                  : Container(),
              IconButton(
                icon: Icon(Icons.camera_front),
                onPressed: () {
                  if (isNew) {
                    _placeService.insertPlace(place)
                        .then((data) {
                      place.id = data;
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => CameraScreen(place),
                      );
                      Navigator.push(context, route);
                    });
                  } else {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => CameraScreen(place),
                    );
                    Navigator.push(context, route);
                  }
                },
              ),
              RaisedButton(
                child: Text('OK'),
                onPressed: () {
                  place.name = txtName.text;
                  place.lat = double.tryParse(txtLat.text);
                  place.lon = double.tryParse(txtLon.text);
                  _placeService.insertPlace(place);
                  Navigator.pop(context);
                },
              )
            ],
          )
      ),
    );
  }
}