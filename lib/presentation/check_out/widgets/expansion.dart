import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/domain/products/entity/product_in_cart_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expansion/bloc.dart';
import '../bloc/expansion/event.dart';

class Expansion extends StatelessWidget {
  final List<ProductInCartEntity> products;

  const Expansion({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _expansionHeader(),
          AnimatedSize(
            duration: Duration(milliseconds: 400),
            child:
                context.watch<ExpansionBloc>().state
                    ? Column(
                      children: [
                        SizedBox(height: 8),
                        Container(height: 1,color: AppColors.secondBackgroundColor),
                        SizedBox(height: 8),
                        _infoLabel(context),
                        _listDiscountProduct(context),
                        SizedBox(height: 12),
                      ],
                    )
                    : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _expansionHeader() {
    return Container(
      height: 28+12,
      padding: EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(TextData.discountProduct,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                SizedBox(width: 8),
                Container(
                  width: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Color(0xffDEFCE9),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Center(child: Text('${products.length} SP',style: TextStyle(color: Color(0xff114C29),fontSize: 12,fontWeight: FontWeight.w500),)),
                ),
              ],
            ),
          ),
          SizedBox(width: 4),
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  if (products.isNotEmpty) {
                    context.read<ExpansionBloc>().add(ChangeExpansionEvent());
                  }
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.secondBackgroundColor,
                  radius: 14,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: context.watch<ExpansionBloc>().state ? 3 : 1,
                      child: Icon(CupertinoIcons.back),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoLabel(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96,
            child: Text(
              TextData.product,
              style: TextStyle(color: Color(0xff71717A), fontSize: 12),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      TextData.wholesaleAmount,
                      style: TextStyle(color: Color(0xff71717A), fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      TextData.retailAmount,
                      style: TextStyle(color: Color(0xff71717A), fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listDiscountProduct(BuildContext context) {

    return Container(

      constraints: BoxConstraints(maxHeight:(22 * 4 + 4 *(4 - 1)) as double, ),

      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) {
          return _productData(products[index]);
        },
        separatorBuilder: (_, index) => SizedBox(height: 4),
        itemCount: products.length,
      ),
    );
  }

  Widget _productData(ProductInCartEntity product) {
    String name = product.product.name;
    String amountWholesale =
        product.amountWholeSale != 0
            ? "x${product.amountWholeSale!.toString()}"
            : "";
    String amountRetail =
        product.amountRetail != 0 ? "x${product.amountRetail!.toString()}" : "";
    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96,
            child: Text(
              name,
              style: TextStyle(fontSize: 12, color: AppColors.dataTextColor,fontWeight: FontWeight.w500),
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      amountWholesale,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.dataTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      amountRetail,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.dataTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
