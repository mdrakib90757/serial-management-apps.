class AddUserModel {
  final String? companyId;
  final String? userId;
  final String? roleId;
  final List<String> serviceCenterIds;
  final bool? isActive;
  final String id;
  final String name;
  final String? email;
  final String? mobileNo;
  final String loginName;
  final DateTime? registeredDate;
  final String? userType;
  final ProfileDataModel? profileData;

  AddUserModel({
    this.companyId,
    this.userId,
    this.roleId,
    required this.serviceCenterIds,
    this.isActive,
    required this.id,
    required this.name,
    this.email,
    this.mobileNo,
    required this.loginName,
    this.registeredDate,
    this.userType,
    this.profileData,
  });

  factory AddUserModel.fromJson(Map<String, dynamic> json) {
    return AddUserModel(
      companyId: json['companyId'],
      userId: json['userId'],
      roleId: json['roleId'],
      serviceCenterIds: json['serviceCenterIds'] != null
          ? List<String>.from(json['serviceCenterIds'])
          : [],
      isActive: json['isActive'],
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      email: json['email'],
      mobileNo: json['mobileNo'],
      loginName: json['loginName'] ?? '',
      registeredDate: json['registeredDate'] != null
          ? DateTime.tryParse(json['registeredDate'])
          : null,
      userType: json['userType'],
      profileData: json['profileData'] != null
          ? ProfileDataModel.fromJson(json['profileData'])
          : null,
    );
  }
}

class ProfileDataModel {
  final String? gender;
  final DateTime? dateOfBirth;
  final String? photograph;

  ProfileDataModel({this.gender, this.dateOfBirth, this.photograph});

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      photograph: json['photograph'],
    );
  }
}
