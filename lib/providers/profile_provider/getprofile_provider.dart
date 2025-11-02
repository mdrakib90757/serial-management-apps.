import 'package:flutter/cupertino.dart';

import '../../api/profile_api/profile_api.dart';
import '../../model/profile_user_model.dart';

class Getprofileprovider with ChangeNotifier {
  final ProfileApi _profileApi = ProfileApi();

  profile_UserModel? _profileData;
  bool _isLoading = false;

  profile_UserModel? get profileData => _profileData;
  bool get isLoading => _isLoading;

  Future<void> fetchProfileData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profileData = await _profileApi.fetchUserProfile();
    } catch (e) {}

    _isLoading = false;
    notifyListeners();
  }
}
