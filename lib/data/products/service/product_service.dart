import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:demo_1/assets/mockup_data.dart';
import 'package:demo_1/common/constants/enum.dart';
import 'package:demo_1/data/products/models/category_model.dart';
import 'package:demo_1/data/products/models/product_model.dart';
import 'package:demo_1/data/products/models/search_product_payload.dart';
import 'package:flutter/services.dart';

abstract class ProductService {
  Future<Either> getCategory();

  Future<Either> searchProduct(SearchProductPayload search);
}

class ProductServiceImp extends ProductService {
  @override
  Future<Either> getCategory() async {
    try {
      print('Start delay');
      await Future.delayed(Duration(seconds: 1));
      print('After delay');

      var categoryJson = await rootBundle.loadString(MockupData.category);
      List<dynamic> decodeCategory = json.decode(categoryJson);
      final List<CategoryModel> categories =
          decodeCategory.map((e) => CategoryModel.fromMap(e)).toList();
      return Right(categories);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> searchProduct(SearchProductPayload search) async {
    try {
      print('Start delay');
      await Future.delayed(Duration(seconds: 1));
      print('After delay');
      var productJson = await rootBundle.loadString(MockupData.product);
      List<dynamic> decodeProduct = json.decode(productJson);
      final List<ProductModel> products =
          decodeProduct.map((e) => ProductModel.fromMap(e)).toList();
      List<ProductModel> products1 =
      products;
      if(search.idCategory!=0)
        {
          products1 =
              products.where((e) => e.categoryId == search.idCategory).toList();
        }
      List<ProductModel> products2 =
          products1
              .where(
                (e) => e.name.toLowerCase().contains(search.name.toLowerCase()),
              )
              .toList();

         switch(search.sort)
         {
           case TypeSortProduct.name:
             products2.sort((a,b)=>search.direction==SortDirection.asc?b.name.compareTo(a.name) :a.name.compareTo(b.name));
             break;
           case TypeSortProduct.retailPrice:
             products2.sort((a,b)=>search.direction==SortDirection.asc?b.retailPrice.compareTo(a.retailPrice):a.retailPrice.compareTo(b.retailPrice));
             break;
           case TypeSortProduct.wholeSalePrice:
             products2.sort((a,b)=>search.direction==SortDirection.asc?b.wholesalePrice.compareTo(a.wholesalePrice):a.wholesalePrice.compareTo(b.wholesalePrice));
             break;
           default:
             break;
         }

      List<ProductModel> data = products2.sublist(
        search.index,
        search.index + 5 > products2.length
            ? products2.length
            : search.index + 5,
      );

      return Right(data);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
