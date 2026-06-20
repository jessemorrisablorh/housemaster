import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:housemasterapp/Models/user_model.dart';
import 'package:housemasterapp/Services/user_services.dart';

class UserProvider extends ChangeNotifier {
  final UserServices _firestoreService = UserServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserProvider.initialize() {
    fetchData();
  }

  Future<void> fetchData() async {
    final user = _auth.currentUser;

    if (user == null) {
      _userModel = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userModel = await _firestoreService.getUserData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Optional: clear on logout
  void clear() {
    _userModel = null;
    notifyListeners();
  }
}
