import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskist/ui/page_done.dart';
import 'package:taskist/ui/page_settings.dart';
import 'package:taskist/ui/page_task.dart';
import 'package:taskist/ui/testpage.dart';
import 'package:taskist/domain/db.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskist/model/element.dart';

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
  DataProvider data;

  final List<Widget> _children = [
    DonePage(),
    TaskPage(),
    SettingsPage(),
    TestPage()
  ];

  @override
  Widget build(BuildContext context) {
    print('home page' + "😁😁");
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
                            return Lists();
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
                        Navigator.pop(context);
                      },
                    ),
                  ));
                },
              );
            }),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => onTabTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.bar_chart_rounded),
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

class Lists extends StatelessWidget {
  // returns a list of tasklists 😏
  final db = DBService();

  @override
  Widget build(BuildContext context) {
    print('Lists 😆😍🤑');

    var user = Provider.of<FirebaseUser>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamProvider<List<Task>>.value(
            stream: db.streamList(user), initialData: [], child: ListsHelper())
      ],
    );
  }
}

class ListsHelper extends StatelessWidget {
  final db = DBService();

  @override
  Widget build(BuildContext context) {
    print('ListsHelper 😆😍🤑😋');
    DataProvider _data = Provider.of<DataProvider>(context);

    var tasks = Provider.of<List<Task>>(context);
    var user = Provider.of<FirebaseUser>(context);

    return Container(
      height: 300,
      child: ListView(
          children: tasks.map((task) {
        return Dismissible(
            key: ValueKey(task.id),
            onDismissed: (_) {
              db.removeSub(
                user: user,
                id: task.id,
              );
            },
            child: ListTile(
              onTap: () {
                _data.setlist(task.id);
                Navigator.pop(context);
              },
              title: Text(task.name),
            ));
      }).toList()),
    );
  }
}
