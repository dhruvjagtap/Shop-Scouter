import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_shimmer.dart';

class SearchScreen1 extends ConsumerStatefulWidget {
  const SearchScreen1({super.key});
  static const routeName = '/search';

  @override
  ConsumerState<SearchScreen1> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen1> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(searchProvider.notifier).refresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ---------------- SEARCH BAR ----------------
              TextField(
                controller: _controller,
                onChanged: (query) => ref
                    .read(searchProvider.notifier)
                    .onSearchQueryChanged(query),
                decoration: InputDecoration(
                  hintText: "Search for shops, products or offers",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ---------------- STATE VIEWS ----------------
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: () {
                    if (searchState.isLoading) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            const SearchResultCardShimmer(),
                      );
                    } else if (searchState.query.isEmpty) {
                      return _RecentSearchesList(
                        recentSearches: searchState.recentSearches,
                        onSelect: (text) {
                          _controller.text = text;
                          ref
                              .read(searchProvider.notifier)
                              .onSearchQueryChanged(text);
                        },
                      );
                    } else if (searchState.results.isEmpty) {
                      return const Center(child: Text("No results found."));
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: searchState.results.length,
                        itemBuilder: (context, index) {
                          final item = searchState.results[index];
                          return SearchResultCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            imageUrl: item.imageUrl,
                            price: item.price,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tapped on ${item.title}'),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  }(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ RECENT SEARCHES ------------------
class _RecentSearchesList extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSelect;

  const _RecentSearchesList({
    required this.recentSearches,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return const Center(child: Text("No recent searches yet."));
    }

    return ListView(
      children: [
        const Text(
          "Recent Searches",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...recentSearches.map(
          (term) => ListTile(
            leading: const Icon(Icons.history, color: Colors.black54),
            title: Text(term),
            trailing: const Icon(
              Icons.north_west,
              size: 18,
              color: Colors.black45,
            ),
            onTap: () => onSelect(term),
          ),
        ),
      ],
    );
  }
}
