import '../../models/response/category_response.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryResponse> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryActionSuccess extends CategoryState {
  final String message;
  CategoryActionSuccess(this.message);
}