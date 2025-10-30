import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/banner_carousel.dart';
// import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_list.dart';
import '../widgets/featured_deal_card.dart';
import '../widgets/shop_card.dart';
import '../presentation/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final featuredDealsAsync = ref.watch(featuredDealsProvider);
    final shopsAsync = ref.watch(shopsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFB703),
        elevation: 1,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.black54),
            const SizedBox(width: 4),
            const Text('Pimpri, Pune', style: TextStyle(color: Colors.black87)),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ---------------- Banner Carousel ----------------
            bannersAsync.when(
              data: (banners) => BannerCarousel(
                banners: banners.map((b) => b['imageUrl'] as String).toList(),
              ),
              loading: () => const BannerShimmer(),
              error: (_, __) => const SizedBox(
                height: 180,
                child: Center(child: Text("Error loading banners")),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- Search Bar ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products or shops...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- Categories ----------------
            categoriesAsync.when(
              data: (categories) => const CategoryList(),
              loading: () => const CategoryShimmer(),
              error: (_, __) => const Text("Error loading categories"),
            ),

            const SizedBox(height: 16),

            // ---------------- Featured Deals ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Featured Deals",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            featuredDealsAsync.when(
              data: (deals) => SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: deals.length,
                  itemBuilder: (context, index) =>
                      FeaturedDealCard(deal: deals[index]),
                ),
              ),
              loading: () => const FeaturedDealShimmer(),
              error: (_, __) => const Text("Error loading deals"),
            ),

            const SizedBox(height: 16),

            // ---------------- Nearby Shops ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nearby Shops",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            shopsAsync.when(
              data: (shops) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shops.length,
                itemBuilder: (_, index) => ShopCardUpdated(shop: shops[index]),
              ),
              loading: () => const ShopShimmer(),
              error: (_, __) => const Text("Error loading shops"),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) {}),
    );
  }
}

// ==================== Shimmer Widgets ====================

