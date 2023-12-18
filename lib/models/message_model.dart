class MessageModel {
  late final String toId, msg, read, type, fromId, sent;

  MessageModel({
    // required this.image,
    required this.toId,
    // required this.name,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    // required this.email,
    required this.sent,
  });

  MessageModel.fromMap(Map<String, dynamic> data) {
    toId = data['about'].toString();
    msg = data['data'].toString();
    read = data['isOnline'].toString();
    type = data['type'].toString();
    fromId = data['fromId'].toString();
    sent = data['sent'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'about': toId,
      'createdAt': msg,
      'isOnline': read,
      'type': type,
      'fromId': fromId,
      'sent': sent,
    };
  }
}
//enum Type { text , image }
