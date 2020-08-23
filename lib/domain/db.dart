import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../model/element.dart';
import 'package:flutter/material.dart';

class DBService {
  final Firestore _db = Firestore.instance;

  /// Query a subcollection
  Stream<List<Task>> streamList(FirebaseUser user) {
    var ref = _db.collection('data').document(user.uid).collection('tasks');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Stream<List<Task>> tasks(FirebaseUser user, String listId) {
    var ref = _db
        .collection('data')
        .document(user.uid)
        .collection('tasks')
        .document(listId)
        .collection('subtask');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Future<void> addTasks({FirebaseUser user, dynamic data, String listId}) {
    return _db
        .collection('data')
        .document(user.uid)
        .collection('tasks')
        .document(listId)
        .collection('subtask')
        .document()
        .setData(data);
  }

  Future<void> addList(FirebaseUser user, dynamic data) {
    return _db
        .collection('data')
        .document(user.uid)
        .collection('tasks')
        .document()
        .setData(data);
  }

  Future<void> removeSub({FirebaseUser user, String id, String listId}) {
    return _db
        .collection('data')
        .document(user.uid)
        .collection('tasks')
        .document(listId)
        .collection('subtask')
        .document(id)
        .delete();
  }

  Future<void> removeList({FirebaseUser user, String listId}) {
    return _db
        .collection('data')
        .document(user.uid)
        .collection('tasks')
        .document(listId)
        .delete();
  }

  // task functions
  Future<void> update(
      {FirebaseUser user, bool check, String id, String listId}) {
    return _db
        .collection('data')
        .document(user.uid)
        .collection('tasks')
        .document(listId)
        .collection('subtask')
        .document(id)
        .updateData({'completed': check});
  }
}

class DataProvider extends ChangeNotifier {
  String _list = "-MDqWnGvhaT47yVHb2JB";
  String get list => _list;

  DataProvider();

  setlist(String newlist) {
    _list = newlist;
    notifyListeners();
  }
}
