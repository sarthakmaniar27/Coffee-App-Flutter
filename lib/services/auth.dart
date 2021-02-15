import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import '../../../../../FlutterSDK/flutter/bin/cache/pkg/sky_engine/lib/async/async.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //getting FirebaseAuth instance
  //We can access all the methods and properties of this FirebaseAuth class using _auth object

  //create user object based on FireBaseUser
  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFireBaseUser(user));
        .map(_userFromFireBaseUser); //shortcut for above
  } //every time someone authenticates, we get back a FirebaseUser inside the stream and we're mapping it to a normal user based on our User class

  //So basically here we're are setting up a stream so that everytime a user signs in or signs out, we're going to get some kind of response down the stream telling us at this is the user signed in or signed out. And then we're just mapping that user to our User object
  // sign in anonomously
  Future signInAon() async {
    try {
      AuthResult result = await _auth
          .signInAnonymously(); //This method allows us to sign in anonmously and it will return AuthResult type
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document for the user with uid
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'new crew member', 100);
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
