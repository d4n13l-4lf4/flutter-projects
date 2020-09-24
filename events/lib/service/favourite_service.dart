
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/event_detail.dart';
import 'package:events/models/favourite.dart';

class FavouriteService {

  final CollectionReference favouriteCollection = FirebaseFirestore.instance.collection("favourites");

  Future addFavourite(EventDetail eventDetail, String uid) async {
    try {
      Favourite fav = Favourite(null, eventDetail.id, uid);
      DocumentReference result = await favouriteCollection.add(fav.toMap());
      print(result);
      return result;
    } catch (err) {
      throw err;
    }
  }

  Future deleteFavourite(String favId) async {
    try {
      return await favouriteCollection.doc(favId).delete();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Favourite>> getUserFavourites(String uid) async {
    List<Favourite> favs;
    QuerySnapshot docs = await favouriteCollection.where('userId', isEqualTo: uid).get();
    if (docs != null) {
      favs = docs.docs.map((data) => Favourite.map(data)).toList();
    }
    return favs;
  }
}