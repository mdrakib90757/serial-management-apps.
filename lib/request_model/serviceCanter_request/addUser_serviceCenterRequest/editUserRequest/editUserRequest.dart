class EditUserRequest {
  String? name;
  String? loginName;
  String? email;
  String? mobileNo;
  String? roleId;
  List<String>? serviceCenterIds;
  bool? isActive;

  EditUserRequest({
    this.name,
    this.loginName,
    this.email,
    this.mobileNo,
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
      "roleId": roleId,
      "serviceCenterIds": serviceCenterIds,
      "isActive": isActive,
    };
  }
}
