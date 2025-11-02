class BookSerialRequest {
  String? businessTypeId;
  String? serviceCenterId;
  String? serviceTypeId;
  String? serviceDate;
  String? serviceTaker;
  String? contactNo;
  String? name;
  String? organizationId;
  bool? forSelf;

  BookSerialRequest({
    this.name,
    this.serviceCenterId,
    this.businessTypeId,
    this.contactNo,
    this.forSelf,
    this.serviceDate,
    this.serviceTypeId,
    this.organizationId,
    this.serviceTaker,
  });

  Map<String, dynamic> toJson() {
    return {
      "businessTypeId": businessTypeId,
      "serviceCenterId": serviceCenterId,
      "serviceTypeId": serviceTypeId,
      "serviceDate": serviceDate,
      "serviceTaker": serviceTaker,
      "contactNo": contactNo,
      "name": name,
      "organizationId": organizationId,
      "forSelf": forSelf,
    };
  }
}
