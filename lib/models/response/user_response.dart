class UserResponse {
  final int id;
  final String name;
  final String email;
  final String? image;
  final String phone;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.phone,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'],
    );
  }
}
