import 'package:demo_1/data/products/repository_imp/product_repository_imp.dart';
import 'package:demo_1/data/products/service/product_service.dart';
import 'package:demo_1/domain/products/repository/product_repository.dart';
import 'package:demo_1/domain/products/usecase/get_category_usecase.dart';
import 'package:demo_1/domain/products/usecase/get_product_usecase.dart';
import 'package:get_it/get_it.dart';

final sl=GetIt.instance;


Future<void> initializeDependencies() async {
  //service
  sl.registerSingleton<ProductService>(ProductServiceImp());

  //repo
  sl.registerSingleton<ProductRepository>(ProductRepositoryImp());

  //usecase
  sl.registerSingleton<GetCategoryUseCase>(GetCategoryUseCase());
  sl.registerSingleton<GetProductUseCase>(GetProductUseCase());
}