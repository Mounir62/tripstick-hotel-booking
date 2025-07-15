import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<List<Hotel>> getHotels() async {
    final snapshot = await _db.collection('hotels').get();
    return snapshot.docs
        .map((doc) => Hotel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
