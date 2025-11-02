import 'dart:convert';

import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/AddUser_serviceCenterModel.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addUser_serviceCenterRequest/addUser_ServiceCenter_request.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addUser_serviceCenterRequest/editUserRequest/editUserRequest.dart';

class AddUserServiceCenter {
  //add api
  Future<dynamic> AddUserButton(
    AddUserRequest userRequest,
    String companyId,
  ) async {
    String body = jsonEncode(userRequest.toJson());
    final response = ApiClient().post(
      "/serial-no/companies/$companyId/service-men",
      body: body,
    );
    return response;
  }

  //get api
  Future<List<AddUserModel>> fetchAddUser(String companyId) async {
    try {
      final response =
          await ApiClient().get("/serial-no/companies/$companyId/service-men")
              as List;
      List<AddUserModel> users = response
          .map(
            (userJson) =>
                AddUserModel.fromJson(userJson as Map<String, dynamic>),
          )
          .toList();
      return users;
    } catch (e) {
      print("Error fetching company users: $e");
      return [];
    }
  }

  ///home screen serviceCenter field use this api
  Future<AddUserModel> fetchSingleUserInfo(
    String companyId,
    String userId,
  ) async {
    try {
      final response = await ApiClient().get(
        "/serial-no/companies/$companyId/service-men/$userId",
      );
      return AddUserModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print("Error fetching single user info: $e");
      throw Exception('Failed to load user details');
    }
  }

  ///setting screen editDialog use this this api
  Future<dynamic> UpdateAddUser(
    EditUserRequest userRequest,
    String companyId,
    String userId,
  ) async {
    try {
      String body = jsonEncode(userRequest.toJson());
      final response = await ApiClient().put(
        "/serial-no/companies/$companyId/service-men/$userId",
        body: body,
      );
      return response;
    } catch (e) {
      print("Error Update AddUser info: $e");
      throw Exception('Failed to load Adduser details');
    }
  }

  ///delete use this setting screen delete user
  Future<void> deleteUser(String companyId, String userId) async {
    try {
      await ApiClient().delete(
        "/serial-no/companies/$companyId/service-men/$userId",
      );
    } catch (e) {
      print("Error in deleteUser API: $e");
      rethrow;
    }
  }
}
