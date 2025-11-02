import 'package:flutter/cupertino.dart';
import 'package:SerialMan/api/serviceCenter_api/divisionServiceCenter/divisionServiceCenter.dart';
import 'package:SerialMan/model/division_model.dart';

class DivisionProvider with ChangeNotifier {
  final DivisionServiceCenter _divisionServiceCenter = DivisionServiceCenter();

  List<DivisionModel> _divisions = [];
  List<DivisionModel> get divisions => _divisions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDivisions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _divisions = await _divisionServiceCenter.DivisionInfo();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
