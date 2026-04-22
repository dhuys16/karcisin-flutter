import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is CategoryLoaded) {
            final categories = state.categories;
            
            if (categories.isEmpty) {
              return const Center(child: Text("Belum ada kategori."));
            }

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF3758F9), // Kode warna utama
                      child: Icon(Icons.category, color: Colors.white),
                    ),
                    title: Text(categories[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Nanti bisa ditambahkan event DeleteCategory
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Memuat data..."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3758F9),
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final _nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Kategori"),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Nama Kategori",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3758F9)),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  context.read<CategoryBloc>().add(AddCategory(_nameController.text));
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}