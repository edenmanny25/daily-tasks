import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskist/ui/page_done.dart';
import 'package:taskist/ui/page_settings.dart';
import 'package:taskist/ui/page_task.dart';
import 'package:taskist/ui/testpage.dart';
import 'package:taskist/model/db.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final addTodoKey = UniqueKey();

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final db = DBService();

  final List<Widget> _children = [
    DonePage(),
    TaskPage(),
    SettingsPage(),
    TestPage()
  ];

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    DataProvider _data = Provider.of<DataProvider>(context);
    final newTodoController = TextEditingController();

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => onTabTapped(1),
            ),
            Builder(
                builder: (context) => IconButton(
                      icon: Icon(Icons.title),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            /// fix is routing page not im modoal
                            return DonePage();
                          },
                        );
                      },
                    )),
            FloatingActionButton(onPressed: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      key: addTodoKey,
                      controller: newTodoController,
                      decoration: const InputDecoration(
                        labelText: 'What needs to be done?',
                      ),
                      onSubmitted: (value) {
                        db.addTasks(
                            user: user,
                            data: {"name": value, "completed": false},
                            listId: _data.list);
                        newTodoController.clear();
                      },
                    ),
                  ));
                },
              );
            }),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => onTabTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.sync),
              onPressed: () => onTabTapped(3),
            ),
          ],
        )),
        body: _children[_currentIndex],
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
