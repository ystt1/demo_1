import 'package:dartz/dartz.dart';
import 'package:demo_1/core/usecase.dart';
import 'package:demo_1/data/products/models/search_product_payload.dart';
import 'package:demo_1/domain/products/repository/product_repository.dart';

import '../../../service_locator.dart';

class GetProductUseCase extends UseCase<SearchProductPayload> {
  @override
  Future<Either> execute({SearchProductPayload? params}) {
   return sl<ProductRepository>().searchProduct(params!);
  }

}