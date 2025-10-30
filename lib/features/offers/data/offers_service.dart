import 'package:cloud_firestore/cloud_firestore.dart';

class OffersService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getOffers() {
    return _db
        .collection('offers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
