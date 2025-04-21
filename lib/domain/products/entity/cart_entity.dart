import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/domain/products/entity/product_in_cart_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';

import '../../../common/constants/enum.dart';

class CartEntity {
  late int amountProducts;
  late double totalPrice;
  late double subPrice;
  late List<ProductInCartEntity> products;
  late TypeSortProduct? type;
  late SortDirection? direction;

  CartEntity({
    this.type,
    this.direction,
    required this.amountProducts,
    required this.totalPrice,
    this.subPrice = 0,
    List<ProductInCartEntity>? products,
  }) : products = products ?? [];

  void addAmountProduct({
    required ProductEntity product,
    required int amount,
    required TypeAmountProduct type,
  }) {
    final index = products.indexWhere((e) => e.product.id == product.id);
    if (index == -1) {
      if (amount <= 0) return;
      ProductInCartEntity newProduct = ProductInCartEntity(
        product: product,
        amountRetail: type == TypeAmountProduct.retail ? amount : 0,
        amountWholeSale: type == TypeAmountProduct.wholeSale ? amount : 0,
      );

      double price = product.calculatePrice(newProduct);
      newProduct.update(price: price, subPrice: price);
      this.products.add(newProduct);
    } else {
      final current = products[index];
      final updated = current.clone();
      if (type == TypeAmountProduct.retail) {
        final currentAmount = current.amountRetail ?? 0;
        print("currentAmount: $currentAmount, amount: $amount, sum: ${currentAmount + amount}");
        if((currentAmount + amount)>=0) {
          print("${current.amountRetail} ${amount}");
          updated.update(amountRetail: (updated.amountRetail ?? 0) + amount);
        }
        else{
          return;
        }
      } else {
        final currentAmount = current.amountWholeSale ?? 0;
        if((currentAmount + amount)>=0) {
          updated.update(
            amountWhoseSale: (updated.amountWholeSale ?? 0) + amount,
          );
        }
      }
      final totalAmount =
          (updated.amountRetail ?? 0) + (updated.amountWholeSale ?? 0);
      if (totalAmount <= 0) {
        products.removeAt(index);
      } else {
        double price = product.calculatePrice(updated);
        updated.update(price: price);
        products[index] = updated;
        _updatePrice(products.elementAt(index), index);
      }
    }
    _recalculateTotal();
  }

  void _recalculateTotal() {
    amountProducts = 0;
    totalPrice = 0;
    subPrice = 0;

    for (var item in products) {
      amountProducts += (item.amountRetail ?? 0) + (item.amountWholeSale ?? 0);
      totalPrice += item.price ?? 0;
      subPrice += item.subPrice ?? 0;
    }
  }

  void _updatePrice(ProductInCartEntity product, int index) {
    final productInList = products[index];
    final oldSubPrice = productInList.subPrice ?? 0;

    double newSubPrice = product.price ?? 0;

    if ((product.moneyDiscount ?? 0) > 0) {
      newSubPrice = (product.price! - product.moneyDiscount!).clamp(
        0,
        double.infinity,
      );
      productInList.update(rateDiscount: 0);
    } else if ((product.rateDiscount ?? 0) > 0) {
      newSubPrice = product.price! * (1 - product.rateDiscount!);
      productInList.update(moneyDiscount: 0);
    }

    productInList.update(subPrice: newSubPrice);
    subPrice += newSubPrice - oldSubPrice;
  }

  void applyVoucher(
    ProductEntity product,
    double? rateDiscount,
    double? moneyDiscount,
  ) {
    int index = products.indexWhere((e) => e.product.id == product.id);
    if (index != -1) {
      products
          .elementAt(index)
          .update(rateDiscount: rateDiscount, moneyDiscount: moneyDiscount);
      _updatePrice(products.elementAt(index), index);
    }
  }

  void onSortProduct(TypeSortProduct type) {
    direction = type == this.type ? SortDirection.desc : SortDirection.asc;
    this.type = type;
    switch (type) {
      case TypeSortProduct.name:
        products.sort((a, b) => _direction(a.product.name, b.product.name, direction!));
        break;
      case TypeSortProduct.retailPrice:
        products.sort((a, b) => _direction(a.product.retailPrice, b.product.retailPrice, direction!));
        break;
      case TypeSortProduct.wholeSalePrice:
        products.sort((a, b) => _direction(a.product.wholesalePrice, b.product.wholesalePrice, direction!));
        break;
    }
  }

  int _direction(
    dynamic a,
    dynamic b,
    SortDirection direction,
  ) {
    return direction == SortDirection.asc
        ? b.compareTo(a)
        : a.compareTo(b);
  }
}
