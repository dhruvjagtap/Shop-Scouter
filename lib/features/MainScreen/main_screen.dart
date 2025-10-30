import 'package:flutter/material.dart';
import 'package:shop_scouter/features/cart/presentation/cart_screen.dart';
import 'package:shop_scouter/features/profile/presentation/profile_screen.dart';
import 'package:shop_scouter/features/search/presentation/search_screen1.dart';
import '../home/presentation/home_screen.dart';
import '../offers/presentation/offers_screen.dart';
import '../home/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OffersScreen(),
    const SearchScreen1(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
