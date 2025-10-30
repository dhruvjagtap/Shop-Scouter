// import 'package:flutter/material.dart';

// class ShopCard extends StatelessWidget {
//   final String name;
//   final String category;
//   final String imageUrl;
//   final double distance;
//   final double rating;
//   final VoidCallback onViewDetails;

//   const ShopCard({
//     super.key,
//     required this.name,
//     required this.category,
//     required this.imageUrl,
//     required this.distance,
//     required this.rating,
//     required this.onViewDetails,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 imageUrl,
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   color: Colors.grey[300],
//                   width: 80,
//                   height: 80,
//                   child: const Icon(Icons.store, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     category,
//                     style: const TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.orange[400], size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         rating.toString(),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(width: 16),
//                       Icon(
//                         Icons.location_on,
//                         color: Colors.redAccent,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         "${distance.toStringAsFixed(1)} km",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: onViewDetails,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFFB703),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                     child: const Text("View Details"),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopCardUpdated extends StatelessWidget {
  final Map<String, dynamic> shop;

  const ShopCardUpdated({super.key, required this.shop});

  void _callShop(String number) async {
    final uri = Uri.parse("tel:$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    shop['imageUrl'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop['shopName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("${shop['distance'].toStringAsFixed(1)} km away"),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange[400], size: 14),
                          const SizedBox(width: 4),
                          Text(
                            shop['rating'].toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _callShop(shop['contactNumber']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB703),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Call"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (shop['hotDealsCount'] != null && shop['hotDealsCount'] > 0)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${shop['hotDealsCount']} Hot",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
