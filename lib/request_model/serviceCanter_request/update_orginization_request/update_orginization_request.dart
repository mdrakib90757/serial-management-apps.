class UpdateOrginizationRequest {
  String? addressLine1;
  String? addressLine2;
  int? areaId;
  int? businessTypeId;
  int? districtId;
  int? divisionId;
  String? email;
  String? name;
  String? location;
  int? thanaId;
  String? phone;

  UpdateOrginizationRequest({
    this.addressLine1,
    this.addressLine2,
    this.areaId,
    this.businessTypeId,
    this.districtId,
    this.divisionId,
    this.email,
    this.name,
    this.location,
    this.thanaId,
    this.phone,
  });
  Map<String, dynamic> toJson() {
    return {
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "areaId": areaId,
      "businessTypeId": businessTypeId,
      "districtId": districtId,
      "divisionId": divisionId,
      "email": email,
      "name": name,
      "location": location,
      "thanaId": thanaId,
      "phone": phone,
    };
  }
}
