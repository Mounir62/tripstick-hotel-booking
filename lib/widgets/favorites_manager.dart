import 'package:flutter/material.dart';
import '../models/real_hotel.dart';

/// Singleton helper to keep favorites in memory.
/// In production you’d persist these (e.g. SharedPrefs / Firestore).
class FavoritesManager {
  FavoritesManager._();
  static final FavoritesManager _i = FavoritesManager._();
  factory FavoritesManager() => _i;

  /// The current list of favorite properties.
  final ValueNotifier<List<Property>> notifier = ValueNotifier([]);

  bool isFavorite(Property p) =>
      notifier.value.any((item) => item.propertyToken == p.propertyToken);

  void toggle(Property p) {
    final list = List<Property>.from(notifier.value);
    final idx = list.indexWhere((x) => x.propertyToken == p.propertyToken);
    if (idx >= 0) {
      list.removeAt(idx);
    } else {
      list.add(p);
    }
    notifier.value = list;
  }
}
