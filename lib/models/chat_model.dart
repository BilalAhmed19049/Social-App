class ChatModel {
  String? uid, name, email, image;
  late DateTime lastActive;
  late bool isOnline;

  ChatModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.lastActive,
    required this.isOnline,
  });

  ChatModel.fromMap(Map<String, dynamic> data) {
    uid = data["uid"];
    name = data["name"];
    email = data["email"];
    image = data["image"];
    lastActive = data["lastActive"].toDate();
    isOnline = data["isOnline"] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "image": image,
      "lastActive": lastActive,
      "isOnline": isOnline,
    };
  }
}
