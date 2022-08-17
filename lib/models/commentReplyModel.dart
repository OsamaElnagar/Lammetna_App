class CommentReplyModel {
  late String name = '';
  late String profileImage = '';
  late String uId = '';
  late String replyText = '';
  late String replyImage = '';
  late String replyDate = '';

  CommentReplyModel({
    required this.name,
    required this.profileImage,
    required this.uId,
    required this.replyText,
    required this.replyImage,
    required this.replyDate,
  });

  CommentReplyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profileImage'];
    uId = json['uId'];
    replyText = json['replyText'];
    replyImage = json['replyImage'];
    replyDate = json['replyDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'uId': uId,
      'replyText': replyText,
      'replyImage': replyImage,
      'replyDate': replyDate,
    };
  }
}
