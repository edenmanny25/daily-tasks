import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskist/model/element.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestPage extends StatelessWidget {
  final FirebaseUser user;
  const TestPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('dd');
  }
}
