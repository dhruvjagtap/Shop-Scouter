import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/presentation/auth_provider.dart';
import 'shop_scouter_loader.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(firebaseAuthProvider)
        .when(
          data: (user) {
            // Delay provider update and navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              updateUserAuth(ref, user);

              if (user != null) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (route) => false,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            });

            // Loader while deciding
            return const Scaffold(body: ShopScouterLoader());
          },
          loading: () => const Scaffold(body: ShopScouterLoader()),
          error: (err, stack) {
            debugPrint('Auth Stream Error: $err');
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          },
        );
  }
}
