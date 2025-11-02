class CompanyDetailsModel {
  BusinessType? businessType;
  LocationPart? division;
  LocationPart? district;
  LocationPart? thana;
  LocationPart? area;
  String? id;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? email;
  String? phone;
  String? createDate;
  bool? isActive;
  int? businessTypeId;
  dynamic location;
  int? divisionId;
  int? districtId;
  int? thanaId;
  int? areaId;
  dynamic logo;

  CompanyDetailsModel({
    this.businessType,
    this.division,
    this.district,
    this.thana,
    this.area,
    this.id,
    this.name,
    this.addressLine1,
    this.addressLine2,
    this.email,
    this.phone,
    this.createDate,
    this.isActive,
    this.businessTypeId,
    this.location,
    this.divisionId,
    this.districtId,
    this.thanaId,
    this.areaId,
    this.logo,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsModel(
      businessType: json['businessType'] != null
          ? BusinessType.fromJson(json['businessType'])
          : null,
      division: json['division'] != null
          ? LocationPart.fromJson(json['division'])
          : null,
      district: json['district'] != null
          ? LocationPart.fromJson(json['district'])
          : null,
      thana: json['thana'] != null
          ? LocationPart.fromJson(json['thana'])
          : null,
      area: json['area'] != null ? LocationPart.fromJson(json['area']) : null,
      id: json['id'],
      name: json['name'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      email: json['email'],
      phone: json['phone'],
      createDate: json['createDate'],
      isActive: json['isActive'],
      businessTypeId: json['businessTypeId'],
      location: json['location'],
      divisionId: json['divisionId'],
      districtId: json['districtId'],
      thanaId: json['thanaId'],
      areaId: json['areaId'],
      logo: json['logo'],
    );
  }
}

class BusinessType {
  int? id;
  String? name;
  dynamic config;

  BusinessType({this.id, this.name, this.config});

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      id: json['id'],
      name: json['name'],
      config: json['config'],
    );
  }
}

class LocationPart {
  int? id;
  String? name;
  String? type;
  int? parentId;
  LocationPart? parent;

  LocationPart({this.id, this.name, this.type, this.parentId, this.parent});

  factory LocationPart.fromJson(Map<String, dynamic> json) {
    return LocationPart(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      parentId: json['parentId'],
      parent: json['parent'] != null
          ? LocationPart.fromJson(json['parent'])
          : null,
    );
  }
}
