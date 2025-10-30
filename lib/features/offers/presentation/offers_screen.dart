import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import './offers_provider.dart';
import '../widgets/offers_card.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});
  static const String routeName = '/offers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsyncValue = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exclusive Offers Near You"),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: offersAsyncValue.when(
        data: (offers) {
          if (offers.isEmpty) {
            return const Center(
              child: Text('No offers available at the moment.'),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(), // 👈 smooth iOS-like scroll
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];

              // Firestore data safety: fallback to defaults if null
              final shopName = offer['shopName'] ?? 'Unknown Shop';
              final offerText = offer['offerText'] ?? 'No Offer Details';
              final category = offer['category'] ?? 'General';
              final validTill = offer['validTill'] ?? 'N/A';
              final imageUrl = offer['imageUrl'] ?? '';

              return OfferCard(
                shopName: shopName,
                offerText: offerText,
                category: category,
                validTill: validTill,
                imageUrl: imageUrl,
                onViewDetails: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('View Details clicked for $shopName'),
                    ),
                  );
                },
                onNavigate: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigate clicked for $shopName')),
                  );
                },
                onGrabOffer: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Grab Offer clicked for $shopName')),
                  );
                },
              );
            },
          );
        },
        loading: () {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const OfferCardShimmer(),
          );
        },
        error: (error, stack) =>
            Center(child: Text('Error loading offers: $error')),
      ),
    );
  }
}
