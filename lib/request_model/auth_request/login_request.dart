class LoginRequest {
  String? loginName;
  String? password;

  LoginRequest({this.loginName, this.password});

  Map<String, dynamic> toJson() {
    return {'loginName': loginName, 'password': password};
  }
}
