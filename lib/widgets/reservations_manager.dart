import 'package:flutter/material.dart';
import '../models/real_hotel.dart';

/// Keeps reservations in memory with a ValueNotifier.
/// (Persist to local DB or backend in a production app.)
class ReservationsManager {
  ReservationsManager._();
  static final ReservationsManager _i = ReservationsManager._();
  factory ReservationsManager() => _i;

  final ValueNotifier<List<Property>> notifier = ValueNotifier([]);

  bool isReserved(Property p) =>
      notifier.value.any((e) => e.propertyToken == p.propertyToken);

  void add(Property p) {
    if (isReserved(p)) return;
    notifier.value = [...notifier.value, p];
  }

  void remove(Property p) =>
      notifier.value = notifier.value
          .where((e) => e.propertyToken != p.propertyToken)
          .toList();
}
