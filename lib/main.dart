import 'package:flutter/material.dart';
import 'package:taskist/home.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:taskist/domain/db.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
            stream: FirebaseAuth.instance.authStateChanges()),
        ChangeNotifierProvider(builder: (_) => DataProvider()),
        ChangeNotifierProvider<Indexc>(builder: (__) => Indexc()),
      ],
      child: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("LandingPage");
    var user = Provider.of<User>(context);
    bool loggedIn = user != null;

    if (loggedIn) {
      return HomePage();
    } else if (!loggedIn) {
      return LoginPage();
    } else {
      return CircularProgressIndicator();
    }
  }
}
