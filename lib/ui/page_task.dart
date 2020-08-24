import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskist/model/element.dart';
import 'package:taskist/domain/db.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

///list tasks

final addTodoKey = UniqueKey();

class TaskPage extends HookWidget {
  final db = DBService();

  TaskPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TaskPage 6');
    var user = Provider.of<FirebaseUser>(context);
    DataProvider _data = Provider.of<DataProvider>(context);

    return Scaffold(
        body: StreamProvider<List<Task>>.value(
      stream: db.tasks(user, _data.list),
      initialData: [],
      child: Tilelist(),
    ));
  }
}

class Tilelist extends StatelessWidget {
  final db = DBService();

  Tilelist({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Tilelist  7️');

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Tab 1",
              ),
              Tab(text: "Tab 2"),
            ],
          ),
        ),
        body: TabBarView(
          children: [AllTask(), CompletedTask()],
        ),
      ),
    );
  }
}

class CompletedTask extends StatelessWidget {
  CompletedTask({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("hi"),
    );
  }
}

class AllTask extends StatelessWidget {
  final db = DBService();

  AllTask({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataProvider data = Provider.of<DataProvider>(context);
    var user = Provider.of<FirebaseUser>(context);
    var tasks = Provider.of<List<Task>>(context);

    return ListView(
        children: tasks.map((task) {
      return Dismissible(
          key: ValueKey(task.id),
          onDismissed: (_) {
            db.removeSub(user: user, id: task.id, listId: data.list);
          },
          child: ListTile(
            leading: Checkbox(
                value: task.completed,
                onChanged: (value) => db.update(
                    user: user, check: value, id: task.id, listId: data.list)),
            title: Text(task.name),
          ));
    }).toList());
  }
}
