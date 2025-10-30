import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultCardShimmer extends StatelessWidget {
  const SearchResultCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: Container(height: 16, width: 100, color: Colors.white),
          subtitle: Container(height: 14, width: 60, color: Colors.white),
        ),
      ),
    );
  }
}
