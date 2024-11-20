import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _searchUser = '';
  String get searchUser => _searchUser;
  set searchUser(String value) {
    _searchUser = value;
  }

  String _sortField = 'email';
  String get sortField => _sortField;
  set sortField(String value) {
    _sortField = value;
    notifyListeners();
  }
}
