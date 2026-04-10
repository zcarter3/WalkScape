import 'package:firebase_database/firebase_database.dart';

class FirebaseUserService {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  Future<void> createUser(String username, String email, String password) async {
    await _usersRef.child(username).set({
      'username': username,
      'email': email,
      'password': password, // In production, hash this!
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final snapshot = await _usersRef.child(username).get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  Future<bool> authenticate(String username, String password) async {
    final user = await getUser(username);
    if (user == null) return false;
    return user['password'] == password;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final snapshot = await _usersRef.get();
    if (!snapshot.exists) return [];
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
