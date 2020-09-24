
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:treasure_map/models/place.dart';
import 'package:treasure_map/service/place_service.dart';
import 'package:treasure_map/ui/place_dialog.dart';

class ManagePlaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Places'),),
      body: PlacesList(),
    );
  }
}

class PlacesList extends StatefulWidget {
  @override
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  final PlaceService _placeService = GetIt.I<PlaceService>();
  List<Place> places = [];

  @override
  void initState() {
    _getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.places.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(places[index].id.toString()),
          onDismissed: (direction) {
            String placeName = places[index].name;
            this._placeService.deletePlace(places[index]);
            setState(() {
              this.places.removeAt(index);
            });
            Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("$placeName deleted")));
          },
          child: ListTile(
              title: Text(this.places[index].name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  PlaceDialog dialog = PlaceDialog(places[index], false);
                  showDialog(
                    context: context,
                    builder: (context) => dialog.buildAlert(context),
                  );
                },
              )
          ),
        );
      },
    );
  }

  Future _getPlaces() async {
    try {
      var places = await this._placeService.getPlaces();
      setState(() {
        this.places = places;
      });
    } catch(err) {
      print(err);
    }
  }
}

