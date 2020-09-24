import 'package:events/models/event_detail.dart';
import 'package:events/models/favourite.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/service/event_details_service.dart';
import 'package:events/service/favourite_service.dart';
import 'package:events/shared/authentication.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  final String uid;

  EventScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    final Authentication auth = Authentication();

    return Scaffold(
      appBar: AppBar(
          title: Text('Event'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                auth.signOut().then((result) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                });
              },
            ),
          ]
      ),
      body: EventList(uid),
    );
  }
}

class EventList extends StatefulWidget {
  final String uid;

  EventList(this.uid);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final EventDetailsService _eventDetailsService = EventDetailsService();
  final FavouriteService _favouriteService = FavouriteService();

  List<EventDetail> details = [];
  List<Favourite> favourites = [];

  @override
  void initState() {
    if (mounted) {
      getEventDetails();
    }
    _favouriteService.getUserFavourites(widget.uid).then((data) {
      setState(() {
        favourites = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (details != null) ? details.length : 0,
      itemBuilder: (context, position) {
        Color starColor = (isUserFavourite(details[position].id) ? Colors.amber : Colors.grey);

        String subtitle = "Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}";
        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(subtitle),
          trailing: IconButton(
            icon: Icon(Icons.star, color: starColor),
            onPressed: () {
              toggleFavourite(details[position]);
            },
          ),
        );
      },
    );
  }

  void getEventDetails() async {
    try {
      var details = await _eventDetailsService.getDetailsList();
      setState(() {
        this.details = details;
      });
    } catch (err) {
      print(err);
    }
  }

  void toggleFavourite(EventDetail ed) async {
    if (isUserFavourite(ed.id)) {
      Favourite favourite = favourites.firstWhere((Favourite f) => (f.eventId == ed.id));
      String favId = favourite.id;
      await _favouriteService.deleteFavourite(favId);
    } else {
      print(ed.id);
      await  _favouriteService.addFavourite(ed, widget.uid);
    }
    List<Favourite> updatedFavourites = await _favouriteService.getUserFavourites(widget.uid);
    setState(() {
      favourites = updatedFavourites;
    });
  }

  bool isUserFavourite(String eventId) {
    Favourite favourite = favourites.firstWhere((Favourite favourite) => (favourite.eventId == eventId), orElse: () => null);
    if (favourite == null) {
      return false;
    } else {
      return true;
    }
  }
}
