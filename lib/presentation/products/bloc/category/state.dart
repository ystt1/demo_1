import 'package:demo_1/domain/products/entity/category_entity.dart';

abstract class CategoryState {}

class CategoryInitState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategorySuccessState extends CategoryState {
  final List<CategoryEntity> categories;
  final int id;

  CategorySuccessState({required this.categories, required this.id});

  CategorySuccessState copyWith({
    List<CategoryEntity>? categories,
    int? id,
  }) {
    return CategorySuccessState(
      categories: categories ?? this.categories,
      id: id ?? this.id,
    );
  }
}

class CategoryFailureState extends CategoryState {
  final String error;

  CategoryFailureState({required this.error});
}
