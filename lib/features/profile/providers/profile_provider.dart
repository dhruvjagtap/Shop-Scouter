import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final String imageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, UserProfile>(() {
  return ProfileNotifier();
});

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); // simulate loading
    return UserProfile(
      name: "Aryan Mahato",
      email: "aryanmahato07.com",
      imageUrl:
          "https://imgs.search.brave.com/iqNtMFzPA0AyX1v_QsZwP7kzbrY1HPH4uaWwJl0h1rI/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzA1LzYwLzI2LzA4/LzM2MF9GXzU2MDI2/MDg4MF9PMVYzUW0y/Y05PNUhXak42Nm1C/aDJOcmxQSE5IT1V4/Vy5qcGc",
    );
  }
}
