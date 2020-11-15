import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../domain/db.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String name;
  String email;
  String imageUrl;
  User currentUser;
  Stream<User> user;
  Stream<Map<String, dynamic>> profile;

  Future<String> signInWithGoogle() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('counter', "counter");

    final db = DBService();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    currentUser = authResult.user;
    bool isnew = authResult.additionalUserInfo.isNewUser;

    name = currentUser.displayName;
    email = currentUser.email;
    imageUrl = currentUser.photoURL;

    var list = {"name": "My Tasks", "completed": 0};

    print("is the user new " + isnew.toString());

    if (isnew) {
      print(isnew);
      print("is the user new " + isnew.toString());

      db.addList(user: currentUser, data: list);
    }

    updateUserData(currentUser, "");

    return 'signInWithGoogle succeeded: $authResult';
  }

  void updateUserData(User user, String username) async {
    DocumentReference ref = _db.collection('users').doc(user.uid);

    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoURL,
      'displayName': user.email,
      'Name': user.displayName,
      'userName': username,
      'lastSeen': DateTime.now()
    }, SetOptions(merge: true));
  }

  signOut() {
    _auth.signOut();
  }
}

final AuthService authService = AuthService();
