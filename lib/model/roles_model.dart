class RolesModel {
  bool? error;
  Null? errorMessage;
  List<Data>? data;

  RolesModel({this.error, this.errorMessage, this.data});

  RolesModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['errorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? companyId;

  Data({this.id, this.name, this.companyId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['companyId'] = this.companyId;
    return data;
  }
}
