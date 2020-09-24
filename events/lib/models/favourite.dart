
import 'package:cloud_firestore/cloud_firestore.dart';

class Favourite {
  String id;
  String _eventId;
  String _userId;

  Favourite(this.id, this._eventId, this._userId);

  String get eventId => _eventId;
  String get userId => _userId;

  Favourite.map(DocumentSnapshot document) {
    var data = document.data();
    this.id = document.id;
    this._eventId = data['eventId'];
    this._userId = data['userId'];
  }

  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }
}