import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SerialMan/model/mybooked_model.dart';

import '../../../api/serviceTaker_api/bookSerial_ServiceTaker/bookSerial_ServiceTaker.dart';

class GetBookSerialProvider with ChangeNotifier {
  final BookSerialService _bookSerialService = BookSerialService();

  List<MybookedModel> _bookSerialList = [];
  List<MybookedModel> get bookSerialList => _bookSerialList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchgetBookSerial(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookSerialList = await _bookSerialService.getBookSerialButtonService(
        date,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _bookSerialList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
