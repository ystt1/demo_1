import 'package:demo_1/domain/products/entity/product_entity.dart';

class ProductInCartEntity {

  late double? rateDiscount;
  late double? moneyDiscount;
  late int? amountRetail;
  late int? amountWholeSale;
  late double? price;
  late double? subPrice;
  final ProductEntity product;
  ProductInCartEntity({
    required this.product,
    this.rateDiscount = 0,
    this.moneyDiscount = 0,
    this.amountRetail = 0,
    this.amountWholeSale = 0,
    this.price = 0,
    this.subPrice=0
  });

  ProductInCartEntity clone() {
    return ProductInCartEntity(
      product: product,
      rateDiscount: rateDiscount,
      moneyDiscount: moneyDiscount,
      amountRetail: amountRetail,
      amountWholeSale: amountWholeSale,
      price: price,
    );
  }

  ProductInCartEntity copyWith({
    double? rateDiscount,
    double? moneyDiscount,
    int? amountRetail,
    int? amountWhoseSale,
    double? price,
    double? subPrice
  }) {
    return ProductInCartEntity(
      product: product,
      rateDiscount: rateDiscount ?? this.rateDiscount,
      moneyDiscount: moneyDiscount ?? this.moneyDiscount,
      amountWholeSale: amountWhoseSale ?? this.amountWholeSale,
      amountRetail: amountRetail ?? this.amountRetail,
      price: price ?? this.price,
      subPrice: subPrice??this.subPrice
    );
  }

  update({
    double? rateDiscount,
    double? moneyDiscount,
    int? amountRetail,
    int? amountWhoseSale,
    double? price,
    double? subPrice
  }) {
    this.rateDiscount = rateDiscount ?? this.rateDiscount;
    this.moneyDiscount = moneyDiscount ?? this.moneyDiscount;
    this.amountWholeSale = amountWhoseSale ?? this.amountWholeSale;
    this.amountRetail = amountRetail ?? this.amountRetail;
    this.price = price ?? this.price;
    this.subPrice=subPrice??this.subPrice;
  }
}
