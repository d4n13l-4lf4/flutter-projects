
import 'package:events/screens/launch_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(child: Center(child: Text('Error: ' + snapshot.error.toString(), textDirection: TextDirection.ltr,)));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Events',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              home: LaunchScreen(),
            );
          }

          return CircularProgressIndicator(
            backgroundColor: Colors.cyan,
            strokeWidth: 20.0,
          );
        }
    );
  }

}
