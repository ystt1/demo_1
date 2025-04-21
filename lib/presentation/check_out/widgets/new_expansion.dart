import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../assets/text_data.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/constants/enum.dart';
import '../../../common/widgets/app_divider_horizontal.dart';
import '../../../common/widgets/product_labels.dart';
import '../../../domain/products/entity/product_in_cart_entity.dart';
import '../../products/bloc/product/bloc.dart';
import '../../products/bloc/product/state.dart';
import '../bloc/expansion/bloc.dart';
import '../bloc/expansion/event.dart';

class NewExpansion extends StatefulWidget {
  final bool isExpanded;
  final List<ProductInCartEntity> products;

  const NewExpansion({
    super.key,
    required this.products,
    required this.isExpanded,
  });

  @override
  State<NewExpansion> createState() => _NewExpansionState();
}

class _NewExpansionState extends State<NewExpansion> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        childrenPadding: EdgeInsets.zero,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        trailing: SizedBox(
          height: 28,
          child: Builder(
            builder: (context) {
              return CircleAvatar(
                backgroundColor: AppColors.secondBackgroundColor,
                radius: 14,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: _isExpanded ? 3 : 1,
                    child: Icon(CupertinoIcons.back),
                  ),
                ),
              );
            },
          ),
        ),
        title: Container(height: 28, child: _expansionHeader()),
        children:
            widget.products.isNotEmpty
                ? [
                  Container(height: 1, color: AppColors.secondBackgroundColor),
                  SizedBox(height: 8),
                  _infoLabel(context),
                  _listDiscountProduct(context),
                  SizedBox(height: 8),
                ]
                : [SizedBox()],
      ),
    );
  }

  Widget _expansionHeader() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  TextData.discountProduct,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Container(
                  width: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Color(0xffDEFCE9),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.products.length} SP',
                      style: TextStyle(
                        color: Color(0xff114C29),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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

  Widget _infoLabel(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    TextData.product,
                    style: TextStyle(color: Color(0xff71717A), fontSize: 12),
                  ),
                ),

                SizedBox(width: 8),
                Text(
                  TextData.wholesaleAmount,
                  style: TextStyle(color: Color(0xff71717A), fontSize: 12),
                ),
              ],
            ),
          ),

          SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(minWidth: 119),
            alignment: Alignment.centerRight,
            child: Text(
              TextData.retailAmount,
              style: TextStyle(color: Color(0xff71717A), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listDiscountProduct(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 22 * 4 + 16),
      child: SingleChildScrollView(
        child: Column(
          children:
              widget.products
                  .map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _productData(product),
                    ),
                  )
                  .toList(),
        ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.dataTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 119),
            alignment: Alignment.centerRight,
            child: Text(
              amountWholesale,
              style: TextStyle(fontSize: 14, color: AppColors.dataTextColor),
            ),
          ),
          SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 119),
            alignment: Alignment.centerRight,
            child: Text(
              amountRetail,
              style: TextStyle(fontSize: 14, color: AppColors.dataTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
