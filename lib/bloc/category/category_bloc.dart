import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await repository.getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategory>((event, emit) async {
      try {
        await repository.addCategory(event.name);

        add(FetchCategories());
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategory>((event, emit) async {
      try {
        await repository.deleteCategory(event.id);

        add(FetchCategories());
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
