import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String? uid;
  final String? displayName;
  final String? photoUrl;

  UserProfile({
    this.uid,
    this.displayName,
    this.photoUrl,
  });
}

final userProfileProvider = StateProvider<UserProfile?>((ref) {
  return null;
});
