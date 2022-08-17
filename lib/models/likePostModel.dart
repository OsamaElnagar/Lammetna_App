class LikePostModel {
  late String name = '';
  late String uId = '';
  late String likeDate = '';
  late bool like = false;

  LikePostModel({
    required this.name,
    required this.uId,
    required this.likeDate,
    required this.like
  });

  LikePostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    likeDate = json['likeDate'];
    like = json['like'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'likeDate': likeDate,
      'like': like,
    };
  }
}
