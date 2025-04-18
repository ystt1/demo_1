

import '../../../../common/constants/enum.dart';

abstract class ProductEvent {}

class InitEvent extends ProductEvent {}

class SearchProductEvent extends ProductEvent {
  final String name;

  SearchProductEvent({required this.name});
}

class ChangeCategoryEvent extends ProductEvent {
  final int idCategory;

  ChangeCategoryEvent({required this.idCategory});
}

class LoadMoreProductEvent extends ProductEvent {
  LoadMoreProductEvent();
}

class ChangeAmountProductEvent extends ProductEvent {
  final int productId;
  final int amount;
  final TypeAmountProduct typeAmountProduct;

  ChangeAmountProductEvent({
    required this.amount,
    required this.typeAmountProduct,
    required this.productId,
  });
}

class ApplyVoucherProductEvent extends ProductEvent {
  final int productId;
  final double? moneyDiscount;
  final double? rateDiscount;

  ApplyVoucherProductEvent({
    required this.productId,
    this.moneyDiscount,
    this.rateDiscount,
  });
}


class OnCloseSheetEvent extends ProductEvent {
}


class OnSortProductEvent extends ProductEvent {
  final TypeSortProduct type;
  final bool isForCart;

  OnSortProductEvent({required this.type, required this.isForCart});
}
