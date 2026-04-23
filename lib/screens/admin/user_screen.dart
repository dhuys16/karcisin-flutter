import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_state.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is UserLoaded) {
            final users = state.users;

            if (users.isEmpty) {
              return const Center(child: Text("Belum ada pengguna yang mendaftar."));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                
                // Menentukan warna badge berdasarkan role
                Color roleColor = user.role == 'owner' ? Colors.orange : Colors.green;
                String roleLabel = user.role == 'owner' ? 'Penyelenggara' : 'Pengunjung';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: roleColor.withOpacity(0.2),
                      child: Icon(Icons.person, color: roleColor),
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.email),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: roleColor),
                      ),
                      child: Text(
                        roleLabel,
                        style: TextStyle(color: roleColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Memuat data..."));
        },
      ),
    );
  }
}