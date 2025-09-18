import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  // Load user data from SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    
    if (userJson != null) {
      _user = UserModel.fromJson(Map<String, dynamic>.from(userJson as Map));
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUser() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _user!.toJson().toString());
    }
  }

  // Login user
  Future<void> login(UserModel user) async {
    _user = user;
    _isLoggedIn = true;
    await _saveUser();
    notifyListeners();
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
