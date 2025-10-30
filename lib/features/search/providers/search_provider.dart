import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class SearchItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;

  SearchItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
  });
}

class SearchState {
  final bool isLoading;
  final String query;
  final List<SearchItem> results;
  final List<String> recentSearches;

  SearchState({
    required this.isLoading,
    required this.query,
    required this.results,
    required this.recentSearches,
  });

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<SearchItem>? results,
    List<String>? recentSearches,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(() {
  return SearchNotifier();
});

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() {
    return SearchState(
      isLoading: false,
      query: '',
      results: [],
      recentSearches: ['Coffee', 'Shoes', 'Laptop'],
    );
  }

  Future<void> onSearchQueryChanged(String query) async {
    state = state.copyWith(query: query);

    if (query.isEmpty) {
      state = state.copyWith(results: []);
      return;
    }

    state = state.copyWith(isLoading: true);

    // Simulate search delay
    await Future.delayed(const Duration(milliseconds: 700));

    // Mock results (replace with Firebase logic later)
    final mockResults = [
      SearchItem(
        title: 'MacBook Air M3',
        subtitle: 'TechStore',
        imageUrl: 'https://via.placeholder.com/150',
        price: 1199.99,
      ),
      SearchItem(
        title: 'Nike Air Max 270',
        subtitle: 'Urban Shoes',
        imageUrl: 'https://via.placeholder.com/150',
        price: 159.99,
      ),
      SearchItem(
        title: 'Organic Coffee Beans',
        subtitle: 'Brew Café',
        imageUrl: 'https://via.placeholder.com/150',
        price: 19.99,
      ),
    ];

    state = state.copyWith(
      isLoading: false,
      results: mockResults
          .where(
            (item) => item.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList(),
      recentSearches: {query, ...state.recentSearches}.take(5).toList(),
    );
  }

  Future<void> refresh() async {
    if (state.query.isNotEmpty) {
      await onSearchQueryChanged(state.query);
    }
  }
}
