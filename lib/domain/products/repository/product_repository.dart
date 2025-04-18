import 'package:dartz/dartz.dart';
import 'package:demo_1/data/products/models/search_product_payload.dart';

abstract class ProductRepository {
  Future<Either> getCategory();
  Future<Either> searchProduct(SearchProductPayload search);
}