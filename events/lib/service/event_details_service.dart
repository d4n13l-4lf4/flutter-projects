

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/event_detail.dart';

class EventDetailsService {
  static final EventDetailsService _singleton = EventDetailsService._internal();
  CollectionReference eventCollectionRef = FirebaseFirestore.instance.collection("event_details");

  factory EventDetailsService() {
    return _singleton;
  }

  EventDetailsService._internal();

  Future<List<EventDetail>> getDetailsList() async {
    try {
      QuerySnapshot eventsSnapshot = await this
          .eventCollectionRef
          .get();
      return eventsSnapshot.docs.map((d) {
        return EventDetail.fromMap(d);
    }).toList();
    } catch (err) {
      throw err;
    }
  }
}