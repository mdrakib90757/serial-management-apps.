import 'package:flutter/cupertino.dart';
import 'package:SerialMan/api/serviceCenter_api/company_details_api/company_details_api.dart';
import 'package:SerialMan/model/company_details_model.dart';

class CompanyDetailsProvider with ChangeNotifier {
  final CompanyDetailsApi _companyDetailsApi = CompanyDetailsApi();

  CompanyDetailsModel? _companyDetails;
  bool _isLoading = false;
  String? _errorMessage;

  CompanyDetailsModel? get companyDetails => _companyDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDetails(String companyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companyDetails = await _companyDetailsApi.companyInfo(companyId);
      debugPrint("CompanyId loaded for: ${_companyDetails?.id}");
      debugPrint("Company details loaded for: ${_companyDetails?.name}");
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Failed to load company details: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
