import 'mybooked_model.dart';

class MyService {
  final String id;
  final DateTime? date;
  final String? serviceCenterId;
  final String? serviceTypeId;
  final String? userId;
  final String name;
  final String? contactNo;
  final int serialNo;
  final String status;
  final DateTime? statusTime;
  final DateTime? createdTime;
  final String? approxServeTime;
  final bool? isAdmin;
  final Company? company;
  final ServiceCenter? serviceCenter;
  final ServiceType? serviceType;

  MyService({
    required this.id,
    this.date,
    this.serviceCenterId,
    this.serviceTypeId,
    this.userId,
    required this.name,
    this.contactNo,
    required this.serialNo,
    required this.status,
    this.createdTime,
    this.approxServeTime,
    this.company,
    this.serviceCenter,
    this.serviceType,
    this.statusTime,
    this.isAdmin,
  });

  factory MyService.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is String) return DateTime.tryParse(dateValue);
      return null;
    }

    return MyService(
      id: json['id'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      serviceCenterId: json['serviceCenterId'],
      serviceTypeId: json['serviceTypeId'],
      userId: json['userId'],
      name: json['name'] ?? 'No Name',
      contactNo: json['contactNo'],
      serialNo: json['serialNo'] ?? 0,
      status: json['status'] ?? 'Unknown',
      createdTime: _parseDate(json['createdTime']),
      statusTime: _parseDate(json['statusTime']),

      // createdTime: json['createdTime'] != null
      //     ? DateTime.tryParse(json['createdTime'])
      //     : null,
      // statusTime: json['statusTime'] != null
      //     ? DateTime.tryParse(json['createdTime'])
      //     : null,
      approxServeTime: json['approxServeTime'],
      isAdmin: json['isAdmin'],
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      serviceCenter: json['serviceCenter'] != null
          ? ServiceCenter.fromJson(json['serviceCenter'])
          : null,
      serviceType: json['serviceType'] != null
          ? ServiceType.fromJson(json['serviceType'])
          : null,
    );
  }
}
