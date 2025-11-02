class StatusButtonRequest {
  bool? isPresent;
  String? status;
  String? comment;
  String? serviceCenterId;
  String? serviceId;
  double? charge;
  StatusButtonRequest({
    this.isPresent,
    this.status,
    this.comment,
    this.serviceCenterId,
    this.serviceId,
    this.charge,
  });

  Map<String, dynamic> toJson() {
    return {
      "isPresent": isPresent,
      "status": status,
      "comment": comment,
      "serviceCenterId": serviceCenterId,
      "serviceId": serviceId,
      "charge": charge,
    };
  }
}
