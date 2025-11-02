import 'package:flutter/material.dart';
import 'package:SerialMan/api/auth_api/auth_api.dart';

import '../../../model/user_model.dart';

class BusinessTypeProvider with ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  List<Businesstype> businessTypes = [];
  bool isLoading = false;

  Future<void> fetchBusinessTypes() async {
    if (businessTypes.isNotEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      businessTypes = await _authApi.fetchBusinessType();
    } catch (e) {
      debugPrint("Error fetching business types: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getBusinessTypeNameById(int? id) {
    if (id == null) return "N/A";

    for (var type in businessTypes) {
      if (type.id == id) {
        return type.name;
      }
    }
    return "Unknown";
  }
}
