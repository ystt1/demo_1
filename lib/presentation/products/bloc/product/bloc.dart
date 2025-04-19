import 'package:dartz/dartz.dart';
import 'package:demo_1/common/constants/constant.dart';
import 'package:demo_1/data/products/models/search_product_payload.dart';
import 'package:demo_1/domain/products/entity/cart_entity.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/domain/products/usecase/get_product_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/constants/enum.dart';
import '../../../../service_locator.dart';
import 'event.dart';
import 'state.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoadingState()) {
    on<SearchProductEvent>(
      (event, emit) => _searchProduct(event, emit),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<ChangeCategoryEvent>((_changeCategory));
    on<LoadMoreProductEvent>(_loadMoreProduct);
    on<ChangeAmountProductEvent>(_changeAmountProduct);
    on<OnCloseSheetEvent>(_onCloseSheet);
    on<ApplyVoucherProductEvent>(_applyVoucher);
    on<OnSortProductEvent>(_onSortProduct,);
  }

  Future<void> _searchProduct(
    ProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    SearchProductEvent currentEvent = (event as SearchProductEvent);
    SearchProductPayload search = SearchProductPayload(
      idCategory: 0,
      name: currentEvent.name,
      index: 0,
    );
    if (state is ProductSuccessState) {
      ProductSuccessState currentState = state as ProductSuccessState;
      search = currentState.search.copyWith(name: currentEvent.name, index: 0);
    }
    Either returnedData = await sl<GetProductUseCase>().execute(params: search);
    returnedData.fold(
      (error) => emit(ProductFailureState(error: error)),
      (data) => emit(
        ProductSuccessState(
          products: data,
          search: search,
          isEnd:
              (data as List<ProductEntity>).length < AppConstant.amountLoadMore,
          cart: (state as ProductSuccessState).cart,
        ),
      ),
    );
  }

  Future<void> _changeCategory(
    ProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    ChangeCategoryEvent currentEvent = event as ChangeCategoryEvent;
    CartEntity? cart = CartEntity(
      products: [],
      amountProducts: 0,
      totalPrice: 0,
    );
    SearchProductPayload search = SearchProductPayload(
      idCategory: 0,
      name: '',
      index: 0,
    );
    if (state is ProductSuccessState) {
      ProductSuccessState currentState = state as ProductSuccessState;
      search = currentState.search.copyWith(
        idCategory: currentEvent.idCategory,
        index: 0,
      );
      cart = (state as ProductSuccessState).cart;
    }
    Either returnedData = await sl<GetProductUseCase>().execute(params: search);
    returnedData.fold(
      (error) => emit(ProductFailureState(error: error)),
      (data) => emit(
        ProductSuccessState(
          products: data,
          search: search,
          isEnd:
              (data as List<ProductEntity>).length < AppConstant.amountLoadMore,
          isLoadingMore: false,
          cart: cart,
        ),
      ),
    );
  }

  Future<void> _loadMoreProduct(
    ProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is ProductSuccessState &&
          (state as ProductSuccessState).isEnd != true) {
        ProductSuccessState currentState = (state as ProductSuccessState);
        int index = currentState.products.length;
        SearchProductPayload search = currentState.search.copyWith(
          index: index,
        );
        ProductSuccessState flagState = currentState.copyWith(
          isLoadingMore: true,
        );
        emit(flagState);

        Either returnedData = await sl<GetProductUseCase>().execute(
          params: search,
        );
        returnedData.fold((error) => emit(ProductFailureState(error: error)), (
          data,
        ) {
          List<ProductEntity> products = currentState.products;
          products.addAll(data);
          emit(
            ProductSuccessState(
              products: products,
              search: search,
              isEnd:
                  (data as List<ProductEntity>).length <
                  AppConstant.amountLoadMore,
              isLoadingMore: false,
              cart: (state as ProductSuccessState).cart,
            ),
          );
        });
      }
    } catch (e) {
      emit(ProductFailureState(error: e.toString()));
    }
  }

  void _changeAmountProduct(ProductEvent event, Emitter<ProductState> emit) {
    ChangeAmountProductEvent currentEvent = (event as ChangeAmountProductEvent);
    if (state is ProductSuccessState) {
      ProductSuccessState currentState = (state as ProductSuccessState);
      List<ProductEntity> newProducts = [];
      CartEntity? cartEntity = currentState.cart;
      newProducts.addAll(
        currentState.products.map((ProductEntity e) {
          if (e.id == currentEvent.productId) {
            cartEntity = updateCart(e, event.amount, event.typeAmountProduct);
          }
          return e;
        }),
      );
      ProductSuccessState newState = currentState.copyWith(
        product: newProducts,
        cart: cartEntity,
      );
      emit(newState);
    }
  }

  CartEntity updateCart(
    ProductEntity product,
    int amount,
    TypeAmountProduct type,
  ) {
    ProductSuccessState currentState = state as ProductSuccessState;
    var cart = currentState.cart;
    cart ??= CartEntity(products: [], amountProducts: 0, totalPrice: 0);
    cart.addAmountProduct(product: product, amount: amount, type: type);
    return cart;
  }

  void _applyVoucher(
    ApplyVoucherProductEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductSuccessState) {
      ProductSuccessState currentState = state as ProductSuccessState;
      if (event.moneyDiscount != 0 && event.rateDiscount != 0) {
        ProductSuccessState newState = currentState.copyWith(
          applyVoucherError: ReturnedApplyVoucher.error1,
        );
        emit(newState);
        return;
      } else {
        if (event.rateDiscount! >= 100) {
          ProductSuccessState newState = currentState.copyWith(
            applyVoucherError: ReturnedApplyVoucher.error3,
          );
          emit(newState);
          return;
        }
      }
      if (event.moneyDiscount == 0 && event.rateDiscount == 0) {
        ProductSuccessState newState = currentState.copyWith(
          applyVoucherError: ReturnedApplyVoucher.error2,
        );
        emit(newState);
        return;
      }

      final index = currentState.products.indexWhere(
        (e) => e.id == event.productId,
      );
      var cart = currentState.cart;
      cart ??= CartEntity(products: [], amountProducts: 0, totalPrice: 0);
      cart.applyVoucher(
        currentState.products.elementAt(index),
        event.rateDiscount != null ? event.rateDiscount! / 100 : null,
        event.moneyDiscount,
      );
      ProductSuccessState newState = currentState.copyWith(
        cart: cart,
        applyVoucherError: ReturnedApplyVoucher.success,
      );
      emit(newState);
    }
  }

  void _onCloseSheet(ProductEvent event, Emitter<ProductState> emit) {
    if (state is ProductSuccessState) {
      ProductSuccessState currentState = (state as ProductSuccessState)
          .copyWith(applyVoucherError: ReturnedApplyVoucher.close);
      emit(currentState);
    }
  }

  Future<void> _onSortProduct(
    OnSortProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductSuccessState) {
      ProductSuccessState currentState = (state as ProductSuccessState);
      if (!event.isForCart) {
        SearchProductPayload search = currentState.search.copyWith(
          type: event.type,
          index: 0,
          direction:
              event.type == currentState.search.sort
                  ? SortDirection.asc
                  : SortDirection.desc,
        );
        Either returnedData = await sl<GetProductUseCase>().execute(
          params: search,
        );
        returnedData.fold(
          (error) => emit(ProductFailureState(error: error)),
          (data) => emit(
            ProductSuccessState(
              products: data,
              search: search,
              isEnd:
                  (data as List<ProductEntity>).length <
                  AppConstant.amountLoadMore,
              isLoadingMore: false,
              cart: currentState.cart,
            ),
          ),
        );
      } else {
        CartEntity? cart = currentState.cart;
        cart?.onSortProduct(event.type);
        ProductSuccessState newState = currentState.copyWith(cart: cart);
        emit(newState);
      }
    }
  }
}
