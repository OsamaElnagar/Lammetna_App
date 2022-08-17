class CommentModel {
  late String name = '';
  late String profileImage = '';
  late String uId = '';
  late String commentText = '';
  late String? commentImage = '';
  late String commentDate = '';

  CommentModel({
    required this.name,
    required this.profileImage,
    required this.uId,
    required this.commentText,
    required this.commentImage,
    required this.commentDate,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profileImage'];
    uId = json['uId'];
    commentText = json['commentText'];
    commentImage = json['commentImage'];
    commentDate = json['commentDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'uId': uId,
      'commentText': commentText,
      'commentImage': commentImage,
      'commentDate': commentDate,
    };
  }
}
