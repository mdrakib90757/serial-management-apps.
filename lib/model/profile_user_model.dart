//get method ProfileUserModel
class profile_UserModel {
  final List<UserCompany> userCompanies;
  final Company currentCompany;
  final String id;
  final String name;
  final String email;
  final String mobileNo;
  final String loginName;
  final String registeredDate;
  final bool isActive;
  final String userType;
  final ProfileData? profileData;
  final String? roleId;
  final List<String>? serviceCenterIds;

  profile_UserModel({
    required this.userCompanies,
    required this.currentCompany,
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.loginName,
    required this.registeredDate,
    required this.isActive,
    required this.userType,
    this.profileData,
    this.roleId,
    this.serviceCenterIds,
  });

  factory profile_UserModel.fromJson(Map<String, dynamic> json) {
    return profile_UserModel(
      userCompanies: json["userCompanies"] != null
          ? (json["userCompanies"] as List)
                .map((e) => UserCompany.fromJson(e))
                .toList()
          : [],
      currentCompany: json["currentCompany"] != null
          ? Company.fromJson(json["currentCompany"])
          : Company(
              id: '',
              name: '',
              addressLine1: '',
              addressLine2: '',
              email: '',
              phone: '',
              createDate: '',
              isActive: false,
              businessTypeId: 0,
            ),
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobileNo: json["mobileNo"],
      loginName: json["loginName"],
      registeredDate: json["registeredDate"],
      isActive: json["isActive"],
      userType: json["userType"],
      profileData: json["profileData"] != null
          ? ProfileData.fromJson(json["profileData"])
          : null,
      roleId: json['roleId'],
      serviceCenterIds: json['serviceCenterIds'] != null
          ? List<String>.from(json['serviceCenterIds'])
          : [],
    );
  }
}

class UserCompany {
  final String companyId;
  final String roleId;
  final List<String>? serviceCenterIds;

  UserCompany({
    required this.companyId,
    required this.roleId,
    this.serviceCenterIds,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) {
    return UserCompany(companyId: json["companyId"], roleId: json["roleId"]);
  }
}

class Company {
  final String id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String email;
  final String phone;
  final String createDate;
  final bool isActive;
  final int businessTypeId;

  Company({
    required this.id,
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.email,
    required this.phone,
    required this.createDate,
    required this.isActive,
    required this.businessTypeId,
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["id"],
      name: json["name"],
      addressLine1: json["addressLine1"],
      addressLine2: json["addressLine2"],
      email: json["email"],
      phone: json["phone"],
      createDate: json["createDate"],
      isActive: json["isActive"],
      businessTypeId: json["businessTypeId"],
    );
  }
}

class ProfileData {
  final String? gender;
  final String? dateOfBirth;
  final String? photograph;

  ProfileData({this.gender, this.dateOfBirth, this.photograph});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"],
      photograph: json["photograph"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "photograph": photograph,
    };
  }
}
