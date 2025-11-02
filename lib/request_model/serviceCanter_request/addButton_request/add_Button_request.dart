class AddButtonRequest {
  String? id;
  String? name;
  String? hotlineNo;
  String? email;
  String? companyId;
  List<String>? weeklyOffDays;
  DateTime? workingStartTime;
  DateTime? workingEndTime;
  String? daysOfAdvanceSerial;
  String? noOfReservedSerials;
  String? serialNoPolicy;
  String? dailyQuota;

  AddButtonRequest({
    this.id,
    this.name,
    this.hotlineNo,
    this.email,
    this.companyId,
    this.weeklyOffDays,
    this.workingStartTime,
    this.workingEndTime,
    this.daysOfAdvanceSerial,
    this.noOfReservedSerials,
    this.serialNoPolicy,
    this.dailyQuota,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "hotlineNo": hotlineNo,
      "email": email,
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
