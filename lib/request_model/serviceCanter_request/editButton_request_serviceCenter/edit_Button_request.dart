class EditButtonRequest {
  String? companyId;
  String? id;
  String? name;
  String? hotlineNo;
  String? email;
  List<String>? weeklyOffDays;
  String? workingStartTime;
  String? workingEndTime;
  int? daysOfAdvanceSerial;
  String? serialNoPolicy;
  String? customTextForSerialNo;
  int? dailyQuota;
  int? noOfReservedSerials;

  EditButtonRequest({
    this.id,
    this.companyId,
    this.email,
    this.hotlineNo,
    this.name,
    this.weeklyOffDays,
    this.workingStartTime,
    this.workingEndTime,
    this.daysOfAdvanceSerial,
    this.serialNoPolicy,
    this.customTextForSerialNo,
    this.noOfReservedSerials,
    this.dailyQuota,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hotlineNo': hotlineNo,
      'email': email,
      'weeklyOffDays': weeklyOffDays,
      'workingStartTime': workingStartTime,
      'workingEndTime': workingEndTime,
      'daysOfAdvanceSerial': daysOfAdvanceSerial,
      'serialNoPolicy': serialNoPolicy,
      'customTextForSerialNo': customTextForSerialNo,
      'noOfReservedSerials': noOfReservedSerials,
      'dailyQuota': dailyQuota,
      'companyId': companyId,
    };
  }
}
