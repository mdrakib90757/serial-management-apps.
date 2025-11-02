class NextButtonRequest {
  String? date;

  NextButtonRequest({this.date});

  Map<String, dynamic> toJson() {
    return {"date": date};
  }
}
