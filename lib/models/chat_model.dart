class ChatUserModel {
  late final String about, createdAt, isOnline, id, lastActive, pushToken, uid;

  ChatUserModel({
    // required this.image,
    required this.about,
    // required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    // required this.email,
    required this.pushToken,
    required this.uid,
  });

  ChatUserModel.fromMap(Map<String, dynamic> data) {
    about = data['about'];
    createdAt = data['data'];
    isOnline = data['isOnline'];
    id = data['id'];
    lastActive = data['lastActive'];
    pushToken = data['pushToken'];
    uid = data['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'about': about,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'id': id,
      'lastActive': lastActive,
      'pushToken': pushToken,
      'uid': uid,
    };
  }
}
