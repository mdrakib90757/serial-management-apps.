class UpdateBookSerialRequest {
  String? id;
  String? serviceCenterId;
  String? serviceTypeId;
  bool? forSelf;
  String? name;
  String? contactNo;

  UpdateBookSerialRequest({
    this.id,
    this.serviceCenterId,
    this.serviceTypeId,
    this.forSelf,
    this.name,
    this.contactNo,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "serviceCenterId": serviceCenterId,
      "serviceTypeId": serviceTypeId,
      "forSelf": forSelf,
      "name": name,
      "contactNo": contactNo,
    };
  }
}
