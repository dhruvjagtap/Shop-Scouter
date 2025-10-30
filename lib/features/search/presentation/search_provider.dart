// lib/features/search/presentation/search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../data/search_service.dart';
import '../domain/models.dart';

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

class SearchNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final SearchService _service;
  String _currentQuery = '';
  DocumentSnapshot? _lastShopDoc;
  DocumentSnapshot? _lastProductDoc;
  Stream<Map<String, dynamic>>? _activeStream;
  List<Shop> _shops = [];

  List<Product> _products = [];
  StreamSubscription<Map<String, dynamic>>? _subscription;
  SearchNotifier(this._service)
    : super(const AsyncValue.data({'shops': [], 'products': []}));

  /// Start a new search (real-time + paginated)
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _clear();
      return;
    }
    _currentQuery = query;
    _cancelActiveStream();
    _resetPagination();
    state = const AsyncValue.loading();
    _activeStream = _service.searchAllStream(query: query);
    _subscription = _activeStream!.listen(
      (data) {
        _shops = data['shops'] ?? [];
        _products = data['products'] ?? [];
        _lastShopDoc = data['lastShopDoc'];
        _lastProductDoc = data['lastProductDoc'];
        state = AsyncValue.data({'shops': _shops, 'products': _products});
      },
      onError: (err, st) {
        state = AsyncValue.error(err, st);
      },
    );
  }

  /// Load next batch (pagination)
  Future<void> loadMore() async {
    if (_currentQuery.isEmpty) return;
    final nextStream = _service.searchAllStream(
      query: _currentQuery,
      lastShopDoc: _lastShopDoc,
      lastProductDoc: _lastProductDoc,
    );
    nextStream.listen((data) {
      final newShops = data['shops'] as List<Shop>;
      final newProducts = data['products'] as List<Product>;
      _shops.addAll(newShops);
      _products.addAll(newProducts);
      _lastShopDoc = data['lastShopDoc'];
      _lastProductDoc = data['lastProductDoc'];
      state = AsyncValue.data({'shops': _shops, 'products': _products});
    });
  }

  void _resetPagination() {
    _shops = [];
    _products = [];
    _lastShopDoc = null;
    _lastProductDoc = null;
  }

  void _clear() {
    _resetPagination();
    _cancelActiveStream();
    state = const AsyncValue.data({'shops': [], 'products': []});
  }

  void _cancelActiveStream() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _cancelActiveStream();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<Map<String, dynamic>>>(
      (ref) => SearchNotifier(ref.watch(searchServiceProvider)),
    );
