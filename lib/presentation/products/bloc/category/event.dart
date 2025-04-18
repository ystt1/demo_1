abstract class CategoryEvent {}

class CategoryInitEvent extends CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {}

class ChooseCategoryEvent extends CategoryEvent {
  final int id;

  ChooseCategoryEvent({required this.id});
}
