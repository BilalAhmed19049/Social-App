class UserDataModel {
  String? email, password;
  String? id,
      country,
      address,
      phonenumber,
      fullname,
      url,
      about,
      createdAt,
      pushToken;
  List<String> friends = [];
  List<String> requests = [];
  late String lastActive;
  late bool isOnline;

  UserDataModel({
    required this.email,
    required this.password,
    this.fullname,
    this.id,
    this.address,
    this.country,
    this.phonenumber,
    this.url,
    this.friends = const [],
    this.requests = const [],
    this.about,
    this.createdAt,
    required this.isOnline,
    required this.lastActive,
    this.pushToken,
  });

  UserDataModel.fromMap(Map<String, dynamic> data) {
    fullname = data['fullname'];
    email = data['email'];
    id = data['id'];
    address = data['address'];
    phonenumber = data['number'];
    url = data['url'];
    country = data['country'];
    friends = List<String>.from(data['friends'] ?? []);
    requests = List<String>.from(data['requests'] ?? []);
    about = data['about'];
    createdAt = data['createdAt'];
    isOnline = data['isOnline'];
    lastActive = data['lastActive'];
    pushToken = data['pushToken'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'id': id,
      'number': phonenumber,
      'address': address,
      'url': url,
      'country': country,
      'friends': friends,
      'requests': requests,
      'about': about,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'pushToken': pushToken,
    };
  }
}
