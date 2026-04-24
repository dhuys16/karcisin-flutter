abstract class CategoryEvent {}

class FetchCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  AddCategory(this.name);
}

class DeleteCategory extends CategoryEvent {
  final int id;
  DeleteCategory(this.id);
}
