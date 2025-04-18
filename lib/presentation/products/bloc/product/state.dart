import 'package:demo_1/common/constants/enum.dart';
import 'package:demo_1/data/products/models/search_product_payload.dart';
import 'package:demo_1/domain/products/entity/cart_entity.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';

abstract class ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  final List<ProductEntity> products;
  final SearchProductPayload search;
  final bool? isEnd;
  final bool? isLoadingMore;
  final CartEntity? cart;
  final ReturnedApplyVoucher? returnedApplyVoucher;

  ProductSuccessState({
    required this.products,
    required this.search,
    this.isEnd,
    this.isLoadingMore,
    this.cart,
    this.returnedApplyVoucher
  });

  ProductSuccessState copyWith({
    List<ProductEntity>? product,
    SearchProductPayload? search,
    bool? isEnd,
    bool? isLoadingMore,
    CartEntity? cart,
    ReturnedApplyVoucher? applyVoucherError
  }) {
    return ProductSuccessState(
      products: product ?? this.products,
      search: search ?? this.search,
      isEnd: isEnd ?? this.isEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      cart: cart ?? this.cart,
      returnedApplyVoucher: applyVoucherError??this.returnedApplyVoucher
    );
  }
}

class ProductFailureState extends ProductState {
  final String error;

  ProductFailureState({required this.error});
}
