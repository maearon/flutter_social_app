class Micropost {
  final int id;
  final String content;
  final String? gravatarId;
  final String image;
  final int size;
  final String timestamp;
  final String userId;
  final String? userName;
  final String? title;
  final String? description;
  final String? videoId;
  final String? channelTitle;

  Micropost({
    required this.id,
    required this.content,
    this.gravatarId,
    required this.image,
    required this.size,
    required this.timestamp,
    required this.userId,
    this.userName,
    this.title,
    this.description,
    this.videoId,
    this.channelTitle,
  });

  factory Micropost.fromJson(Map<String, dynamic> json) {
    return Micropost(
      id: json['id'],
      content: json['content'],
      gravatarId: json['gravatar_id'],
      image: json['image'] ?? '',
      size: json['size'] ?? 0,
      timestamp: json['timestamp'],
      userId: json['user_id'].toString(),
      userName: json['user_name'],
      title: json['title'],
      description: json['description'],
      videoId: json['videoId'],
      channelTitle: json['channelTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'gravatar_id': gravatarId,
      'image': image,
      'size': size,
      'timestamp': timestamp,
      'user_id': userId,
      'user_name': userName,
      'title': title,
      'description': description,
      'videoId': videoId,
      'channelTitle': channelTitle,
    };
  }
}
