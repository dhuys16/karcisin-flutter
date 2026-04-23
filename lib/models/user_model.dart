/// {@template user_model}
/// Model yang merepresentasikan data pengguna dari API.
///
/// Digunakan untuk men-deserialisasi response JSON dari endpoint
/// `/register` maupun `/login`.
/// {@endtemplate}
class UserModel {
  /// ID unik pengguna di database.
  final int id;

  /// Nama lengkap pengguna.
  final String name;

  /// Alamat email pengguna (bersifat unik).
  final String email;

  /// Peran pengguna: `'user'` (pengunjung) atau `'owner'` (penyelenggara).
  final String role;
  final String phone;
  final String? image;

  /// {@macro user_model}
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.image,
  });

  /// Membuat instance [UserModel] dari sebuah [Map] (hasil decode JSON).
  ///
  /// Contoh struktur JSON yang diharapkan:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "name": "Budi Santoso",
  ///   "email": "budi@contoh.com",
  ///   "role": "user"
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
    );
  }

  /// Mengkonversi instance ini menjadi [Map] untuk keperluan serialisasi.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, image: $image)';
  }
}
