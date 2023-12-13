class CommentModel {
  String? id;
  String? commentText;
  late String uid;

  CommentModel({
    this.id,
    required this.commentText,
    required this.uid,
  });

  CommentModel.fromMap(Map<String, dynamic> data) {
    uid = data["uid"];
    commentText = data["text"];
    id = data["id"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "commentText": commentText,
      "id": id,
    };
  }
}
