import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_scouter/features/MainScreen/main_screen.dart';
import 'package:shop_scouter/features/offers/presentation/offers_screen.dart';
import 'package:shop_scouter/features/search/presentation/search_screen.dart';
import './features/splash/splash_screen.dart';
import './features/auth/presentation/login_screen.dart';
import './features/auth/presentation/register_screen.dart';
import 'features/home/presentation/home_screen.dart';
import './firebase_options.dart';

final List<Map<String, dynamic>> mockProducts = [
  {
    'name': 'Apple (1kg)',
    'shopId': 'shop1',
    'shopName': 'Fresh Mart',
    'description': 'Fresh and juicy apples directly from local farms.',
    'price': 180.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/9F3vSxyFzXnZjQwqOGvVld_3vJ4VGsvosq4spvcyqOQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMucHJvZHVjdGh1/YnMuY29tL21lZGlh/L2ltYWdlcy9mcnVpdHMvYXBwbGVzLmpwZw',
    'stock': 50,
    'unit': '1kg',
    'isActive': true,
    'isFeatured': true,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
    'priceHistory': [
      {'price': 190.0, 'updatedAt': Timestamp.now(), 'note': 'Weekly discount'},
    ],
  },
  {
    'name': 'Bananas (Dozen)',
    'shopId': 'shop1',
    'shopName': 'Fresh Mart',
    'description': 'Organic bananas full of nutrients.',
    'price': 60.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/NmKZ5M4fOa-wZ8xvRlNTxz8cq8pHbODgKn2q9j3F6sE/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9mcmVl/cGlrLmNvbS9pbWcv/MjAyMTAxL2JhbmFu/YXMuanBn',
    'stock': 100,
    'unit': '1 dozen',
    'isActive': true,
    'isFeatured': false,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
  },
  {
    'name': 'iPhone 15 Pro',
    'shopId': 'shop2',
    'shopName': 'Tech Town',
    'description': 'Apple iPhone 15 Pro with 256GB storage, Titanium finish.',
    'price': 134999.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/4JoWOfxTdOq9Krk3i6LVfKTxh6Q6US7rIocH17uHyDA/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdGF0/aWMuYXBwbGUuY29t/L2ltYWdlcy9pbmZv/L2lwaG9uZTE1cHJv/L2hlcm9pbWFnZS9p/cGhvbmUxNXByb19m/YW1pbHkxXzEuanBn',
    'stock': 10,
    'unit': '1 unit',
    'isActive': true,
    'isFeatured': true,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
    'priceHistory': [
      {'price': 139999.0, 'updatedAt': Timestamp.now(), 'note': 'Launch price'},
    ],
  },
  {
    'name': 'Wireless Headphones',
    'shopId': 'shop2',
    'shopName': 'Tech Town',
    'description': 'Noise-cancelling Bluetooth headphones with 30h battery.',
    'price': 3499.0,
    'currency': 'INR',
    'imageUrl':
        'https://imgs.search.brave.com/rmPQgrm44TPBbmZbE74eZxokU94lqPj0yXx4qYYxSYQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/c2hvcGlmeS5jb20v/cHJvZHVjdHMvaGVh/ZHBob25lcy5qcGc',
    'stock': 30,
    'unit': '1 piece',
    'isActive': true,
    'isFeatured': false,
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
  },
];

Future<void> uploadMockProducts() async {
  final firestore = FirebaseFirestore.instance;

  for (var product in mockProducts) {
    await firestore.collection('products').add(product);
  }

  debugPrint("✅ Mock products uploaded successfully!");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
  // uploadMockProducts();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color kGoldenColor = Color(0xFFFFB703);

    return MaterialApp(
      title: 'Shop Scouter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kGoldenColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kGoldenColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        OffersScreen.routeName: (context) => const OffersScreen(),
        SearchPage.routeName: (context) => const SearchPage(),
      },
    );
  }
}
