// lib/features/search/widgets/recent_search_chips.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchChips extends StatefulWidget {
  const RecentSearchChips({super.key});

  @override
  State<RecentSearchChips> createState() => _RecentSearchChipsState();
}

class _RecentSearchChipsState extends State<RecentSearchChips> {
  List<String> _recent = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recent = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    setState(() => _recent.clear());
  }

  Future<void> _removeItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    _recent.remove(item);
    await prefs.setStringList('recent_searches', _recent);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_recent.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: _recent.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeItem(item),
              );
            }).toList(),
          ),
          TextButton(
            onPressed: _clearAll,
            child: const Text('Clear all history'),
          ),
        ],
      ),
    );
  }
}
