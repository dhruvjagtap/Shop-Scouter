import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: profileAsync.when(
        data: (profile) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // ---------------- HEADER ----------------
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profile.imageUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Edit Profile pressed'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------------- OPTIONS ----------------
              ProfileOptionCard(
                icon: Icons.shopping_bag_outlined,
                title: "My Orders",
                onTap: () {},
              ),
              ProfileOptionCard(
                icon: Icons.local_offer_outlined,
                title: "Saved Offers",
                onTap: () {},
              ),
              ProfileOptionCard(
                icon: Icons.payment_outlined,
                title: "Payment Methods",
                onTap: () {},
              ),
              ProfileOptionCard(
                icon: Icons.settings_outlined,
                title: "Settings",
                onTap: () {},
              ),
              ProfileOptionCard(
                icon: Icons.logout_outlined,
                title: "Logout",
                color: Colors.red,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully!')),
                  );
                },
              ),
            ],
          );
        },
        loading: () {
          return ListView.builder(
            itemCount: 3,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => const ProfileCardShimmer(),
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
