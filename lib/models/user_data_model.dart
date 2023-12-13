class UserDataModel {
  late String email, password;
  String? id, country, address, phonenumber, fullname, url;
  List<String> friends = [];
  List<String> requests = [];

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
    };
  }
}
