class PostModel {
  String? name;
  String? postImg;
  late String uid; // owner of post
  String? id; //post document id
  late String text;
  List<String> likes = [];
  List<String> comments = [];

//  late DateTime date;

  PostModel({
    required this.name,
    required this.postImg,
    required this.uid,
    required this.text,
    this.likes = const [],
    this.comments = const [],
    required this.id,

    // required this.date
  });

  PostModel.fromMap(Map<String, dynamic> data) {
    name = data["name"];
    postImg = data["image"];
    uid = data["uid"];
    text = data["text"];
    likes = List<String>.from(data['likes'] ?? []);
    id = data["id"];

    // Timestamp timestamp = data["date"];
    // date = timestamp.toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": postImg,
      "uid": uid,
      "text": text,
      "likes": likes,
      "id": id,
      // "date": date,
    };
  }
}
