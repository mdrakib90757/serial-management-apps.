class EditButtonServiceTypeRequest {
  String? companyId;
  String? id;
  String? name;
  String? price;
  String? defaultAllocatedTime;
  EditButtonServiceTypeRequest({
    this.id,
    this.companyId,
    this.name,
    this.price,
    this.defaultAllocatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "defaultAllocatedTime": defaultAllocatedTime,
      "companyId": companyId,
    };
  }
}
