import 'package:dartz/dartz.dart';
import 'package:demo_1/data/products/models/category_model.dart';
import 'package:demo_1/data/products/models/product_model.dart';
import 'package:demo_1/data/products/models/search_product_payload.dart';
import 'package:demo_1/data/products/service/product_service.dart';
import 'package:demo_1/domain/products/entity/category_entity.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/domain/products/repository/product_repository.dart';

import '../../../service_locator.dart';

class ProductRepositoryImp extends ProductRepository {
  @override
  Future<Either> getCategory() async {
    try {
      Either returnedData = await sl<ProductService>().getCategory();
      return returnedData.fold((error) => Left(error), (data) {
        List<CategoryEntity> categories =
            (data as List<CategoryModel>).map((e) => e.toEntity()).toList();
        return Right(categories);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> searchProduct(SearchProductPayload search) async {
    try {
      Either returnedData = await sl<ProductService>().searchProduct(search);
      return returnedData.fold((error) => Left(error), (data) {
        List<ProductEntity> products = (data as List<ProductModel>).map(
          (ProductModel e) => e.toEntity()
        ).toList();
        return Right(products);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}
