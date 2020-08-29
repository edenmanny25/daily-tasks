import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskist/ui/page_done.dart';
import 'package:taskist/ui/page_settings.dart';
import 'package:taskist/ui/page_task.dart';
import 'package:taskist/ui/testpage.dart';
import 'package:taskist/domain/db.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskist/model/element.dart';
import 'package:intl/intl.dart';

final addTodoKey = UniqueKey();

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Nav());
  }
}

class Nav extends StatelessWidget {
  final List<Widget> _children = [
    DonePage(),
    TaskPage(),
    SettingsPage(),
    TestPage()
  ];

  @override
  Widget build(BuildContext context) {
    print('nav page' + "😁😁");
    var index = Provider.of<Indexc>(context);

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          elevation: 5.0,
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.list_alt),
                  color: index.index == 1 ? Colors.blue : Colors.black,
                  onPressed: () {
                    index.index = 1;
                  }),
              Builder(
                  builder: (context) => IconButton(
                        icon: Icon(Icons.note_add),
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
              Padding(
                padding: const EdgeInsets.only(left: 80.0),
                child: IconButton(
                    icon: Icon(Icons.settings),
                    color: index.index == 2 ? Colors.blue : Colors.black,
                    onPressed: () {
                      index.index = 2;
                    }),
              ),
              IconButton(
                  icon: Icon(Icons.bar_chart_rounded),
                  color: index.index == 3 ? Colors.blue : Colors.black,
                  onPressed: () {
                    index.index = 3;
                  }),
            ],
          ),
        ),
        body: _children[index.index],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            /// use consumer to only build the

            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Add()));
              },
            );
            index.index == 1 ? print("1") : index.index = 1;
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
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
            stream: db.streamList(user), initialData: [], child: ListsHelper()),
        FlatButton(
            onPressed: () {
              db.addList(user: user, data: {"name": "jelle3"});
            },
            child: Text("data"))
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
      height: tasks.length.toDouble() * 50,
      child: ListView(
          scrollDirection: Axis.vertical,
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
                  tileColor: _data.list == task.id ? Colors.blue : Colors.white,
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

class Add extends StatefulWidget {
  Add({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<Add> {
  final newTodoController = TextEditingController();
  final db = DBService();
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    print("add rebuild");
    var user = Provider.of<FirebaseUser>(context);
    DataProvider _data = Provider.of<DataProvider>(context);

    return Column(
      children: <Widget>[
        TextField(
          autofocus: true,
          key: addTodoKey,
          controller: newTodoController,
          decoration: const InputDecoration(
            labelText: 'What needs to be done?',
          ),
          onSubmitted: (value) {
            final date = _dateTime;
            print(date.toString() + " finish button");
            db.addTasks(
                user: user, data: value, listId: _data.list, date: date);
            newTodoController.clear();
            Navigator.pop(context);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              child: Text('Pick a date'),
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate:
                            _dateTime == null ? DateTime.now() : _dateTime,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2021))
                    .then((date) {
                  setState(() {
                    _dateTime = date;
                  });

                  print(date.toString() + " " + _dateTime.toString());
                });
              },
            ),
            Text(_dateTime == null ? " no selection" : _dateTime.toString()),
            RaisedButton(
                child: Text('finish'),
                onPressed: () {
                  String value = newTodoController.toString();
                  final date = _dateTime;
                  print(date.toString() + " finish button");
                  db.addTasks(
                      user: user, data: value, listId: _data.list, date: date);
                  newTodoController.clear();
                  Navigator.pop(context);
                })
          ],
        ),
      ],
    );
  }
}
