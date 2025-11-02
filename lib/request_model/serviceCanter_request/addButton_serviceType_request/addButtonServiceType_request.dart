class AddButtonServiceTypeRequest {
  String? id;
  String? name;
  String? price;
  String? defaultAllocatedTime;
  String? serviceCenterId;
  String? companyId;

  AddButtonServiceTypeRequest({
    this.name,
    this.price,
    this.serviceCenterId,
    this.defaultAllocatedTime,
    this.companyId,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "defaultAllocatedTime": defaultAllocatedTime,
      "companyId": companyId,
      "serviceCenterId": serviceCenterId,
    };
  }
}
