import 'package:demo_1/domain/products/entity/product_in_cart_entity.dart';

class ProductEntity {
  final int id;
  final String name;
  final int categoryId;
  final double wholesalePrice;
  final double retailPrice;
  final String unit;
  final String volume;

  ProductEntity({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.wholesalePrice,
    required this.retailPrice,
    required this.unit,
    required this.volume,
  });

  ProductEntity clone() {
    return ProductEntity(
      id: id,
      name: name,
      categoryId: categoryId,
      wholesalePrice: wholesalePrice,
      retailPrice: retailPrice,
      unit: unit,
      volume: volume,
    );
  }
  double calculatePrice(ProductInCartEntity product) {
    return this.wholesalePrice * product.amountWholeSale! +
        this.retailPrice * product.amountRetail!;
  }

}


