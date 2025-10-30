import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/home_providers.dart';

class CategoryList extends ConsumerStatefulWidget {
  const CategoryList({super.key});

  @override
  ConsumerState<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends ConsumerState<CategoryList> {
  bool _showAll = false;

  Widget _buildCategoryCard(String imageUrl, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text("No categories available"));
        }

        // Show first 7 categories by default or all if _showAll
        final displayedCategories = _showAll
            ? categories
            : categories.take(7).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                "Categories",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount:
                    displayedCategories.length + 1, // +1 for See More/See Less
                itemBuilder: (context, index) {
                  // Last card: See More / See Less
                  if (!_showAll && index == displayedCategories.length) {
                    return _buildCategoryCard(
                      'https://cdn-icons-png.flaticon.com/128/339/339145.png',
                      "See More",
                      () => setState(() => _showAll = true),
                    );
                  }
                  if (_showAll && index == displayedCategories.length) {
                    return _buildCategoryCard(
                      'https://cdn-icons-png.flaticon.com/128/17909/17909169.png',
                      "See Less",
                      () => setState(() => _showAll = false),
                    );
                  }

                  final category = displayedCategories[index];
                  final name = category['categoryName'] ?? 'Unknown';
                  final imageUrl =
                      category['imageUrl'] ??
                      'https://via.placeholder.com/40.png?text=?';

                  return _buildCategoryCard(imageUrl, name, () {
                    // Navigate to category detail screen if needed
                    // Navigator.pushNamed(context, ProviderListScreen.routeName,
                    //     arguments: name);
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error loading categories: $err")),
    );
  }
}

// ====================================================================================
// Perfect! We can make the CategoryList itself shimmer while the categories are loading, so each card has a placeholder instead of a blank grid. Here’s how to do it:

// Step 1: Create a shimmer for a single category card
// class CategoryCardShimmer extends StatelessWidget {
//   const CategoryCardShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               width: 40,
//               height: 12,
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Step 2: Create a grid of shimmer cards
// class CategoryGridShimmer extends StatelessWidget {
//   const CategoryGridShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         mainAxisSpacing: 12,
//         crossAxisSpacing: 12,
//         childAspectRatio: 1,
//       ),
//       itemCount: 8, // Show 8 shimmer cards
//       itemBuilder: (_, __) => const CategoryCardShimmer(),
//     );
//   }
// }

// Step 3: Update HomeScreen to use the new shimmer

// Replace the loading state for categories:

// categoriesAsync.when(
//   data: (categories) => const CategoryList(),
//   loading: () => const CategoryGridShimmer(),
//   error: (_, __) => const Text("Error loading categories"),
// ),
