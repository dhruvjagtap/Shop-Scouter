import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OfferCard extends StatelessWidget {
  final String shopName;
  final String offerText;
  final String category;
  final String validTill;
  final String imageUrl;
  final VoidCallback onViewDetails;
  final VoidCallback onNavigate;
  final VoidCallback onGrabOffer;

  const OfferCard({
    super.key,
    required this.shopName,
    required this.offerText,
    required this.category,
    required this.validTill,
    required this.imageUrl,
    required this.onViewDetails,
    required this.onNavigate,
    required this.onGrabOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE + SHOP INFO ----------------
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offerText,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Category: $category",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "Valid Till: $validTill",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),

            // ---------------- ACTION BUTTONS ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  icon: Icons.store,
                  text: "View Details",
                  onTap: onViewDetails,
                ),
                _actionButton(
                  icon: Icons.navigation,
                  text: "Navigate",
                  onTap: onNavigate,
                ),
                _actionButton(
                  icon: Icons.local_offer,
                  text: "Grab Offer",
                  onTap: onGrabOffer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable action button widget
  Widget _actionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFC107), // golden yellow
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 2,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ======================================================================
//                         SHIMMER VERSION BELOW
// ======================================================================

class OfferCardShimmer extends StatelessWidget {
  const OfferCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- IMAGE + TEXT SHIMMER ----------------
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 120, height: 16),
                        const SizedBox(height: 6),
                        _shimmerBox(width: 100, height: 14),
                        const SizedBox(height: 6),
                        _shimmerBox(width: 140, height: 14),
                        const SizedBox(height: 6),
                        _shimmerBox(width: 80, height: 12),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),

              // ---------------- BUTTON SHIMMERS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buttonShimmer(),
                  _buttonShimmer(),
                  _buttonShimmer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text & image placeholder boxes
  Widget _shimmerBox({required double width, required double height}) {
    return Container(width: width, height: height, color: Colors.white);
  }

  // Fancy shimmer placeholder for buttons
  Widget _buttonShimmer() {
    return Container(
      height: 36,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[200]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
