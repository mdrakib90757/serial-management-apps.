import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceTaker_api/update_BookSerialService/update_BookSerialService.dart';
import 'package:SerialMan/model/mybooked_model.dart';

class GetUpdate_bookSerialProvider with ChangeNotifier {
  final UpdateBookSerialService _service = UpdateBookSerialService();

  List<MybookedModel> _bookSerialList = [];
  List<MybookedModel> get bookSerialList => _bookSerialList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetch_updateBookSerial(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookSerialList = await _service.get_UpdateBookSerial(date);
    } catch (e) {
      _errorMessage = e.toString();
      _bookSerialList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
