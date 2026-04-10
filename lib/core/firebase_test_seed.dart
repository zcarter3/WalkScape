import 'firebase_user_service.dart';

Future<void> seedTestProfiles() async {
  final service = FirebaseUserService();
  final testProfiles = [
    {'username': 'testuser', 'email': 'test@walkscape.com', 'password': 'test123'},
    {'username': 'alice', 'email': 'alice@walkscape.com', 'password': 'alicepass'},
    {'username': 'bob', 'email': 'bob@walkscape.com', 'password': 'bobpass'},
    {'username': 'charlie', 'email': 'charlie@walkscape.com', 'password': 'charliepass'},
    {'username': 'diana', 'email': 'diana@walkscape.com', 'password': 'dianapass'},
  ];
  for (final profile in testProfiles) {
    await service.createUser(profile['username']!, profile['email']!, profile['password']!);
  }
}
