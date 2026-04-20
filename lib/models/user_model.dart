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

  /// {@macro user_model}
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
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
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  /// Mengkonversi instance ini menjadi [Map] untuk keperluan serialisasi.
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }
}
