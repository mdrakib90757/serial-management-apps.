class UpdateProfileRequest {
  String? name;
  String? loginName;
  String? mobileNo;
  String? email;
  String? gender;
  String? dateOfBirth;

  UpdateProfileRequest({
    this.name,
    this.mobileNo,
    this.email,
    this.gender,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobileNo': mobileNo,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
  }
}
