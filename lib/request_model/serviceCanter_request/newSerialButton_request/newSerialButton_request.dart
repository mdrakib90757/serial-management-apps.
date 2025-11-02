class NewSerialButtonRequest {
  final String serviceCenterId;
  final String serviceTypeId;
  final String serviceDate;
  final String name;
  final String contactNo;
  final bool forSelf;
  final bool isAdmin;

  NewSerialButtonRequest({
    required this.serviceCenterId,
    required this.serviceTypeId,
    required this.serviceDate,
    required this.name,
    required this.contactNo,
    required this.forSelf,
    required this.isAdmin,
  });

  Map<String, dynamic> toJson() {
    return {
      "serviceCenterName": serviceCenterId,
      "serviceTypeId": serviceTypeId,
      "serviceDate": serviceDate,
      "name": name,
      "contactNo": contactNo,
      "forSelf": forSelf,
      "isAdmin": isAdmin,
    };
  }
}
