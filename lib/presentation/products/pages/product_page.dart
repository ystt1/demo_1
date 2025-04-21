import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/common/constants/enum.dart';
import 'package:demo_1/domain/products/entity/category_entity.dart';
import 'package:demo_1/presentation/products/bloc/category/bloc.dart';
import 'package:demo_1/presentation/products/bloc/category/event.dart';
import 'package:demo_1/presentation/products/bloc/category/state.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:demo_1/presentation/products/bloc/product/state.dart';
import 'package:demo_1/presentation/products/widgets/list_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_1/assets/icon_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/product_labels.dart';
import '../widgets/cart_button.dart';
import '../widgets/search_products_field.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: Padding(
          padding: const EdgeInsets.only(top: 47.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(CupertinoIcons.back,size: 24,),
            ),
            leadingWidth: 40,
            titleSpacing: 6,
            toolbarHeight: 68,
            title: SearchProductsField(),
            actions: [
              SizedBox(width: 2,),
              Image.asset(IconString.iconQrCode, width: 24, height: 24),
              SizedBox(width: 8),
              Image.asset(IconString.iconFilter, width: 24, height: 24),
              SizedBox(width: 8),
              _cartIcon(context),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _categoryButton(),
          _listLabel(context),
          ListProduct(),
          _buttonLayout(),
        ],
      ),
    );
  }

  Widget _categoryButton() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (BuildContext context, CategoryState state) {
        if (state is CategoryLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CategorySuccessState) {
          List<CategoryEntity> categories = state.categories;

          return Container(
            height: 60,
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                bool isChosen = state.id == categories[index].id;
                return GestureDetector(
                  onTap: () {
                    context.read<CategoryBloc>().add(
                      ChooseCategoryEvent(id: categories[index].id),
                    );

                    context.read<ProductBloc>().add(
                      ChangeCategoryEvent(idCategory: categories[index].id),
                    );
                  },
                  child: Container(
                    width: 72,
                    height: 36,
                    decoration: BoxDecoration(
                      color:
                          isChosen
                              ? AppColors.thirdBackgroundColor
                              : AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1,
                        color:
                            isChosen
                                ? AppColors.primaryColor
                                : AppColors.borderBackgroundColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categories[index].name,
                        style: TextStyle(
                          color:
                              isChosen
                                  ? AppColors.dataTextColor
                                  : AppColors.labelColor,
                          fontWeight:
                              isChosen ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => SizedBox(width: 4),
              itemCount: categories.length,
            ),
          );
        }
        if (state is CategoryFailureState) {
          return Center(child: Text(state.error));
        }
        return Center(child: Text("Something went wrong"));
      },
    );
  }

  Widget _listLabel(BuildContext context) {
    TypeSortProduct? type;
    SortDirection? direction;
    if (context.watch<ProductBloc>().state is ProductSuccessState) {
      type =
          (context.watch<ProductBloc>().state as ProductSuccessState)
              .search
              .sort;
      direction =
          (context.watch<ProductBloc>().state as ProductSuccessState)
              .search
              .direction;
    }
    return Container(
      color: AppColors.secondBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: MediaQuery.of(context).size.width,
      child: ProductLabels(type: type, direction: direction, isInCart: false),
    );
  }

  Widget _buttonLayout() {
    return Container(
      padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 34),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        boxShadow: [BoxShadow(
          blurRadius: 3,
          offset: Offset(0, -1),
          color: Color(0xff000000).withValues(alpha: 0.1)
        )],
        border: Border(
          top: BorderSide(width: 1, color: AppColors.secondBackgroundColor),
        ),
      ),
      child: Center(child: CartButton()),
    );
  }

  Widget _cartIcon(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      child: Stack(
        children: [
          Center(
            child: Image.asset(IconString.iconCart, width: 24, height: 24),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (BuildContext context, ProductState state) {
                if (state is ProductSuccessState) {
                  int? amount =
                      state.cart != null ? state.cart?.products.length : 0;
                  return Visibility(
                    visible: amount != 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          amount.toString(),
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
