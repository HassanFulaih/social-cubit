class PostModel {
  final String uId;
  final String name;
  final String? image;
  final String postId;
  num numOfLikes;
  num numOfComments;
  List<InteractionModel> interaction;
  final String? postImage;
  final String text;
  final String dateTime;

  PostModel({
    required this.postId,
    this.numOfLikes = 0,
    this.numOfComments = 0,
    this.interaction = const [],
    required this.uId,
    required this.name,
    this.postImage,
    required this.text,
    required this.dateTime,
    this.image,
  });

  factory PostModel.fromJson(dynamic map, String postId) {
    return PostModel(
      uId: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'],
      postImage: map['postImage'],
      text: map['text'] ?? '',
      dateTime: map['dateTime'] ?? '',
      postId: postId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uId,
      'name': name,
      'image': image,
      'postImage': postImage,
      'text': text,
      'dateTime': dateTime,
    };
  }
}

class InteractionModel {
  final String userId;
  final String name;
  final String image;
  bool isLiked;
  final String? comment;

  InteractionModel({
    required this.userId,
    required this.name,
    required this.image,
    required this.isLiked,
    required this.comment,
  });

  factory InteractionModel.fromJson(dynamic map, String id) {
    return InteractionModel(
      userId: id,
      name: map['name'] ?? '',
      image: map['image'] ??
          'https://militaryhealthinstitute.org/wp-content/uploads/sites/37/2021/08/blank-profile-picture-png.png',
      isLiked: map['like'] ?? false,
      comment: map['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'image': image,
      'like': isLiked,
      'comment': comment,
    };
  }
}
