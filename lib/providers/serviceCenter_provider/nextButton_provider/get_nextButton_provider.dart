import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/nextButton_serviceCenter/nextButton_service.dart';

import '../../../model/serialService_model.dart';

class GetNextButtonProvider with ChangeNotifier {
  final NextButtonService _nextButtonService = NextButtonService();

  List<SerialModel> _serials = [];
  List<SerialModel> get serials => _serials;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNextButton(String serviceCenterId, String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _serials = (await _nextButtonService.getNextButton(
        serviceCenterId,
        date,
      ));
    } catch (e) {
      _errorMessage = e.toString();
      _serials = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serials = [];
    _isLoading = false;
    _errorMessage = null;

    notifyListeners();
    print("SerialListProvider cleared!");
  }
}
