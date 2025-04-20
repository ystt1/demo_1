import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/common/helper/app_helper.dart';
import 'package:demo_1/common/widgets/product_card.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../assets/icon_string.dart';
import '../../../common/constants/enum.dart';
import '../../../common/widgets/app_divider_horizontal.dart';
import '../../../common/widgets/product_labels.dart';
import '../../../domain/products/entity/product_in_cart_entity.dart';
import '../bloc/expansion/bloc.dart';
import '../widgets/expansion.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ExpansionBloc(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(68 + 47),
          child: Padding(
            padding: EdgeInsets.only(top: 47),
            child: AppBar(
              toolbarHeight: 68,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back, size: 24),
                ),
              ),
              leadingWidth: 40,
              titleSpacing: 6,
              title: Text(
                TextData.cart,
                style: TextStyle(
                  color: AppColors.dataTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              actions: [
                Image.asset(IconString.iconQrCode, width: 24, height: 24),
                SizedBox(width: 16),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            AppDividerHorizontal(),
            SizedBox(height: 8),
            _listLabel(context),
            SizedBox(height: 8),
            _productList(),
            Builder(
              builder: (context) {
                return _orderInformation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listLabel(BuildContext context) {
    TypeSortProduct? type = null;
    SortDirection? direction = null;
    if (context.watch<ProductBloc>().state is ProductSuccessState) {
      type =
          (context.watch<ProductBloc>().state as ProductSuccessState)
              .cart!
              .type;

      direction =
          (context.watch<ProductBloc>().state as ProductSuccessState)
              .cart!
              .direction;
    }
    return Container(
      height: 24,
      color: AppColors.backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ProductLabels(isInCart: true, type: type, direction: direction),
    );
  }

  Widget _productList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (BuildContext context, ProductState state) {
            if (state is ProductSuccessState) {
              if (state.cart == null || state.cart!.products.isEmpty) {
                return Center(child: Text(TextData.endOfList));
              }
              return ListView.separated(
                itemBuilder: (_, index) {
                  int? retailAmount = 0;
                  int? wholeSaleAmount = 0;
                  if (state.cart != null) {
                    retailAmount = state.cart!.products[index].amountRetail;
                    wholeSaleAmount =
                        state.cart!.products[index].amountWholeSale;
                  }
                  return ProductCard(
                    isCheckOutPage: false,
                    product: state.cart!.products[index].product,
                    wholeSaleAmount: wholeSaleAmount,
                    retailAmount: retailAmount,
                  );
                },
                separatorBuilder: (_, index) => SizedBox(height: 8),
                itemCount: state.cart!.products.length,
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _orderInformation(BuildContext context) {
    bool isExpanded = context.watch<ExpansionBloc>().state;
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (BuildContext context, ProductState state) {
        if (state is ProductSuccessState) {
          if (state.cart == null) {
            return SizedBox();
          }
          List<ProductInCartEntity> productDiscount =
              state.cart!.products
                  .where((e) => e.moneyDiscount != 0 || e.rateDiscount != 0)
                  .toList();
          double length = productDiscount.length as double;
          double height =
              isExpanded && length > 0
                  ? 202 + 12 + 22 * length + 4 * length + 24 + 8 + 48
                  : 254;
          double maxHeight = 202 + 12 + 22 * 4 + 4 * 4 + 24 + 8 + 48;
          if (height > maxHeight) {
            height = maxHeight;
          }
          print(height);
          return AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: height,
            child: Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                border: Border(
                  top: BorderSide(
                    color: AppColors.borderBackgroundColor,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color(0xff000000).withAlpha(6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(child: Expansion(products: productDiscount)),
                  AppDividerHorizontal(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Container(
                          height: 32,
                          padding: EdgeInsets.only(bottom: 8),

                          child: _labelInfo(
                            Text(
                              TextData.total,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.labelColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              AppHelper.vietNamMoneyFormat(
                                state.cart!.subPrice,
                              ),
                              style: TextStyle(
                                color: AppColors.dataTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        AppDividerHorizontal(),
                        SizedBox(height: 4),
                        _labelInfo(
                          Text(
                            TextData.subTotal,
                            style: TextStyle(color: AppColors.labelColor),
                          ),
                          Text(
                            AppHelper.vietNamMoneyFormat(
                              state.cart!.totalPrice,
                            ),
                            style: TextStyle(color: AppColors.dataTextColor),
                          ),
                        ),
                        SizedBox(height: 4),
                        _labelInfo(
                          Text(TextData.discount, style: TextStyle(color: AppColors.labelColor),),
                          Text(
                            "- ${AppHelper.vietNamMoneyFormat(state.cart!.totalPrice - state.cart!.subPrice)}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 4),
                        _labelInfo(
                          Text(TextData.amount, style: TextStyle(color: AppColors.labelColor),),
                          Text(state.cart!.amountProducts.toString(), style: TextStyle(color: AppColors.dataTextColor),),
                        ),
                        SizedBox(height: 10),
                        _orderButton(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _labelInfo(Text label, Text data) {
    return Row(
      children: [
        SizedBox(width: 120, child: label),
        SizedBox(width: 8),
        Expanded(
          child: Container(alignment: Alignment.centerRight, child: data),
        ),
      ],
    );
  }

  Widget _orderButton() {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(backgroundColor: AppColors.primaryColor),
      onPressed: () {},
      child: Text(
        TextData.order,
        style: TextStyle(color: AppColors.backgroundColor),
      ),
    );
  }
}
