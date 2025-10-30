import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerCarousel extends StatelessWidget {
  final List<String> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: banners.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(url, width: double.infinity, fit: BoxFit.cover),
        );
      }).toList(),
    );
  }
}


// ============================================================
// Here’s a suggested structure for your app:

// banners – Rotating banners

// {
//   "imageUrl": "https://example.com/banner1.jpg",
//   "link": "/product/123"
// }


// categories – Shop/product categories

// {
//   "name": "Grocery",
//   "iconUrl": "https://example.com/grocery_icon.png"
// }


// featuredDeals – Highlighted products

// {
//   "name": "Organic Milk",
//   "imageUrl": "https://example.com/milk.png",
//   "price": 5.99
// }


// shops – Nearby shops

// {
//   "name": "Fresh Mart",
//   "category": "Grocery",
//   "imageUrl": "https://example.com/mart.png",
//   "distance": 1.2,
//   "rating": 4.5
// }


// products – All products (optional, used for product details or search)

// {
//   "name": "Milk",
//   "category": "Grocery",
//   "imageUrl": "https://example.com/milk.png",
//   "price": 2.99,
//   "shopId": "shop_doc_id"
// }
// 1️⃣ Firestore Structure
// Create collections in Firestore:
// - banners
// - categories
// - featuredDeals
// - shops
// - products (optional)

// 4️⃣ How to Use in HomeScreen
// final bannersAsync = ref.watch(bannersProvider);
// final categoriesAsync = ref.watch(categoriesProvider);
// final dealsAsync = ref.watch(featuredDealsProvider);
// final shopsAsync = ref.watch(shopsProvider);


// Then use .when to handle loading / data / error:

// bannersAsync.when(
//   data: (banners) => BannerCarousel(
//     banners: banners.map((e) => e['imageUrl'] as String).toList(),
//   ),
//   loading: () => const CircularProgressIndicator(),
//   error: (_, __) => const Text('Error loading banners'),
// )


// Do the same for categories, featured deals, and shops.

// 5️⃣ Benefits

// Reactive updates: Firestore changes automatically update your UI.

// Scalable: Add cart, products, search, or user-specific data later without changing widgets.

// Separation: Service handles Firestore, provider handles state, widgets handle UI.

// =============================================================================


// home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../widgets/bottom_nav_bar.dart';
// import '../widgets/banner_carousel.dart';
// import '../widgets/category_list.dart';
// import '../widgets/featured_deals.dart';
// import '../widgets/shop_list_section.dart';
// import '../../data/home_provider.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//   static const routeName = '/home';

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   int _currentIndex = 0;
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     final bannersAsync = ref.watch(bannersProvider);
//     final categoriesAsync = ref.watch(categoriesProvider);
//     final dealsAsync = ref.watch(featuredDealsProvider);
//     final shopsAsync = ref.watch(shopsProvider);

//     final List<Widget> _pages = [
//       // --- Home Page ---
//       SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),

//             // Banners
//             bannersAsync.when(
//               data: (banners) => BannerCarousel(
//                 banners: banners.map((e) => e['imageUrl'] as String).toList(),
//               ),
//               loading: () => const SizedBox(
//                   height: 180, child: Center(child: CircularProgressIndicator())),
//               error: (_, __) =>
//                   const SizedBox(height: 180, child: Center(child: Text('Error loading banners'))),
//             ),
//             const SizedBox(height: 16),

//             // Search Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search products or shops...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onChanged: (val) => setState(() => _searchQuery = val),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Categories
//             categoriesAsync.when(
//               data: (categories) => CategoryList(categories: categories),
//               loading: () =>
//                   const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
//               error: (_, __) => const SizedBox(height: 100, child: Text('Error loading categories')),
//             ),
//             const SizedBox(height: 16),

//             // Featured Deals
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: const Text(
//                 'Featured Deals',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 8),
//             dealsAsync.when(
//               data: (deals) => FeaturedDeals(deals: deals),
//               loading: () =>
//                   const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
//               error: (_, __) => const SizedBox(height: 180, child: Text('Error loading deals')),
//             ),
//             const SizedBox(height: 16),

//             // Nearby Shops
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: const Text(
//                 'Nearby Best Shops',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 8),
//             shopsAsync.when(
//               data: (shops) {
//                 // Optionally filter shops by search query
//                 final filteredShops = _searchQuery.isEmpty
//                     ? shops
//                     : shops
//                         .where((shop) => (shop['name'] as String)
//                             .toLowerCase()
//                             .contains(_searchQuery.toLowerCase()))
//                         .toList();
//                 return ShopListSection(shops: filteredShops);
//               },
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (_, __) => const Center(child: Text('Error loading shops')),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),

//       // --- Search Page ---
//       const Center(child: Text('Search Page')),

//       // --- Offers Page ---
//       const Center(child: Text('Offers Page')),

//       // --- Cart Page ---
//       const Center(child: Text('Cart Page')),

//       // --- Profile Page ---
//       const Center(child: Text('Profile Page')),
//     ];

//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//       ),
//     );
//   }
// }

// Widgets

// BannerCarousel – Rotating banners

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class BannerCarousel extends StatelessWidget {
//   final List<String> banners;

//   const BannerCarousel({super.key, required this.banners});

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 180,
//         autoPlay: true,
//         enlargeCenterPage: true,
//       ),
//       items: banners
//           .map(
//             (url) => ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(url, width: double.infinity, fit: BoxFit.cover),
//             ),
//           )
//           .toList(),
//     );
//   }
// }


// CategoryList – Horizontal categories

// import 'package:flutter/material.dart';

// class CategoryList extends StatelessWidget {
//   final List<Map<String, dynamic>> categories;

//   const CategoryList({super.key, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           final cat = categories[index];
//           return Column(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(cat['iconUrl']),
//               ),
//               const SizedBox(height: 8),
//               Text(cat['name']),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }


// FeaturedDeals – Horizontal deals scroll

// import 'package:flutter/material.dart';

// class FeaturedDeals extends StatelessWidget {
//   final List<Map<String, dynamic>> deals;

//   const FeaturedDeals({super.key, required this.deals});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: deals.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           final deal = deals[index];
//           return Container(
//             width: 140,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.white,
//               boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4)],
//             ),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.network(
//                     deal['imageUrl'],
//                     height: 100,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(deal['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text('\$${deal['price']}'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// ShopListSection – Vertical list of shops

// You already have this implemented in your previous code; just make sure it’s connected to the shopsProvider.