import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/location_api_service_center/location_api_service_center.dart';
import 'package:SerialMan/model/company_details_model.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  bool IsLoading = false;

  List<LocationPart> divisions = [];
  List<LocationPart> districts = [];
  List<LocationPart> thanas = [];
  List<LocationPart> areas = [];

  //bool isLoading = false;

  bool _isLoadingDivisions = false;
  bool get isLoadingDivisions => _isLoadingDivisions;

  bool _isLoadingDistricts = false;
  bool get isLoadingDistricts => _isLoadingDistricts;

  bool _isLoadingThanas = false;
  bool get isLoadingThanas => _isLoadingThanas;

  bool _isLoadingAreas = false;
  bool get isLoadingAreas => _isLoadingAreas;

  Future<void> getDivisions() async {
    _isLoadingDivisions = true;
    notifyListeners();
    try {
      divisions = await _locationService.fetchDivisions();
    } catch (e) {
      print("Error in getDivisions Provider: $e");
    } finally {
      _isLoadingDivisions = false;
      notifyListeners();
    }
  }

  Future<void> getDistricts(int divisionId) async {
    _isLoadingDistricts = true;
    districts = [];
    notifyListeners();
    try {
      districts = await _locationService.fetchDistricts(divisionId);
    } catch (e) {
      print("Error in getDistricts Provider: $e");
    } finally {
      _isLoadingDistricts = false;
      notifyListeners();
    }
  }

  Future<void> getThanas(int districtId) async {
    _isLoadingThanas = true;
    thanas = [];
    notifyListeners();
    try {
      thanas = await _locationService.fetchThanas(districtId);
    } catch (e) {
      print("Error in getThanas Provider: $e");
    } finally {
      _isLoadingThanas = false;
      notifyListeners();
    }
  }

  Future<void> getAreas(int thanaId) async {
    _isLoadingAreas = true;
    areas = [];
    notifyListeners();
    try {
      areas = await _locationService.fetchAreas(thanaId);
    } catch (e) {
      print("Error in getAreas Provider: $e");
    } finally {
      _isLoadingAreas = false;
      notifyListeners();
    }
  }

  void clearDistricts() {
    districts = [];
    notifyListeners();
  }

  void clearThanas() {
    thanas = [];
    notifyListeners();
  }

  void clearAreas() {
    areas = [];
    notifyListeners();
  }
}
