class StoryModel {
  late String name = '';
  late String storyUid = '';
  late String profileImage = '';
  late String storyDate = '';
  late String storyText = '';
  late String? storyImage = '';
  // late int storyLikes = 0;
  // late int storyComments = 0;
  // late int storyShares = 0;

  StoryModel({
    required this.name,
    required this.storyUid,
    required this.profileImage,
    required this.storyDate,
    required this.storyText,
    required this.storyImage,
    // required this.storyLikes,
    // required this.storyComments,
    // required this.storyShares,
  });

  StoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    storyUid = json['uId'];
    profileImage = json['profileImage'];
    storyDate = json['storyDate'];
    storyText = json['storyText'];
    storyImage = json['storyImage'];
    // storyLikes = json['storyLikes'];
    // storyComments = json['storyComments'];
    // storyShares = json['storyShares'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': storyUid,
      'profileImage': profileImage,
      'storyDate': storyDate,
      'storyText': storyText,
      'storyImage': storyImage,
      // 'storyLikes': storyLikes,
      // 'storyComments': storyComments,
      // 'storyShares': storyShares,
    };
  }
}
