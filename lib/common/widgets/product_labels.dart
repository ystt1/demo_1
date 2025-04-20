import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/enum.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';

class ProductLabels extends StatelessWidget {
  final TypeSortProduct? type;
  final SortDirection? direction;
  final bool isInCart;

  const ProductLabels({
    super.key,
    this.type,
    this.direction,
    required this.isInCart,
  });

  @override
  Widget build(BuildContext context) {
    Icon icon=Icon(direction == SortDirection.asc
        ?  CupertinoIcons.down_arrow
        : CupertinoIcons.up_arrow,color:AppColors.labelColor ,size: 12,);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              context.read<ProductBloc>().add(
                OnSortProductEvent(
                  type: TypeSortProduct.name,
                  isForCart: isInCart,
                ),
              );
            },
            child: Row(
              children: [
                Text(TextData.product,style: TextStyle(
                  fontSize: 12,
                  color: AppColors.labelColor,
                  fontWeight: FontWeight.w500,
                ),),
                Visibility(
                  visible:type!=null && type == TypeSortProduct.name,
                  child: icon,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              context.read<ProductBloc>().add(
                OnSortProductEvent(
                  type: TypeSortProduct.wholeSalePrice,
                  isForCart: isInCart,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(TextData.wholesalePrice,style: TextStyle(
                  fontSize: 12,
                  color: AppColors.labelColor,
                  fontWeight: FontWeight.w500,
                )),
                Visibility(
                  visible:type!=null && type == TypeSortProduct.wholeSalePrice,
                  child: icon
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              context.read<ProductBloc>().add(
                OnSortProductEvent(
                  type: TypeSortProduct.retailPrice,
                  isForCart: isInCart,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(TextData.retailPrice,style: TextStyle(
                  fontSize: 12,
                  color: AppColors.labelColor,
                  fontWeight: FontWeight.w500,
                )),
                Visibility(
                  visible:type!=null && type == TypeSortProduct.retailPrice,
                  child: icon
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
