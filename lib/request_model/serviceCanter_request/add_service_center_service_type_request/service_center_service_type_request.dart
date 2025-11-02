class add_service_center_service_type_request {
  String? id;
  String? serviceCenterId;
  int? price;
  int? defaultAllocatedTime;
  String? name;
  String? companyId;

  add_service_center_service_type_request({
    this.name,
    this.id,
    this.companyId,
    this.serviceCenterId,
    this.price,
    this.defaultAllocatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "serviceTypeId": id,
      "price": price,
      "defaultAllocatedTime": defaultAllocatedTime,
    };
  }
}
