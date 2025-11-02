class ServiceCenterModel {
  final String id;
  final String? name;
  final String? hotlineNo;
  final String? email;
  final String? companyId;
  List<String>? weeklyOffDays;
  DateTime? workingStartTime;
  DateTime? workingEndTime;
  int? daysOfAdvanceSerial;
  int? noOfReservedSerials;
  String? serialNoPolicy;
  int? dailyQuota;

  ServiceCenterModel({
    required this.id,
    this.name,
    this.hotlineNo,
    this.email,
    this.companyId,
    this.workingStartTime,
    this.workingEndTime,
    this.daysOfAdvanceSerial,
    this.noOfReservedSerials,
    this.serialNoPolicy,
    this.weeklyOffDays,
    this.dailyQuota,
  });

  factory ServiceCenterModel.fromJson(Map<String, dynamic> json) {
    return ServiceCenterModel(
      id: json["id"],
      name: json["name"],
      hotlineNo: json["hotlineNo"],
      email: json["email"],
      companyId: json["companyId"],
      weeklyOffDays: json["weeklyOffDays"] == null
          ? []
          : List<String>.from(json["weeklyOffDays"].map((x) => x)),
      workingStartTime: json["workingStartTime"] == null
          ? null
          : DateTime.parse(json["workingStartTime"]),
      workingEndTime: json["workingEndTime"] == null
          ? null
          : DateTime.parse(json["workingEndTime"]),
      daysOfAdvanceSerial: json["daysOfAdvanceSerial"],
      noOfReservedSerials: json["noOfReservedSerials"],
      serialNoPolicy: json["serialNoPolicy"],
      dailyQuota: json["dailyQuota"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "hotlineNo": hotlineNo,
      "email": email,
      "companyId": companyId,
      "weeklyOffDays": weeklyOffDays ?? [],
      "workingStartTime": workingStartTime?.toIso8601String(),
      "workingEndTime": workingEndTime?.toIso8601String(),
      "daysOfAdvanceSerial": daysOfAdvanceSerial,
      "noOfReservedSerials": noOfReservedSerials,
      "serialNoPolicy": serialNoPolicy,
      "dailyQuota": dailyQuota,
    };
  }
}
