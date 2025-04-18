import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/domain/products/entity/cart_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/app_colors.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (context.read<ProductBloc>().state is ProductSuccessState &&
            (context.read<ProductBloc>().state as ProductSuccessState).cart !=
                null) {
          int amount =
              (context.read<ProductBloc>().state as ProductSuccessState)
                  .cart!
                  .products
                  .length;

          if (amount > 0) {
            Navigator.of(context).pushNamed('/check-out');
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(343, 46),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _cartInfo(context),
      ),
    );
  }

  Widget _cartInfo(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (BuildContext context, ProductState state) {
        if (state is ProductSuccessState) {
          CartEntity cartEntity =
              state.cart ??
              CartEntity(products: [], amountProducts: 0, totalPrice: 0);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: TextData.cartAmount,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    TextSpan(
                      text: cartEntity.amountProducts.toString(),
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Visibility(
                    visible: cartEntity.totalPrice != cartEntity.subPrice,
                    child: Text(
                      cartEntity.totalPrice.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.backgroundColor
                      ),
                    ),
                  ),

                  Text(
                    cartEntity.subPrice.toStringAsFixed(0),
                    style: TextStyle(color: AppColors.backgroundColor),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: TextData.cartAmount,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  TextSpan(
                    text: '0',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),

            Text('0', style: TextStyle(color: Colors.white)),
          ],
        );
      },
    );
  }
}
