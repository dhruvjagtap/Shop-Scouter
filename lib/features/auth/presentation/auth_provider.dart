import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Simple model to store app-specific user info
class UserAuth {
  final String uid;
  final String email;
  final String? name;

  UserAuth({required this.uid, required this.email, this.name});
}

// Stream provider to listen to FirebaseAuth changes
final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// App-specific user provider (null if not logged in)
final authStateProvider = StateProvider<UserAuth?>((ref) => null);

// Helper to update authStateProvider when Firebase user changes
void updateUserAuth(WidgetRef ref, User? user) {
  if (user != null) {
    ref.read(authStateProvider.notifier).state = UserAuth(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  } else {
    ref.read(authStateProvider.notifier).state = null;
  }
}
