import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../model/element.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DBService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Query a subcollection
  Stream<List<Task>> streamList(User user) {
    var ref = _db.collection('data').doc(user.uid).collection('tasks');

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Stream<List<Task>> tasks(User user, String listId) {
    var ref = _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .doc(listId)
        .collection('subtask');

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Future<void> addTasks(
      {User user, String data, String listId, DateTime date}) {
    var now = new DateFormat('yyyy-MM-dd').format(date);

    print(now + "  add method");

    /// var time = DateTime.parse(now);

    var name = {"name": data, "completed": false, "date": now};

    print(name);

    return _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .doc(listId)
        .collection('subtask')
        .doc()
        .set(name);
  }

  Future<void> testing({User user}) {
    final list = DataProvider();
    list.setlist("newlist");
    String d = list._list;
    print(d);
    return list.setlist("newlist");
  }

  Future<void> addList({User user, dynamic data}) {
    return _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .doc()
        .set(data);
  }

  Future<void> removeSub({User user, String id, String listId}) {
    return _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .doc(listId)
        .collection('subtask')
        .doc(id)
        .delete();
  }

  Future<void> docId({User user}) {
    return _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .get()
        .then((value) => print(value.docs[0].id));
  }

  Future<void> removeList({User user, String listId}) {
    return _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .doc(listId)
        .delete();
  }

  // task functions
  Future<void> update({User user, bool check, String id, String listId}) {
    return _db
        .collection('data')
        .doc(user.uid)
        .collection('tasks')
        .doc(listId)
        .collection('subtask')
        .doc(id)
        .update({'completed': check});
  }
}

class DataProvider extends ChangeNotifier {
// Try reading data from the counter key. If it doesn't exist, return 0.

  String _list = "-eMY8WdfnOkb0Vd5hY0JS";
  String get list => _list;
  
  DataProvider();

  setlist(String newlist) {

    print('dataprovier listid' + _list);

    _list = newlist;
    print('dataprovier listid' + _list);
    notifyListeners();
  }
}

class Indexc extends ChangeNotifier {
  int _index = 1;
  get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }
}
