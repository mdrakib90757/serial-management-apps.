class update_service_center_service_type_request {
  String? serviceTypeId;
  int? price;
  int? defaultAllocatedTime;

  update_service_center_service_type_request({
    this.serviceTypeId,
    this.price,
    this.defaultAllocatedTime,
  });

  factory update_service_center_service_type_request.fromJson(
    Map<String, dynamic> json,
  ) {
    return update_service_center_service_type_request(
      serviceTypeId: json['serviceTypeId'],
      price: json['price'],
      defaultAllocatedTime: json['defaultAllocatedTime'],

      // Parse other fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceTypeId': serviceTypeId,
      'price': price,
      'defaultAllocatedTime': defaultAllocatedTime,

      // Add other fields
    };
  }
}
