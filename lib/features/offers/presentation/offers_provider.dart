import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/offers_service.dart';

final offersServiceProvider = Provider<OffersService>((ref) => OffersService());

final offersProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(offersServiceProvider);
  return service.getOffers();
});
