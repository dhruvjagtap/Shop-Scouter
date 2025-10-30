// lib/features/search/data/search_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/models.dart';
import 'package:rxdart/rxdart.dart'; // for combining streams

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Real-time + paginated search
  Stream<Map<String, dynamic>> searchAllStream({
    required String query,
    int limit = 10,
    DocumentSnapshot? lastShopDoc,
    DocumentSnapshot? lastProductDoc,
  }) {
    if (query.trim().isEmpty) {
      return Stream.value({
        'shops': <Shop>[],
        'products': <Product>[],
        'lastShopDoc': null,
        'lastProductDoc': null,
      });
    }

    Query<Map<String, dynamic>> shopQuery = _firestore
        .collection('shops')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .limit(limit);

    Query<Map<String, dynamic>> productQuery = _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .limit(limit);

    if (lastShopDoc != null) {
      shopQuery = shopQuery.startAfterDocument(lastShopDoc);
    }
    if (lastProductDoc != null) {
      productQuery = productQuery.startAfterDocument(lastProductDoc);
    }

    final shopsStream = shopQuery.snapshots();
    final productsStream = productQuery.snapshots();

    return Rx.combineLatest2(shopsStream, productsStream, (
      QuerySnapshot shopSnap,
      QuerySnapshot productSnap,
    ) {
      final shops = shopSnap.docs
          .map(
            (doc) => Shop.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();

      final products = productSnap.docs
          .map(
            (doc) =>
                Product.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();

      return {
        'shops': shops,
        'products': products,
        'lastShopDoc': shopSnap.docs.isNotEmpty ? shopSnap.docs.last : null,
        'lastProductDoc': productSnap.docs.isNotEmpty
            ? productSnap.docs.last
            : null,
      };
    });
  }
}
