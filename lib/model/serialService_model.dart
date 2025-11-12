class SerialModel {
  final UserModel? user;
  final ServiceTypeModel? serviceType;
  final String? id;
  final String? date;
  final String? serviceCenterId;
  final String? serviceTypeId;
  final String? userId;
  final bool? forSelf;
  final String? name;
  final String? contactNo;
  final double? charge;
  final int? serialNo;
  final bool? isPresent;
  final String? status;
  final String? statusTime;
  final String? createdTime;
  final String? comment;
  final bool? isAdmin;

  SerialModel({
    this.user,
    this.serviceType,
    this.id,
    this.date,
    this.serviceCenterId,
    this.serviceTypeId,
    this.userId,
    this.forSelf,
    this.name,
    this.contactNo,
    this.serialNo,
    this.isPresent,
    this.status,
    this.statusTime,
    this.createdTime,
    this.charge,
    this.comment,
    this.isAdmin,
  });

  factory SerialModel.fromJson(Map<String, dynamic> json) {
    return SerialModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>?),
      serviceType: ServiceTypeModel.fromJson(
        json['serviceType'] as Map<String, dynamic>?,
      ),
      id: json['id'] as String?,
      date: json['date'] as String?,
      serviceCenterId: json['serviceCenterId'] as String?,
      serviceTypeId: json['serviceTypeId'] as String?,
      userId: json['userId'] as String?,
      forSelf: json['forSelf'] as bool?,
      name: json['name'] as String?,
      contactNo: json['contactNo'] as String?,
      serialNo: json['serialNo'] as int?,
      isPresent: json['isPresent'] as bool?,
      status: json['status'] as String?,
      statusTime: json['statusTime'] as String?,
      createdTime: json['createdTime'] as String?,
      charge: json["charge"],
      comment: json["comment"],
      isAdmin: json["isAdmin"],
    );
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final ProfileData? profileData;

  UserModel({this.id, this.name, this.email, this.profileData});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserModel();
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profileData: json['profileData'] != null
          ? ProfileData.fromJson(json['profileData'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProfileData {
  final String? gender;
  final String? dateOfBirth;

  ProfileData({this.gender, this.dateOfBirth});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
    );
  }
}

class ServiceTypeModel {
  final String? id;
  final String? name;
  final num? price;
  final num? defaultAllocatedTime;

  ServiceTypeModel({this.id, this.name, this.price, this.defaultAllocatedTime});

  factory ServiceTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ServiceTypeModel();
    return ServiceTypeModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      price: json['price'] as num?,
      defaultAllocatedTime: json['defaultAllocatedTime'] as num?,
    );
  }
}
