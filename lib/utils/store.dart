import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increaseCount() {
    _count++;
    notifyListeners();
  }

  void decreaseCount() {
    _count--;
    notifyListeners();
  }
}
