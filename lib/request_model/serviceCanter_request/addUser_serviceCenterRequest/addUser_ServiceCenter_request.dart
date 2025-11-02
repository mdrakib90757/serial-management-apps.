class AddUserRequest {
  String? name;
  String? loginName;
  String? email;
  String? mobileNo;
  String? password;
  String? confirmPassword;
  String? roleId;
  List<String>? serviceCenterIds;
  bool? isActive;

  AddUserRequest({
    this.name,
    this.loginName,
    this.email,
    this.mobileNo,
    this.password,
    this.confirmPassword,
    this.roleId,
    this.isActive,
    this.serviceCenterIds,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "loginName": loginName,
      "email": email,
      "mobileNo": mobileNo,
      "password": password,
      "confirmPassword": confirmPassword,
      "roleId": roleId,
      "serviceCenterIds": serviceCenterIds,
      "isActive": isActive,
    };
  }
}
