import 'package:demo_1/domain/products/entity/category_entity.dart';

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': this.id, 'name': this.name};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(id: map['id'] ?? 0, name: map['name'] ?? 'name');
  }
}

extension CategoryModelToEntity on CategoryModel
{
  CategoryEntity toEntity()
  {
    return CategoryEntity(id: id, name: name);
  }
}

