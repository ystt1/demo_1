import 'package:dartz/dartz.dart';
import 'package:demo_1/core/usecase.dart';
import 'package:demo_1/domain/products/repository/product_repository.dart';

import '../../../service_locator.dart';

class GetCategoryUseCase extends UseCase<dynamic>{
  @override
  Future<Either> execute({params}) async {
    return await sl<ProductRepository>().getCategory();
  }

}