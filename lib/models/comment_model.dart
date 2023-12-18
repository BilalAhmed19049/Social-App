class CommentModel {
  String? id;
  String? text;
  String? uid, postId;

  CommentModel({
    this.id,
    required this.text,
    required this.uid,
    required this.postId,
  });

  CommentModel.fromMap(Map<String, dynamic> data) {
    text = data['text'];
    uid = data["uid"];
    id = data['id'];
    postId = data['postId'];
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "uid": uid,
      "id": id,
      "postId": postId,
    };
  }
}
