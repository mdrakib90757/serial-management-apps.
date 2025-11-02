import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:SerialMan/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth_api/auth_api.dart';
import '../../api/profile_api/profile_api.dart';
import '../../model/serialService_model.dart' hide ProfileData;
import '../../model/user_model.dart' hide ProfileData;
import '../../request_model/auth_request/login_request.dart';
import '../../request_model/auth_request/register_requset.dart';
import '../../request_model/auth_request/serviceTaker_register.dart';

class AuthProvider with ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final ProfileApi _profileApi = ProfileApi();

  List<Businesstype> _businessTypes = [];
  bool _isBusinessTypesLoading = false;
  String? _businessTypesError;

  //setter variable
  User_Model? _userModel;
  ServiceTaker? _serviceTaker;
  String? _userType;
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;
  String? _refreshToken;

  //getter variable
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User_Model? get userModel => _userModel;
  ServiceTaker? get serviceTaker => _serviceTaker;
  String? get userType => _userType;
  String? get accessToken => _accessToken;
  ProfileData? get userProfileData => _userModel?.user.profileData;

  List<Businesstype> get businessTypes => _businessTypes;
  bool get isBusinessTypesLoading => _isBusinessTypesLoading;
  String? get businessTypesError => _businessTypesError;

  /// Login a user using LoginRequest model. Returns true on success.
  Future<bool> login({required LoginRequest request}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authApi.login(request) as Map<String, dynamic>;

      if (response["data"] == null || response["data"]["accessToken"] == null) {
        throw Exception("Invalid response: Missing access token.");
      }

      _accessToken = response["data"]["accessToken"];
      _refreshToken = response["data"]["refreshToken"];

      if (response["data"]["serviceTaker"] != null) {
        _serviceTaker = ServiceTaker.fromJson(response["data"]["serviceTaker"]);
      }

      await _saveToken(_accessToken!);
      await loadUserFromToken();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      print("Login Error: $_errorMessage");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load user data from the token stored in SharedPreferences.
  Future<void> loadUserFromToken() async {
    final token = await _getToken();
    if (token == null) {
      print("No token found.");
      return;
    }

    try {
      // after add if condition code because token expire to user navigate login screen and user again login and next workflow
      if (JwtDecoder.isExpired(token)) {
        print("Token expired. Logging out...");
        await logout();
        return;
      }

      _accessToken = token;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      _userType = decodedToken["userType"]?.toString().trim();

      _userModel = _buildUserModelFromToken(decodedToken);

      if (_userType?.toLowerCase() == "customer" && _userModel != null) {
        _serviceTaker = _buildServiceTakerFromUserModel(_userModel!);
      }

      notifyListeners();
      print("User loaded from token successfully.");
    } catch (e) {
      print("Failed to load user from token: $e");
      await logout();
    }
  }

  /// Log out the user and clear all session data.
  Future<void> logout() async {
    await _removeToken();
    _accessToken = null;
    _refreshToken = null;
    _userType = null;
    _userModel = null;
    _serviceTaker = null;
    _errorMessage = null;
    notifyListeners();
    print("User logged out and session cleared.");
  }

  /// Register a service center.
  Future<Map<String, dynamic>> registerServiceCenter({
    required RegisterRequest request,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _authApi.register(request) as Map<String, dynamic>;

      if (result.containsKey("user") && result["user"] != null) {
        return {
          'success': true,
          'message': 'Registration Successful',
          'data': result,
        };
      } else {
        throw Exception(
          result["message"] ??
              result["errorMessage"] ??
              "Registration failed due to an unknown server error.",
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      return {'success': false, 'message': _errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register a service taker.
  Future<Map<String, dynamic>> registerServiceTaker({
    required ServiceTakerRequest request,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result =
          await _authApi.serviceTakerRegister(request) as Map<String, dynamic>;

      if (result.containsKey("id") && result["id"] != null) {
        return {
          'success': true,
          'message': 'Registration Successful',
          'data': result,
        };
      } else {
        throw Exception(result["message"] ?? "Registration Failed.");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      return {'success': false, 'message': _errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String newName,
    required String newEmail,
    required String newMobileNo,
    required ProfileData? newProfileData,
  }) async {
    if (userModel != null) {
      final updatedUser = userModel!.user.copyWith(
        name: newName,
        email: newEmail,
        mobileNo: newMobileNo,
        profileData: newProfileData,
      );

      _userModel = User_Model(
        company: userModel!.company,
        user: updatedUser,
        serviceCenter: userModel!.serviceCenter,
        token: accessToken,
      );

      notifyListeners();

      print("AuthProvider user model updated successfully!");
    }
  }

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // --- Helper and Private Methods ---

  /// Builds a User_Model object from a decoded JWT token.
  User_Model _buildUserModelFromToken(Map<String, dynamic> decodedToken) {
    ProfileData? profileObj;
    try {
      final profileRaw = decodedToken["profileData"];
      if (profileRaw != null) {
        if (profileRaw is String) {
          final decodedProfile = jsonDecode(profileRaw);
          profileObj = ProfileData.fromJson(decodedProfile);
        } else if (profileRaw is Map<String, dynamic>) {
          profileObj = ProfileData.fromJson(profileRaw);
        }
      }
    } catch (e) {
      print("Error decoding profileData: $e");
    }

    return User_Model(
      company: Company(
        id: "",
        name: "Default Company",
        addressLine1: "",
        addressLine2: "",
        email: decodedToken["email"] ?? "",
        phone: decodedToken["mobileNo"] ?? "",
        createDate: "",
        isActive: true,
        businessTypeId: 0,
      ),
      user: User(
        id: decodedToken["userId"] ?? "",
        name: decodedToken["name"] ?? "",
        email: decodedToken["email"] ?? "",
        mobileNo: decodedToken["mobileNo"] ?? "",
        loginName: decodedToken["loginName"] ?? "",
        registeredDate: "",
        isActive: true,
        userType: decodedToken["userType"] ?? "",
        profileData: profileObj,
      ),
      serviceCenter: ServiceCenter(
        id: "",
        name: "",
        email: "",
        hotlineNo: "",
        companyId: "",
      ),
      token: _accessToken ?? '',
    );
  }

  /// Builds a ServiceTaker object from a User_Model.
  ServiceTaker _buildServiceTakerFromUserModel(User_Model userModel) {
    return ServiceTaker(
      id: userModel.user.id,
      name: userModel.user.name,
      email: userModel.user.email,
      phone: userModel.user.mobileNo,
      loginName: userModel.user.loginName,
      password: "",
      registeredDate: userModel.user.registeredDate,
      isActive: userModel.user.isActive,
      userType: userModel.user.userType,
      profileData: userModel.user.profileData,
    );
  }

  // --- Token Management (Private) ---

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

  Future<void> fetchBusinessTypes() async {
    _isBusinessTypesLoading = true;
    _businessTypesError = null;
    notifyListeners();

    try {
      _businessTypes = await _authApi.fetchBusinessType();
      print("Loaded Business Types: ${_businessTypes.length}");
    } catch (e) {
      _businessTypesError = "Failed to load business types: $e";
      print(_businessTypesError);
    } finally {
      _isBusinessTypesLoading = false;
      notifyListeners();
    }
  }
}
