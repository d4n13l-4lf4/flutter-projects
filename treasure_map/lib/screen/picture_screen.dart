
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:treasure_map/main.dart';
import 'package:treasure_map/models/place.dart';
import 'package:treasure_map/service/place_service.dart';

class PictureScreen extends StatelessWidget {
  final PlaceService _placeService = PlaceService();
  final String imagePath;
  final Place place;

  PictureScreen(this.imagePath, this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save picture'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              place.image = imagePath;
              this._placeService.insertPlace(place);
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => MainMap()
              );
              Navigator.push(context, route);
            },
          )
        ],
      ),
      body: Container(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
