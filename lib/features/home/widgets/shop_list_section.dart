// import 'package:flutter/material.dart';
// import 'shop_card.dart';

// class ShopListSection extends StatelessWidget {
//   final List<Map<String, dynamic>> shops;

//   const ShopListSection({super.key, required this.shops});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: shops.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         final shop = shops[index];
//         return ShopCard(
//           name: shop['name'],
//           category: shop['category'],
//           imageUrl: shop['imageUrl'],
//           distance: shop['distance'],
//           rating: shop['rating'],
//           onViewDetails: () {
//             // TODO: Navigate to shop details
//           },
//         );
//       },
//     );
//   }
// }
