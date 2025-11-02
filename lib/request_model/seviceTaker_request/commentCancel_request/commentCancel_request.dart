class CommentCancelRequest {
  String? id;
  String? serviceCenterId;
  String? serviceTypeId;
  String? comment;
  String? status;

  CommentCancelRequest({
    this.serviceTypeId,
    this.serviceCenterId,
    this.id,
    this.status,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "serviceCenterId": serviceCenterId,
      "serviceTypeId": serviceTypeId,
      "comment": comment,
      "status": status,
    };
  }
}
