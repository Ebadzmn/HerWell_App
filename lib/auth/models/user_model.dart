class UserModel {
  final String? id;
  final String? email;
  final String? username;
  final String? name;
  final String? role;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.name,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      name: json['name']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'role': role,
    };
  }
}
