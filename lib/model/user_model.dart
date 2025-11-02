enum UserType { ServiceCenter, ServiceTaker }

//Register-service-center
class User_Model {
  final Businesstype? businessType;
  final String? businessTypeName;
  final int? businessTypeId;

  final String? token;
  final Company? company;
  final User user;
  final ServiceCenter? serviceCenter;
  final ServiceTaker? serviceTaker;

  User_Model({
    this.serviceTaker,
    this.businessTypeName,
    this.businessTypeId,
    this.businessType,
    this.token,
    this.company,
    required this.user,
    this.serviceCenter,
    String? accessToken,
    String? refreshToken,
  });

  factory User_Model.fromJson(Map<String, dynamic> json) {
    return User_Model(
      businessTypeId: json["businessTypeId"],
      businessTypeName: json["businessTypeName"],
      businessType: json["businessType"] != null
          ? Businesstype.fromJson(json["businessType"])
          : null,

      //company: Company.fromJson(json["company"]),
      company: json["currentCompany"] != null
          ? Company.fromJson(json["currentCompany"])
          : null,
      //  user: User.fromJSon(json["user"]),
      user: User.fromJSon(json),

      // serviceCenter: ServiceCenter.fromJSon(json["serviceCenter"]),
      serviceCenter: json["serviceCenter"] != null
          ? ServiceCenter.fromJSon(json["serviceCenter"])
          : null,

      token: json["token"] ?? "",

      serviceTaker: json["serviceTaker"] != null
          ? ServiceTaker.fromJson(json["serviceTaker"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'token': token, 'user': user};
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (serviceCenter != null) {
      data['serviceCenter'] = serviceCenter!.toJson();
    }
    return data;
  }

  User_Model copyWith({
    Businesstype? businessType,
    String? businessTypeName,
    int? businessTypeId,
    String? token,
    Company? company,
    User? user,
    ServiceCenter? serviceCenter,
    ServiceTaker? serviceTaker,
  }) {
    return User_Model(
      businessType: businessType ?? this.businessType,
      businessTypeName: businessTypeName ?? this.businessTypeName,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      token: token ?? this.token,
      company: company ?? this.company,
      user: user ?? this.user,
      serviceCenter: serviceCenter ?? this.serviceCenter,
      serviceTaker: serviceTaker ?? this.serviceTaker,
    );
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
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      addressLine1: json["addressLine1"] ?? "",
      addressLine2: json["addressLine2"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      createDate: json["createDate"] ?? "",
      isActive: json["isActive"] ?? false,
      businessTypeId: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'email': email,
      'phone': phone,
      'createDate': createDate,
      'isActive': isActive,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String mobileNo;
  final String loginName;
  final String registeredDate;
  final bool isActive;
  final String userType;
  final ProfileData? profileData;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.loginName,
    required this.registeredDate,
    required this.isActive,
    required this.userType,
    this.profileData,
  });

  factory User.fromJSon(Map<String, dynamic> json) {
    final rawProfile = json["profileData"];
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobileNo: json["mobileNo"],
      loginName: json["loginName"],
      registeredDate: json["registeredDate"],
      isActive: json["isActive"],
      userType: json['userType'],
      profileData: rawProfile is Map<String, dynamic>
          ? ProfileData.fromJson(rawProfile)
          : null,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNo,
    String? loginName,
    ProfileData? profileData,
    String? registeredDate,
    bool? isActive,
    String? userType,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNo: mobileNo ?? this.mobileNo,
      loginName: loginName ?? this.loginName,
      registeredDate: registeredDate ?? this.registeredDate,
      isActive: isActive ?? this.isActive,
      userType: userType ?? this.userType,
      profileData: profileData ?? this.profileData,
    );
  }
}

class ServiceCenter {
  final String id;
  final String name;
  final String hotlineNo;
  final String email;
  final String companyId;
  ServiceCenter({
    required this.id,
    required this.name,
    required this.email,
    required this.hotlineNo,
    required this.companyId,
  });
  factory ServiceCenter.fromJSon(Map<String, dynamic> json) {
    return ServiceCenter(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      hotlineNo: json["hotlineNo"] ?? "",
      companyId: json["companyId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'hotlineNo': hotlineNo,
      'companyId': companyId,
    };
  }
}

class ServiceTaker {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String loginName;
  final String password;
  final String? registeredDate;
  final bool? isActive;
  final String? userType;
  final ProfileData? profileData;

  ServiceTaker({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.loginName,
    required this.password,
    this.registeredDate,
    this.isActive,
    this.userType,
    this.profileData,
  });
  factory ServiceTaker.fromJson(Map<String, dynamic> json) {
    final profileDataJson = json['profileData'];
    return ServiceTaker(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      loginName: json["loginName"],
      password: json["password"],
      registeredDate: json["registeredDate"],
      isActive: json["isActive"],
      userType: json["userType"],
      profileData: profileDataJson != null
          ? ProfileData.fromJson(json['profileData'])
          : null,
    );
  }
}

class ProfileData {
  final String? gender;
  final String? dateOfBirth;
  final String? photograph;

  ProfileData({
    this.gender,
    required this.dateOfBirth,
    required this.photograph,
  });

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

class Businesstype {
  final int id;
  final String name;
  final dynamic config;

  Businesstype({required this.id, required this.name, this.config});

  factory Businesstype.fromJson(Map<String, dynamic> json) {
    try {
      return Businesstype(
        id: int.tryParse(json["id"]?.toString() ?? '0') ?? 0,
        name: json["name"]?.toString() ?? '',
        config: json["config"],
      );
    } catch (e) {
      throw FormatException('Failed to parse BusinessType: $e');
    }
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'config': config};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Businesstype &&
          runtimeType == other.runtimeType &&
          id == other.id;
}
