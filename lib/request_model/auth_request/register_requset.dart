class RegisterRequest {
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? contactName;
  String? email;
  String? phone;
  String? organizationName;
  int? businessTypeId;
  String? loginName;
  String? password;

  RegisterRequest({
    this.name,
    this.addressLine1,
    this.addressLine2,
    this.contactName,
    this.email,
    this.phone,
    this.password,
    this.loginName,
    this.businessTypeId,
    this.organizationName,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "contactName": contactName,
      "email": email,
      "phone": phone,
      "organizationName": organizationName,
      "businessTypeId": businessTypeId,
      "loginName": loginName,
      "password": password,
    };
  }
}
