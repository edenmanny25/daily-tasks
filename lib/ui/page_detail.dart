import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final FirebaseUser usernow;
  const DetailPage({Key key, this.usernow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('data');
  }
}
