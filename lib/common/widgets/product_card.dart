import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/common/helper/app_helper.dart';
import 'package:demo_1/common/widgets/app_divider_horizontal.dart';
import 'package:demo_1/common/widgets/app_divider_vertical.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/domain/products/entity/product_in_cart_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/products/widgets/add_voucher_sheet.dart';
import '../constants/enum.dart';

class ProductCard extends StatelessWidget {
  final bool? isCheckOutPage;
  final ProductEntity product;
  final int? wholeSaleAmount;
  final int? retailAmount;
  final double? moneyVoucher;
  final double? rateVoucher;

  const ProductCard({
    super.key,
    this.isCheckOutPage,
    required this.product,
    required this.wholeSaleAmount,
    required this.retailAmount,
    this.moneyVoucher,
    this.rateVoucher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      color: Color(0xffFFFFFF),
      child: Column(
        children: [
          _property(context),
          Visibility(
            visible: isCheckOutPage ?? true,
            child: Column(
              children: [
                SizedBox(height: 8),
                AppDividerHorizontal(),
                SizedBox(height: 8),
                _addVoucher(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _property(BuildContext context) {
    return Row(

      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.dataTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondBackgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1, color: Color(0xffA1A1AA)),
                ),
                child: Text(
                  "${product.unit} | ${product.volume}",
                  style: TextStyle(
                    color: AppColors.labelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        SizedBox(height: 44, child: AppDividerVertical()),
        SizedBox(width: 8),
        Expanded(flex: 3, child: _price(TypeAmountProduct.wholeSale, context)),
        SizedBox(width: 8),
        SizedBox(height: 44, child: AppDividerVertical()),
        SizedBox(width: 4),
        Expanded(flex: 3,child: _price(TypeAmountProduct.retail, context)),
      ],
    );
  }

  Widget _price(TypeAmountProduct type, BuildContext context) {
    int? amount =
        type == TypeAmountProduct.retail ? retailAmount : wholeSaleAmount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppHelper.vietNamMoneyFormat(type == TypeAmountProduct.retail
                  ? product.retailPrice
                  : product.wholesalePrice)
              ,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.dataTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                context.read<ProductBloc>().add(
                  ChangeAmountProductEvent(
                    amount: -1,
                    typeAmountProduct: type,
                    productId: product.id,
                  ),
                );
              },
              child: _changeAmountButton(Icon(Icons.remove)),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 40),
              height: 28,
              child: Center(
                child: Text(
                  amount.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        amount! > 0
                            ? AppColors.dataTextColor
                            : AppColors.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<ProductBloc>().add(
                  ChangeAmountProductEvent(
                    amount: 1,
                    typeAmountProduct: type,
                    productId: product.id,
                  ),
                );
              },
              child: _changeAmountButton(Icon(Icons.add)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _addVoucher(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: AppColors.backgroundColor.withAlpha(80),
            child: Text(
              moneyVoucher != 0
                  ? "${TextData.discount2} $moneyVoucher đ".toString()
                  : (rateVoucher != 0
                      ? "${TextData.discount2} $rateVoucher%".toString()
                      : TextData.addVoucher),
              style: TextStyle(color: AppColors.dataTextColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => Container(
                      height: 318,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: AddVoucherSheet(
                        product: product,
                        context: context,
                        moneyVoucher: moneyVoucher!,
                        rateVoucher: rateVoucher!,
                      ),
                    ),
              ).then((_) {
                context.read<ProductBloc>().add(OnCloseSheetEvent());
                return null;
              });
            },
            child: Icon(Icons.navigate_next,size: 24,),
          ),
        ],
      ),
    );
  }

  Widget _changeAmountButton(Icon icon) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: AppColors.secondBackgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 0.5, color: Color(0xffA1A1AA)),
      ),
      child: icon,
    );
  }
}
