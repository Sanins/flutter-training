import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  final List<Item> _items = [
    Item(
      title: 'Health Potion',
      description: 'Restores a small amount of health.',
      heal: 50,
    ),
  ];

  List<Item> get items => _items;

  void useItem(Item item) {
    item.use();
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item); // Remove the item
    notifyListeners(); // Notify listeners to update the UI
  }
}
