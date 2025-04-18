import 'package:demo_1/domain/products/entity/product_entity.dart';

class ProductModel {
  final int id;
  final String name;
  final int categoryId;
  final double wholesalePrice;
  final double retailPrice;
  final String unit;
  final String volume;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.wholesalePrice,
    required this.retailPrice,
    required this.unit,
    required this.volume,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'categoryId': this.categoryId,
      'wholesalePrice': this.wholesalePrice,
      'retailPrice': this.retailPrice,
      'unit': this.unit,
      'volume': this.volume,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'product1',
      categoryId: map['category_id'] ?? 0,
      wholesalePrice: map['wholesale_price'] ?? 0,
      retailPrice: map['retail_price'] ??0,
      unit: map['unit'] ?? 'unit',
      volume: map['volume'] ?? 'volume',
    );
  }

}

extension ProductModelToEntity on ProductModel{
  ProductEntity toEntity() {
    return ProductEntity(id: id,
        name: name,
        categoryId: categoryId,
        wholesalePrice: wholesalePrice,
        retailPrice: retailPrice,
        unit: unit,
        volume: volume);
  }
}
