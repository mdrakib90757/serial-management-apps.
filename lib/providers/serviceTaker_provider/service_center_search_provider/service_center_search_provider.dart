// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import '../../../../api/serviceTaker_api/search_api_service_taker/search_api_service_taker.dart';
// import '../../../../model/serviceCenter_model.dart';
//
// class ServiceCenterSearchProvider with ChangeNotifier {
//   final SearchApi _api = SearchApi();
//
//   bool _isLoading = false;
//   List<ServiceCenterModel> _results = [];
//   String? _errorMessage;
//   Timer? _debounce;
//   String _currentQuery = '';
//
//   bool get isLoading => _isLoading;
//   List<ServiceCenterModel> get results => _results;
//   String? get errorMessage => _errorMessage;
//
//   void search(String query) {
//     // Debugging print statement
//     print('1. Search method called with query: "$query"');
//
//     if (_debounce?.isActive ?? false) {
//       _debounce!.cancel();
//     }
//
//     _currentQuery = query;
//
//     if (query.trim().isEmpty) {
//       _results = [];
//       _isLoading = false;
//       notifyListeners();
//       return;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//
//     _debounce = Timer(const Duration(milliseconds: 500), () async {
//       // Debugging print statement
//       print('2. Debounce timer fired for query: "$query"');
//
//       if (_currentQuery != query) {
//         print('   -> Stale query. API call skipped.');
//         return;
//       }
//
//       try {
//         final newResults = await _api.searchServiceCenters(query);
//
//         // Debugging print statement
//         print('3. API call successful. Result count: ${newResults.length}');
//         // Optional: print the full result to see the data
//         // print('   -> Result data: $newResults');
//
//
//         if (_currentQuery == query) {
//           _results = newResults;
//           _errorMessage = null;
//         }
//       } catch (e) {
//         // Debugging print statement
//         print('4. API call failed. Error: $e');
//
//         if (_currentQuery == query) {
//           _errorMessage = "Error: Failed to fetch data.";
//           _results = [];
//         }
//       } finally {
//         if (_currentQuery == query) {
//           _isLoading = false;
//           notifyListeners();
//           // Debugging print statement
//           print('5. State updated and listeners notified for query: "$query"');
//         }
//       }
//     });
//   }
//
//   void clearResults() {
//     _results = [];
//     _errorMessage = null;
//     _currentQuery = '';
//     if (_debounce?.isActive ?? false) {
//       _debounce!.cancel();
//     }
//     notifyListeners();
//   }
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../api/serviceTaker_api/search_api_service_taker/search_api_service_taker.dart';
import '../../../../model/serviceCenter_model.dart';

class ServiceCenterSearchProvider with ChangeNotifier {
  final SearchApi _api = SearchApi();

  bool _isLoading = false;
  List<ServiceCenterModel> _results = [];
  String? _errorMessage;
  Timer? _debounce;

  int _searchId = 0;

  bool get isLoading => _isLoading;
  List<ServiceCenterModel> get results => _results;
  String? get errorMessage => _errorMessage;

  void search(String query) {
    final int localSearchId = ++_searchId;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    if (query.trim().isEmpty) {
      _results = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (localSearchId != _searchId) {
        return;
      }

      try {
        final newResults = await _api.searchServiceCenters(query);

        if (localSearchId == _searchId) {
          _results = newResults;
          _errorMessage = null;
          _isLoading = false;
        }
      } catch (e) {
        if (localSearchId == _searchId) {
          _errorMessage = "Error: Failed to fetch data.";
          _results = [];
          _isLoading = false;
          if (kDebugMode) {
            print("Search API Error for query '$query': $e");
          }
        }
      } finally {
        if (localSearchId == _searchId) {
          notifyListeners();
        }
      }
    });
  }

  void clearResults() {
    _results = [];
    _errorMessage = null;
    _isLoading = false;
    _searchId++;
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    notifyListeners();
  }
}
