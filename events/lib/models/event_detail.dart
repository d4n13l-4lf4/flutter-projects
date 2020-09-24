
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetail {
  String id;
  String _description;
  String _date;
  String _startTime;
  String _endTime;
  String _speaker;
  String _isFavorite;

  EventDetail(this.id, this._description, this._date, this._startTime, this._endTime, this._speaker, this._isFavorite);

  EventDetail.fromMap(DocumentSnapshot document) {
    var eventData = document.data();
    print('Event data: ' + eventData.toString());
    this.id = document.id;
    this._description = eventData['description'];
    this._date = eventData['date'];
    this._startTime = eventData['start_time'];
    this._endTime = eventData['end_time'];
    this._speaker = eventData['speaker'];
    this._isFavorite = eventData['is_favourite'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = _description;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['speaker'] = _speaker;
    return map;
  }

  String get description => _description;
  String get date => _date;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get speaker => _speaker;
  String get isFavourite => _isFavorite;

}