import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/enum.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    IconData iconDirection= direction == SortDirection.asc
        ? CupertinoIcons.down_arrow
        : CupertinoIcons.up_arrow;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
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
              Text(TextData.product),
              Visibility(
                visible:type!=null && type == TypeSortProduct.name,
                child: Icon(
                  iconDirection
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<ProductBloc>().add(
              OnSortProductEvent(
                type: TypeSortProduct.wholeSalePrice,
                isForCart: isInCart,
              ),
            );
          },
          child: Row(
            children: [
              Text(TextData.wholesalePrice),
              Visibility(
                visible:type!=null && type == TypeSortProduct.wholeSalePrice,
                child: Icon(
                    iconDirection
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<ProductBloc>().add(
              OnSortProductEvent(
                type: TypeSortProduct.retailPrice,
                isForCart: isInCart,
              ),
            );
          },
          child: Row(
            children: [
              Text(TextData.retailPrice),
              Visibility(
                visible:type!=null && type == TypeSortProduct.retailPrice,
                child: Icon(
                    iconDirection
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
