import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String name;
  String email;
  String imageUrl;
  FirebaseUser currentUser;
  Stream<FirebaseUser> user;
  Stream<Map<String, dynamic>> profile;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser authResult =
        await _auth.signInWithCredential(credential);
    currentUser = authResult;
    name = authResult.displayName;
    email = authResult.email;
    imageUrl = authResult.photoUrl;
    updateUserData(currentUser, "");
    return 'signInWithGoogle succeeded: $authResult';
  }

  void updateUserData(FirebaseUser user, String username) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.providerId,
      'Name': user.displayName,
      'userName': username,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  signOut() {
    _auth.signOut();
  }

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }
}

final AuthService authService = AuthService();
