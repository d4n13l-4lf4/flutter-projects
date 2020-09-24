
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final Authentication _authentication = Authentication._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  factory Authentication() {
    return _authentication;
  }

  Authentication._internal();

  Future<String> login(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }
}