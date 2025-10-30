import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/home_service.dart';

final homeServiceProvider = Provider<HomeService>((ref) => HomeService());

final bannersProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(homeServiceProvider);
  return service.getBanners();
});

final categoriesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(homeServiceProvider);
  return service.getCategories();
});

final featuredDealsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(homeServiceProvider);
  return service.getFeaturedDeals();
});

final shopsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(homeServiceProvider);
  return service.getShops();
});

final productsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(homeServiceProvider);
  return service.getProducts();
});
