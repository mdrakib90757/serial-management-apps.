class MybookedModel {
  Null? user;
  Company? company;
  ServiceCenter? serviceCenter;
  ServiceType? serviceType;
  String? id;
  String? date;
  String? serviceCenterId;
  String? serviceTypeId;
  String? userId;
  bool? forSelf;
  String? name;
  String? contactNo;
  int? serialNo;
  bool? isPresent;
  String? status;
  String? statusTime;
  String? comment;
  String? createdTime;
  bool? isReserved;
  String? approxServeTime;

  MybookedModel({
    this.user,
    this.company,
    this.serviceCenter,
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
    this.comment,
    this.createdTime,
    this.isReserved,
    this.approxServeTime,
  });

  MybookedModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    company = json['company'] != null
        ? new Company.fromJson(json['company'])
        : null;
    serviceCenter = json['serviceCenter'] != null
        ? new ServiceCenter.fromJson(json['serviceCenter'])
        : null;
    serviceType = json['serviceType'] != null
        ? new ServiceType.fromJson(json['serviceType'])
        : null;
    id = json['id'];
    date = json['date'];
    serviceCenterId = json['serviceCenterId'];
    serviceTypeId = json['serviceTypeId'];
    userId = json['userId'];
    forSelf = json['forSelf'];
    name = json['name'];
    contactNo = json['contactNo'];
    serialNo = json['serialNo'];
    isPresent = json['isPresent'];
    status = json['status'];
    statusTime = json['statusTime'];
    comment = json['comment'];
    createdTime = json['createdTime'];
    isReserved = json['isReserved'];
    approxServeTime = json['approxServeTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.serviceCenter != null) {
      data['serviceCenter'] = this.serviceCenter!.toJson();
    }
    if (this.serviceType != null) {
      data['serviceType'] = this.serviceType!.toJson();
    }
    data['id'] = this.id;
    data['date'] = this.date;
    data['serviceCenterId'] = this.serviceCenterId;
    data['serviceTypeId'] = this.serviceTypeId;
    data['userId'] = this.userId;
    data['forSelf'] = this.forSelf;
    data['name'] = this.name;
    data['contactNo'] = this.contactNo;
    data['serialNo'] = this.serialNo;
    data['isPresent'] = this.isPresent;
    data['status'] = this.status;
    data['statusTime'] = this.statusTime;
    data['comment'] = this.comment;
    data['createdTime'] = this.createdTime;
    return data;
  }
}

class Company {
  String? id;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? email;
  String? phone;
  String? createDate;
  bool? isActive;
  int? businessTypeId;

  Company({
    this.id,
    this.name,
    this.addressLine1,
    this.addressLine2,
    this.email,
    this.phone,
    this.createDate,
    this.isActive,
    this.businessTypeId,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    email = json['email'];
    phone = json['phone'];
    createDate = json['createDate'];
    isActive = json['isActive'];
    businessTypeId = json['businessTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['createDate'] = this.createDate;
    data['isActive'] = this.isActive;
    data['businessTypeId'] = this.businessTypeId;
    return data;
  }
}

class ServiceCenter {
  String? id;
  String? name;
  String? hotlineNo;
  String? email;
  String? companyId;

  ServiceCenter({
    this.id,
    this.name,
    this.hotlineNo,
    this.email,
    this.companyId,
  });

  ServiceCenter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hotlineNo = json['hotlineNo'];
    email = json['email'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hotlineNo'] = this.hotlineNo;
    data['email'] = this.email;
    data['companyId'] = this.companyId;
    return data;
  }
}

class ServiceType {
  String? id;
  String? name;
  num? price;
  int? defaultAllocatedTime;
  String? companyId;
  String? serviceCenterId;

  ServiceType({
    this.id,
    this.name,
    this.price,
    this.defaultAllocatedTime,
    this.companyId,
    this.serviceCenterId,
  });

  ServiceType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    defaultAllocatedTime = json['defaultAllocatedTime'];
    companyId = json['companyId'];
    serviceCenterId = json['serviceCenterId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['defaultAllocatedTime'] = this.defaultAllocatedTime;
    data['companyId'] = this.companyId;
    data['serviceCenterId'] = this.serviceCenterId;
    return data;
  }
}
