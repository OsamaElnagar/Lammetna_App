class ChatsModel {
  late String chatPersonName = '';
  late String senderId = '';
  late String receiverId = '';
  late String textMessage = '';
  late String imageMessage = '';
  late String messageDateTime = '';

  ChatsModel({
    required this.chatPersonName,
    required this.senderId,
    required this.receiverId,
    required this.textMessage,
    required this.imageMessage,
    required this.messageDateTime,
  });

  ChatsModel.fromJson(Map<String, dynamic> json) {
    chatPersonName = json['chatPersonName'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    textMessage = json['textMessage'];
    imageMessage = json['imageMessage'];
    messageDateTime = json['messageDateTime'];
  }

  Map<String ,dynamic> toMap(){
    return {
      'chatPersonName':chatPersonName,
      'senderId':senderId,
      'receiverId':receiverId,
      'textMessage':textMessage,
      'imageMessage':imageMessage,
      'messageDateTime':messageDateTime,
    };
  }

}
