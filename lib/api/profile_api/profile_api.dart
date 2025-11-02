import 'dart:convert';
import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/request_model/update_profile_request.dart';
import '../../model/profile_user_model.dart';

class ProfileApi {
  Future<profile_UserModel> fetchUserProfile() async {
    var response = await ApiClient().get('/me/v2/profile');
    var profileData = profile_UserModel.fromJson(response);
    return profileData;
  }

  Future<bool> updateProfile(UpdateProfileRequest requestData) async {
    String body = jsonEncode(requestData.toJson());
    await ApiClient().post('/me/profile', body: body);
    return true;
  }
}