// Banner Shimmer
class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Category Shimmer
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// Featured Deal Shimmer
class FeaturedDealShimmer extends StatelessWidget {
  const FeaturedDealShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

// Shop Shimmer
class ShopShimmer extends StatelessWidget {
  const ShopShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../widgets/bottom_nav_bar.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../widgets/banner_carousel.dart';
// import '../widgets/category_list.dart';
// import '../widgets/featured_deal_card.dart';
// import '../widgets/shop_card.dart';
// import '../presentation/home_providers.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});
//   static const String routeName = '/home';

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bannersAsync = ref.watch(bannersProvider);
//     final categoriesAsync = ref.watch(categoriesProvider);
//     final featuredDealsAsync = ref.watch(featuredDealsProvider);
//     final shopsAsync = ref.watch(shopsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Row(
//           children: [
//             const Icon(Icons.location_on, color: Colors.black54),
//             const SizedBox(width: 4),
//             const Text('Pimpri, Pune', style: TextStyle(color: Colors.black87)),
//             const Spacer(),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.notifications_outlined,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Banner Carousel
//             bannersAsync.when(
//               data: (banners) => BannerCarousel(
//                 banners: banners.map((b) => b['imageUrl'] as String).toList(),
//               ),
//               loading: () => const SizedBox(
//                 height: 180,
//                 child: Center(child: CircularProgressIndicator()),
//               ),
//               error: (_, __) => const SizedBox(
//                 height: 180,
//                 child: Center(child: Text("Error loading banners")),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Search bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search products or shops...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Categories
//             categoriesAsync.when(
//               data: (categories) =>
//                   CategoryList(), // you already have a working CategoryList
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading categories"),
//             ),

//             const SizedBox(height: 16),

//             // Featured Deals
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Featured Deals",
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             featuredDealsAsync.when(
//               data: (deals) => SizedBox(
//                 height: 220,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   separatorBuilder: (_, __) => const SizedBox(width: 12),
//                   itemCount: deals.length,
//                   itemBuilder: (context, index) =>
//                       FeaturedDealCard(deal: deals[index]),
//                 ),
//               ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading deals"),
//             ),

//             const SizedBox(height: 16),

//             // Nearby Shops
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Nearby Shops",
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             shopsAsync.when(
//               data: (shops) => ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: shops.length,
//                 itemBuilder: (_, index) => ShopCardUpdated(shop: shops[index]),
//               ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading shops"),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) {}),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../widgets/bottom_nav_bar.dart';
// import '../widgets/banner_carousel.dart';
// import '../widgets/category_list.dart';
// import '../widgets/featured_deal_card.dart';
// import '../widgets/shop_card_updated.dart';
// import '../presentation/home_provider.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   static const routeName = '/home';
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final bannersAsync = ref.watch(bannersProvider);
//     final categoriesAsync = ref.watch(categoriesProvider);
//     final featuredDealsAsync = ref.watch(featuredDealsProvider);
//     final shopsAsync = ref.watch(shopsProvider);

//     // --- Home Page Content ---
//     Widget homePageContent() {
//       return SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),

//             // Banner Carousel
//             bannersAsync.when(
//               data: (banners) => BannerCarousel(
//                 banners: banners.map((b) => b['imageUrl'] as String).toList(),
//               ),
//               loading: () => const SizedBox(
//                 height: 180,
//                 child: Center(child: CircularProgressIndicator()),
//               ),
//               error: (_, __) => const SizedBox(
//                 height: 180,
//                 child: Center(child: Text("Error loading banners")),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Search Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search products or shops...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Categories
//             categoriesAsync.when(
//               data: (categories) => CategoryList(),
//               loading: () =>
//                   const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading categories"),
//             ),

//             const SizedBox(height: 16),

//             // Featured Deals
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 "Featured Deals",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 8),
//             featuredDealsAsync.when(
//               data: (deals) => SizedBox(
//                 height: 220,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   separatorBuilder: (_, __) => const SizedBox(width: 12),
//                   itemCount: deals.length,
//                   itemBuilder: (context, index) =>
//                       FeaturedDealCard(deal: deals[index]),
//                 ),
//               ),
//               loading: () =>
//                   const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading deals"),
//             ),

//             const SizedBox(height: 16),

//             // Nearby Shops
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 "Nearby Shops",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 8),
//             shopsAsync.when(
//               data: (shops) => ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: shops.length,
//                 itemBuilder: (_, index) =>
//                     ShopCardUpdated(shop: shops[index]),
//               ),
//               loading: () =>
//                   const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading shops"),
//             ),

//             const SizedBox(height: 16),
//           ],
//         ),
//       );
//     }

//     // --- Search Page ---
//     Widget searchPage() {
//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search shops...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               ),
//               onChanged: (query) {
//                 // TODO: implement search filtering
//               },
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: shopsAsync.when(
//                 data: (shops) => ListView.builder(
//                   itemCount: shops.length,
//                   itemBuilder: (_, index) =>
//                       ShopCardUpdated(shop: shops[index]),
//                 ),
//                 loading: () =>
//                     const Center(child: CircularProgressIndicator()),
//                 error: (_, __) => const Text("Error loading shops"),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     // --- Offers Page ---
//     Widget offersPage() {
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             featuredDealsAsync.when(
//               data: (deals) => SizedBox(
//                 height: 220,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   separatorBuilder: (_, __) => const SizedBox(width: 12),
//                   itemCount: deals.length,
//                   itemBuilder: (context, index) =>
//                       FeaturedDealCard(deal: deals[index]),
//                 ),
//               ),
//               loading: () =>
//                   const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Text("Error loading deals"),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       );
//     }

//     // --- Profile Page ---
//     Widget profilePage() {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                     'https://via.placeholder.com/150.png?text=User'),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'John Doe',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               const Text('johndoe@example.com'),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.settings),
//                 label: const Text('Settings'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFFB703),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 12),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Logout'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final List<Widget> pages = [
//       homePageContent(),
//       searchPage(),
//       offersPage(),
//       profilePage(),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Row(
//           children: [
//             const Icon(Icons.location_on, color: Colors.black54),
//             const SizedBox(width: 4),
//             const Text('Pimpri, Pune',
//                 style: TextStyle(color: Colors.black87)),
//             const Spacer(),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.notifications_outlined,
//                   color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//       body: pages[_currentIndex],
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//       ),
//     );
//   }
// }
