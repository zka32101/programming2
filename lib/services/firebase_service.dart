class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  bool get isAvailable => false; // Demo mode: Firebase is not available
  String? get userId => null;

  Future<List<Map<String, dynamic>>> fetchWeeklyRanking() async {
    return [];
  }
}
