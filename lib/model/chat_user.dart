class Chatuser {
  Chatuser({
    required this.name,
    required this.about,
    required this.pushToken,
    required this.isOnline,
    required this.createdAt,
    required this.email,
    required this.lastActive,
    required this.id,
    required this.image,
  });
  late String name;
  late String about;
  late String pushToken;
  late bool isOnline;
  late String createdAt;
  late String email;
  late String lastActive;
  late String id;
  late String image;

  Chatuser.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    pushToken = json['push_token'] ?? '';
    isOnline = json['is_online'] ?? '';
    createdAt = json['created_at'] ?? '';
    email = json['email'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json['id'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['about'] = about;
    data['push_token'] = pushToken;
    data['is_online'] = isOnline;
    data['created_at'] = createdAt;
    data['email'] = email;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
