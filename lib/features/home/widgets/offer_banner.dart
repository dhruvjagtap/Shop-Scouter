import 'package:flutter/material.dart';

class OfferBanner extends StatelessWidget {
  final List<String> offerImages;

  const OfferBanner({super.key, required this.offerImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: offerImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            offerImages[index],
            width: 250,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
