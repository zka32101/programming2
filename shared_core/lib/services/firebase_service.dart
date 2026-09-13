import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userIdKey = 'firebase_uid';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String?> signInAnonymously() async {
    try {
      final current = _auth.currentUser;
      if (current != null) return current.uid;

      final cred = await _auth.signInAnonymously();
      final uid = cred.user?.uid;
      if (uid != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, uid);
      }
      return uid;
    } catch (e) {
      return _getLocalUserId();
    }
  }

  static Future<String> getUserId() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) return uid;
    return _getLocalUserId();
  }

  static Future<String> _getLocalUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_userIdKey);
    if (id == null) {
      id = 'local_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_userIdKey, id);
    }
    return id;
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}
