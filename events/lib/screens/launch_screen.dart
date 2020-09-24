
import 'package:events/screens/event_screen.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/shared/authentication.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    Authentication auth = Authentication();
    auth.getUser().then((user) {
      MaterialPageRoute route;
      if (user != null) {
        route = MaterialPageRoute(builder: (context) => EventScreen(user.uid));
      } else {
        route = MaterialPageRoute(builder: (context) => LoginScreen());
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context, route);
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
