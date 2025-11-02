class UpdatePasswordRequest {
  String? currentPassword;
  String? newPassword;

  UpdatePasswordRequest({this.currentPassword, this.newPassword});
  Map<String, dynamic> toJson() {
    return {"currentPassword": currentPassword, "newPassword": newPassword};
  }
}
