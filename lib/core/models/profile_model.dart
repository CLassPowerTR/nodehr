class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    return ProfileModel(
      id: idValue?.toString() ?? '',
      name: (json['name'] ?? json['full_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      photoUrl:
          (json['photoUrl'] ?? json['photo_url'] ?? json['avatar']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
  };
}
