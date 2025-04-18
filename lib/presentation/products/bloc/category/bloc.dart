import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/domain/products/entity/category_entity.dart';
import 'package:demo_1/domain/products/usecase/get_category_usecase.dart';

import '../../../../service_locator.dart';
import 'event.dart';
import 'state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryLoadingState()) {
    on<GetCategoryEvent>((event, emit) => getCategory(event, emit));
    on<ChooseCategoryEvent>((event, emit) => chooseCategory(event, emit));
  }

  Future<void> getCategory(
    CategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoadingState());
      Either returnedData = await sl<GetCategoryUseCase>().execute();
      returnedData.fold((error) => emit(CategoryFailureState(error: error)), (
        data,
      ) {
        (data as List<CategoryEntity>).insert(
          0,
          CategoryEntity(id: 0, name: TextData.all),
        );
        emit(CategorySuccessState(categories: data, id: 0));
      });
    } catch (e) {
      emit(CategoryFailureState(error: e.toString()));
    }
  }

  Future<void> chooseCategory(
    CategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      int id = (event as ChooseCategoryEvent).id;
      CategorySuccessState newCategoryState = (state as CategorySuccessState)
          .copyWith(id: id);
      emit(newCategoryState);
    } catch (e) {
      emit(CategoryFailureState(error: e.toString()));
    }
  }
}
