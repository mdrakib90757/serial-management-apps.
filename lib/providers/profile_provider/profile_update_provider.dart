// lib/providers/profile_update_provider.dart (আপনার ProfileProvider)
import 'package:flutter/material.dart';
import 'package:SerialMan/request_model/update_profile_request.dart';

import '../../api/profile_api/profile_api.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileApi _profileApi = ProfileApi();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> updateUserProfile(UpdateProfileRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _profileApi.updateProfile(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
