class MessageModel {
  late final String read, fromId, sent;
  late final Type type;
  String? toId;
  String? msg;

  //late final Type type;
  MessageModel({
    // required this.image,
    required this.toId,
    // required this.name,
    required this.msg,
    required this.read,
    //  required this.type,
    required this.fromId,
    // required this.email,
    required this.sent,
    required this.type,
  });

  MessageModel.fromMap(Map<String, dynamic> data) {
    fromId = data["fromId"];
    read = data["read"];
    msg = data["msg"];
    sent = data["sent"];
    toId = data["toId"];
    // type=data["type"];
    type =
        (data['type'].toString() == Type.image.name ? Type.image : Type.text);
  }

  Map<String, dynamic> toMap() {
    return {
      'toId': toId,
      'msg': msg,
      'read': read,
      // 'type': type,
      'fromId': fromId,
      'sent': sent,
      'type': type.name,
    };
  }
}
enum Type { text, image }
