class LoginModel {
  String name='';
  String phone='';
  String email='';
  String bio='';
  String profileImage='';
  String profileCover='';
  String uId= '';

  LoginModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.profileCover,
    required this.uId,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    bio = json['bio'];
    profileImage = json['profileImage'];
    profileCover = json['profileCover'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'profileCover': profileCover,
      'uId': uId,
    };
  }
}
