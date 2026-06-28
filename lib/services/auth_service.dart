import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'furrr_users_db';
  static const String _currentUserKey = 'furrr_current_user';

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Get all registered users from SharedPreferences "database"
  Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    
    try {
      final List<dynamic> decoded = json.decode(usersJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Register a new user
  Future<String?> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (username.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      return "All fields are required.";
    }

    final users = await getRegisteredUsers();
    
    // Check duplication
    final emailExists = users.any((u) => u['email'].toString().toLowerCase() == email.toLowerCase());
    if (emailExists) {
      return "Email is already registered.";
    }

    final phoneExists = users.any((u) => u['phone'].toString() == phone);
    if (phoneExists) {
      return "Mobile number is already registered.";
    }

    // Add user record
    final newUser = {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'isGuest': false,
      'createdAt': DateTime.now().toIso8601String(),
    };

    users.add(newUser);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(users));
    await prefs.setString(_currentUserKey, json.encode(newUser));
    return null; // Return null on success
  }

  // Login registered user
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "Email and password are required.";
    }

    final users = await getRegisteredUsers();
    final userIndex = users.indexWhere(
      (u) => u['email'].toString().toLowerCase() == email.toLowerCase() && u['password'] == password
    );

    if (userIndex == -1) {
      return "Invalid email or password.";
    }

    final user = users[userIndex];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, json.encode(user));
    return null; // Return null on success
  }

  // Login as guest
  Future<void> loginAsGuest() async {
    final randomId = Random().nextInt(9000) + 1000;
    final guestUser = {
      'username': 'Guest_$randomId',
      'email': 'guest_$randomId@furrr.app',
      'phone': 'None',
      'isGuest': true,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Store in users DB as well so we track all users/guests "like a real database"
    final users = await getRegisteredUsers();
    users.add(guestUser);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(users));
    await prefs.setString(_currentUserKey, json.encode(guestUser));
  }

  // Get current logged-in user profile
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    
    try {
      return json.decode(userJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
