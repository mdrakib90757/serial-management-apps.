class OrganizationModel {
  final String? id;
  final String? name;
  final String? address;
  final String? contactNo;
  final String? logoUrl;

  OrganizationModel({
    required this.id,
    required this.name,
    this.address,
    this.contactNo,
    this.logoUrl,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      contactNo: json['contactNo'],
      logoUrl: json['logoUrl'],
    );
  }
}
