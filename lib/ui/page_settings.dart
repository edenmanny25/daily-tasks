import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:taskist/domain/auth.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  sharePage() async {
    Share.share(" address for appp or what eves");
  }

  rateApp() async {
    LaunchReview.launch(
        androidAppId: "com.bernard.barmeet", iOSAppId: "154833664");
  }

  _launchURL() async {
    const url = 'https://twitter.com/ismannyb';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('SettingsPage 😆😍🤑😋😀');

    return Scaffold(
      body: ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.cogs,
                        color: Colors.grey,
                      ),
                      title: Text("Version"),
                      trailing: Text("1.0.0"),
                    ),
                    ListTile(
                      onTap: _launchURL,
                      leading: Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.blue,
                      ),
                      title: Text("Twitter"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: rateApp,
                      leading: Icon(
                        FontAwesomeIcons.star,
                        color: Colors.blue,
                      ),
                      title: Text("Rate Taskist"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: sharePage,
                      leading: Icon(
                        FontAwesomeIcons.shareAlt,
                        color: Colors.blue,
                      ),
                      title: Text("Share Taskist"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: () => authService.signOut(),
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.blue,
                      ),
                      title: Text("signoutt"),
                      trailing: Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
