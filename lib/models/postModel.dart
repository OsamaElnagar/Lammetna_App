class PostModel {
  late String name = '';
  late String postUid = '';
  late String profileImage = '';
  late String postDate = '';
  late String postText = '';
  late String? postImage = '';
  late int postLikes = 0;
  late int postComments = 0;
  late int postShares = 0;

  PostModel({
    required this.name,
    required this.postUid,
    required this.profileImage,
    required this.postDate,
    required this.postText,
    required this.postImage,
    required this.postLikes,
    required this.postComments,
    required this.postShares,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    postUid = json['uId'];
    profileImage = json['profileImage'];
    postDate = json['postDate'];
    postText = json['postText'];
    postImage = json['postImage'];
    postLikes = json['postLikes'];
    postComments = json['postComments'];
    postShares = json['postShares'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': postUid,
      'profileImage': profileImage,
      'postDate': postDate,
      'postText': postText,
      'postImage': postImage,
      'postLikes': postLikes,
      'postComments': postComments,
      'postShares': postShares,
    };
  }
}
