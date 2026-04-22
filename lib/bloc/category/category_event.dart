abstract class CategoryEvent {}

class FetchCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  AddCategory(this.name);
}