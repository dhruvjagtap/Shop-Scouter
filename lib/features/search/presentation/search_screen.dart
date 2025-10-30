// // lib/features/search/presentation/search_screen.dart
// lib/features/search/presentation/search_screen.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';
import '../widgets/map_preview.dart';
import '../widgets/product_card.dart';
import '../widgets/shop_card.dart';
import '../widgets/search_bar.dart';
import 'search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  static const String routeName = '/search';

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<String> _recentSearches = [];
  List<_SuggestionItem> _suggestions = [];
  bool _loadingSuggestions = false;
  String _query = '';
  bool _showSuggestions = false;
  final int _suggestionLimit = 10;

  // Local fallback suggestions (MVP)
  final List<String> _localFallback = <String>[
    'iPhone 14 Pro',
    'iPhone 13',
    'iPhone Chargers',
    'Shoes',
    'Salon',
    'Grocery',
    'Coffee',
    'Laptop',
    'Headphones',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecent();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  // -------------------- Recent searches --------------------
  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _addToRecent(String term) async {
    if (term.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(term); // move to front
    _recentSearches.insert(0, term);
    if (_recentSearches.length > 10)
      _recentSearches = _recentSearches.sublist(0, 10);
    await prefs.setStringList('recent_searches', _recentSearches);
    setState(() {});
  }

  Future<void> _removeRecent(String term) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(term);
    await prefs.setStringList('recent_searches', _recentSearches);
    setState(() {});
  }

  Future<void> _clearAllRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    setState(() => _recentSearches.clear());
  }

  // -------------------- Input & suggestions --------------------
  void _onTextChanged() {
    final val = _controller.text;
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _handleDebounced(val),
    );
    setState(() {
      _query = val;
      _showSuggestions = val.trim().isNotEmpty;
    });
  }

  Future<void> _handleDebounced(String val) async {
    if (val.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _loadingSuggestions = false;
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _loadingSuggestions = true;
      _suggestions = [];
    });

    try {
      final List<_SuggestionItem> suggestions = [];

      // 1) Try Firebase suggestions (shops & products)
      final firestore = FirebaseFirestore.instance;

      // Query shops (prefix search)
      final shopQuery = firestore
          .collection('shops')
          .orderBy('name')
          .startAt([val])
          .endAt([val + '\uf8ff'])
          .limit(_suggestionLimit);

      final productQuery = firestore
          .collection('products')
          .orderBy('name')
          .startAt([val])
          .endAt([val + '\uf8ff'])
          .limit(_suggestionLimit);

      final futures = await Future.wait([
        shopQuery.get().catchError((_) => null),
        productQuery.get().catchError((_) => null),
      ]);

      final shopSnap = futures[0] as QuerySnapshot<Object?>?;
      final prodSnap = futures[1] as QuerySnapshot<Object?>?;

      if (shopSnap != null && shopSnap.docs.isNotEmpty) {
        for (final doc in shopSnap.docs) {
          final data = doc.data() as Map<String, dynamic>;
          suggestions.add(
            _SuggestionItem(
              text: data['name'] ?? '',
              subText: data['category'] ?? 'Shop',
              type: _SuggestionType.shop,
            ),
          );
          if (suggestions.length >= _suggestionLimit) break;
        }
      }

      if (prodSnap != null &&
          prodSnap.docs.isNotEmpty &&
          suggestions.length < _suggestionLimit) {
        for (final doc in prodSnap.docs) {
          final data = doc.data() as Map<String, dynamic>;
          suggestions.add(
            _SuggestionItem(
              text: data['name'] ?? '',
              subText: data['shopName'] ?? 'Product',
              type: _SuggestionType.product,
            ),
          );
          if (suggestions.length >= _suggestionLimit) break;
        }
      }

      // 2) If firebase produced nothing — use local fallback filtered by prefix
      if (suggestions.isEmpty) {
        final lower = val.toLowerCase();
        final matched = _localFallback
            .where((s) => s.toLowerCase().contains(lower))
            .toList();
        for (final s in matched.take(_suggestionLimit)) {
          suggestions.add(
            _SuggestionItem(
              text: s,
              subText: 'Suggested',
              type: _SuggestionType.local,
            ),
          );
        }
      }

      // 3) If still empty (rare), show the raw typed term as a suggestion
      if (suggestions.isEmpty) {
        suggestions.add(
          _SuggestionItem(
            text: val,
            subText: 'Search for "$val"',
            type: _SuggestionType.raw,
          ),
        );
      }

      setState(() {
        _suggestions = suggestions;
        _loadingSuggestions = false;
        _showSuggestions = true;
      });
    } catch (e, st) {
      if (kDebugMode) {
        // debug print but still fallback to local suggestions
        debugPrint('Suggestion error: $e\n$st');
      }
      final lower = val.toLowerCase();
      final matched = _localFallback
          .where((s) => s.toLowerCase().contains(lower))
          .toList();
      setState(() {
        _suggestions = matched
            .take(_suggestionLimit)
            .map(
              (s) => _SuggestionItem(
                text: s,
                subText: 'Fallback',
                type: _SuggestionType.local,
              ),
            )
            .toList();
        _loadingSuggestions = false;
        _showSuggestions = true;
      });
    }
  }

  // Trigger search via notifier
  Future<void> _submitSearch(String term) async {
    final notifier = ref.read(searchProvider.notifier);
    setState(() {
      _query = term;
      _controller.text = term;
      _showSuggestions = false;
      _loadingSuggestions = false;
      // move cursor to end
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
    await _addToRecent(term);
    // run search in provider (this uses your SearchService stream)
    await notifier.search(term);
  }

  Future<void> _onPullRefresh() async {
    // re-run latest search (or remove to reset)
    final notifier = ref.read(searchProvider.notifier);
    if (_query.trim().isEmpty) {
      // nothing to refresh; reload recent
      await _loadRecent();
      return;
    }
    await notifier.search(_query);
  }

  // -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);
    final isSearching = _query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products or Shops'),
        leading: BackButton(onPressed: () => Navigator.of(context).maybePop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic_none),
            onPressed: () {
              // Reserved for future voice search.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice search coming soon')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar (keeps your SearchBarField widget)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarField(
                      controller: _controller,
                      onChanged: (val) {
                        // _controller listener already handles debouncing
                      },
                      onSubmitted: (val) => _submitSearch(val.trim()),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _submitSearch(_controller.text.trim()),
                    ),
                ],
              ),
            ),

            // Suggestions or Recent or Map/Results area
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: _buildBody(searchState, isSearching, notifier),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    AsyncValue<Map<String, dynamic>> searchState,
    bool isSearching,
    SearchNotifier notifier,
  ) {
    // If the user is typing and suggestions visible -> show suggestions list
    if (_showSuggestions && _query.trim().isNotEmpty) {
      return _buildSuggestionList();
    }

    // No input yet -> show recent + Nearby map
    if (!isSearching) {
      return SingleChildScrollView(
        key: const ValueKey('idle_view'),
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent searches (custom simple UI)
              if (_recentSearches.isNotEmpty) _buildRecentChips(),
              const SizedBox(height: 8),
              const Text(
                'Nearby Shops',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const MapPreview(), // your placeholder map
              const SizedBox(height: 12),
              // Horizontal list of demo shop cards (if you later integrate live, swap here)
              const SizedBox(height: 8),
              _NearbyShopsPlaceholder(
                onVisit: (s) {
                  // optional: navigate to shop
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Visit $s')));
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    // Searching (show results, with pull-to-refresh)
    return searchState.when(
      data: (data) {
        final shops = (data['shops'] as List)
            .map((s) => s is Shop ? s : Shop.fromMap(s['id'], s))
            .toList();
        final products = (data['products'] as List)
            .map((p) => p is Product ? p : Product.fromMap(p['id'], p))
            .toList();

        if (shops.isEmpty && products.isEmpty) {
          return Center(
            key: const ValueKey('no_results'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('No results found', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // show suggestions again
                    setState(() => _showSuggestions = true);
                  },
                  child: const Text('Try suggestions'),
                ),
              ],
            ),
          );
        }

        // Results list
        return RefreshIndicator(
          onRefresh: _onPullRefresh,
          child: ListView(
            key: const ValueKey('results_list'),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (shops.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Text(
                    'Shops',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                ...shops
                    .map((s) => FadeInWrapper(child: ShopCard(shop: s)))
                    .toList(),
              ],
              if (products.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Text(
                    'Products',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                ...products
                    .map((p) => FadeInWrapper(child: ProductCard(product: p)))
                    .toList(),
              ],
              const SizedBox(height: 80), // padding for bottom
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSuggestionList() {
    return Container(
      key: const ValueKey('suggestions_view'),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          if (_loadingSuggestions)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: _suggestions.isEmpty
                ? Center(child: Text('No suggestions'))
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final s = _suggestions[index];
                      return ListTile(
                        leading: s.type == _SuggestionType.shop
                            ? const Icon(Icons.store)
                            : s.type == _SuggestionType.product
                            ? const Icon(Icons.shopping_bag)
                            : const Icon(Icons.search),
                        title: Text(s.text),
                        subtitle: Text(s.subText ?? ''),
                        onTap: () => _submitSearch(s.text),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent Searches',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _clearAllRecent,
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _recentSearches.map((s) {
              return InputChip(
                label: Text(s),
                onPressed: () => _submitSearch(s),
                onDeleted: () => _removeRecent(s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Simple nearby shops horizontal placeholder (you can later replace with real data)
class _NearbyShopsPlaceholder extends StatelessWidget {
  final void Function(String shopName) onVisit;
  const _NearbyShopsPlaceholder({required this.onVisit});

  @override
  Widget build(BuildContext context) {
    // Static demo list
    final demo = [
      Shop(
        id: '1',
        name: 'Café Sunrise',
        category: 'Café',
        imageUrl:
            'https://imgs.search.brave.com/vjQ51mZ4qOg4NgjWYPaeBUKL4IgQLyGr5HSm50okRTY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy9m/L2ZkL0NhZiVDMyVB/OV9kZV9GbG9yZS5q/cGc',
        imageUrls: const [],
        address: 'Somewhere',
        location: const GeoPoint(0, 0),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
      Shop(
        id: '2',
        name: 'GadgetMart',
        category: 'Electronics',
        imageUrl:
            'https://imgs.search.brave.com/bhEniXuLCYPTHT1aAzvoYvp5oKcdkmXLpSd0znLltWQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9tb2Rlcm4tc21h/cnRwaG9uZS1zaG9w/LXdpdGgtdmFyaW91/cy1uZXctcGhvbmVz/LWRpc3BsYXlfMTIz/NTgzMS01NDU0OS5q/cGc_c2VtdD1haXNf/aHlicmlkJnc9NzQw/JnE9ODA',
        imageUrls: const [],
        address: 'Somewhere',
        location: const GeoPoint(0, 0),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
      Shop(
        id: '3',
        name: 'QuickCuts Salon',
        category: 'Salon',
        imageUrl:
            'https://imgs.search.brave.com/GFdp_6UicdCzSFcpz-fvddP2nqhY7EXk2Ri9KefdOCg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvNzIz/NTA1MjUxL3Bob3Rv/L2VtcHR5LWNoYWly/cy1pbi1mcm9udC1v/Zi1taXJyb3JzLWF0/LWJhcmJlci1zaG9w/LmpwZz9zPTYxMng2/MTImdz0wJms9MjAm/Yz1ydUZpV1d2YUta/bGdvcnM0UTJMSkxI/MDBRY0ZCQ21MNng1/MGFfdkpDU080PQ',
        imageUrls: const [],
        address: 'Somewhere',
        location: const GeoPoint(0, 0),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: demo.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, idx) {
          final s = demo[idx];
          return SizedBox(
            width: 260,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        s.imageUrl ?? 'https://via.placeholder.com/150',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(s.category),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton(
                              // color: Theme.of(context).colorScheme.primary,
                              onPressed: () => onVisit(s.name),
                              child: const Text('Visit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A tiny wrapper to fade in list items (adds subtle polish)
class FadeInWrapper extends StatefulWidget {
  final Widget child;
  const FadeInWrapper({required this.child});

  @override
  State<FadeInWrapper> createState() => _FadeInWrapperState();
}

class _FadeInWrapperState extends State<FadeInWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _anim, child: widget.child);
  }
}

// -------------------- Suggestion model --------------------
enum _SuggestionType { shop, product, local, raw }

class _SuggestionItem {
  final String text;
  final String? subText;
  final _SuggestionType type;
  _SuggestionItem({required this.text, this.subText, required this.type});
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../domain/models.dart';
// import '../widgets/search_bar.dart';
// import '../widgets/recent_search_chips.dart';
// import '../widgets/map_preview.dart';
// import '../widgets/product_card.dart';
// import '../widgets/shop_card.dart';
// import 'search_provider.dart';

// class SearchPage extends ConsumerStatefulWidget {
//   const SearchPage({super.key});
//   static const String routeName = '/search';

//   @override
//   ConsumerState<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends ConsumerState<SearchPage> {
//   final TextEditingController _controller = TextEditingController();
//   String _query = '';

//   @override
//   Widget build(BuildContext context) {
//     final searchState = ref.watch(searchProvider);
//     final notifier = ref.read(searchProvider.notifier);

//     final isSearching = _query.isNotEmpty;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Products or Shops'),
//         leading: BackButton(),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.mic_none),
//             onPressed: () {}, // reserved for future voice search
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           SearchBarField(
//             controller: _controller,
//             onChanged: (val) {
//               setState(() => _query = val);
//               notifier.search(val);
//             },
//             onSubmitted: (val) {
//               setState(() => _query = val);
//               notifier.search(val);
//             },
//           ),
//           Expanded(
//             child: searchState.when(
//               data: (data) {
//                 final shops = (data['shops'] as List)
//                     .map((s) => s is Shop ? s : Shop.fromMap(s['id'], s))
//                     .toList();

//                 final products = (data['products'] as List)
//                     .map((p) => p is Product ? p : Product.fromMap(p['id'], p))
//                     .toList();

//                 // CASE 1: No input yet
//                 if (!isSearching) {
//                   return SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [RecentSearchChips(), MapPreview()],
//                     ),
//                   );
//                 }

//                 // CASE 2: Searching with no results
//                 if (isSearching && shops.isEmpty && products.isEmpty) {
//                   return const Center(child: Text('No results found'));
//                 }

//                 // CASE 3: Show results
//                 return ListView(
//                   children: [
//                     if (shops.isNotEmpty)
//                       const Padding(
//                         padding: EdgeInsets.all(8),
//                         child: Text(
//                           'Shops',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ...shops.map((s) => ShopCard(shop: s)).toList(),
//                     if (products.isNotEmpty)
//                       const Padding(
//                         padding: EdgeInsets.all(8),
//                         child: Text(
//                           'Products',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ...products.map((p) => ProductCard(product: p)).toList(),
//                   ],
//                 );
//               },
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (err, _) => Center(child: Text('Error: $err')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
