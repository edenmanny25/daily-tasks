import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskist/model/element.dart';
import 'package:taskist/domain/db.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

///list list
final addTodoKey = UniqueKey();

class DonePage extends HookWidget {
  final db = DBService();

  DonePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
        body: StreamProvider<List<Task>>.value(
      stream: db.streamList(user),
      initialData: [],
      child: Tilelist(),
    ));
  }
}

// list

class Tilelist extends HookWidget {
  final db = DBService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    var tasks = Provider.of<List<Task>>(context);
    DataProvider _states = Provider.of<DataProvider>(context);
    final newTodoController = useTextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextField(
          key: addTodoKey,
          controller: newTodoController,
          decoration: const InputDecoration(
            labelText: 'What needs to be done?',
          ),
          onSubmitted: (value) {
            db.addList(
              user,
              {"name": value, "completed": false},
            );
            newTodoController.clear();
          },
        ),
        Container(
          height: 300,
          child: ListView(
              children: tasks.map((task) {
            return Dismissible(
                key: ValueKey(task.id),
                onDismissed: (_) {
                  db.removeList(user: user, listId: task.id);
                },
                child: ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text(task.name),
                  onTap: () => _states.setlist(task.id),
                ));
          }).toList()),
        ),
      ],
    );
  }
}
