import 'package:flutter/material.dart';

import '../../api/serviceTaker_api/service_taker_service_type/serviceTypeSerialBook_service.dart';
import '../../model/service_type_model.dart';

class serviceTypeSerialbook_Provider with ChangeNotifier {
  final serviceTypeSerialBook_service _typeserialbook_service =
      serviceTypeSerialBook_service();

  String? _token;
  String? get token => _token;

  List<serviceTypeModel> _serviceTypeList = [];
  List<serviceTypeModel> get serviceTypeList => _serviceTypeList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> serviceType_serialbook(String companyId) async {
    _isLoading = true;
    notifyListeners();

    if (companyId.isEmpty) {
      print("companyId ID is missing. Cannot fetch service types.");
      _serviceTypeList = [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    debugPrint("Fetching service centers with a valid token...");

    _serviceTypeList = await _typeserialbook_service.serviceTypeSerialBook(
      companyId,
    );
    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serviceTypeList = [];
    _token = null;
    _isLoading = false;

    notifyListeners();
    print("serviceTypeSerial_book_Provider cleared!");
  }
}
