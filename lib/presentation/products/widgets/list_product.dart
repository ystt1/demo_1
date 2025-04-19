import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/domain/products/entity/product_in_cart_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/product_card.dart';
import '../bloc/product/bloc.dart';
import '../bloc/product/state.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (BuildContext context, state) {
          if (state is ProductLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProductFailureState) {
            return Center(child: Text(state.error));
          }
          if (state is ProductSuccessState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (_, index) {
                      if (state.products.isEmpty) {
                        return Center(child: Text(TextData.notFoundProduct));
                      }
                      if (index + 1 <= state.products.length) {
                        int? retailAmount = 0;
                        int? wholeSaleAmount = 0;
                        double? moneyVoucher = 0;
                        double? rateVoucher = 0;
                        if (state.cart != null) {

                          ProductInCartEntity? inCart=state.cart!.products
                              .firstWhere(
                                  (e) =>
                              e.product.id ==
                                  state.products[index].id,
                              orElse:
                                  () => ProductInCartEntity(
                                product: ProductEntity(
                                  id: 0,
                                  name: '',
                                  categoryId: 0,
                                  wholesalePrice: 0,
                                  retailPrice: 0,
                                  unit: '',
                                  volume: '',
                                ),
                              ));
                          retailAmount=inCart.amountRetail;
                          wholeSaleAmount =inCart.amountWholeSale;

                          moneyVoucher =inCart.moneyDiscount;
                          rateVoucher =inCart.rateDiscount!*100;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                          child: ProductCard(
                            product: state.products[index],
                            wholeSaleAmount: wholeSaleAmount,
                            retailAmount: retailAmount,
                            moneyVoucher: moneyVoucher,
                            rateVoucher: rateVoucher,
                          ),
                        );
                      }
                      return (state.isLoadingMore != null &&
                              state.isLoadingMore == true)
                          ? Center(child: CircularProgressIndicator())
                          : ((state.isEnd != null && state.isEnd == true)
                              ? Center(child: Text(TextData.endOfList))
                              : SizedBox());
                    },
                    separatorBuilder: (_, index) => Container(height: 8,color: AppColors.secondBackgroundColor,),
                    itemCount:
                        ((state.isLoadingMore != null &&
                                    state.isLoadingMore == true) ||
                                (state.isEnd != null && state.isEnd == true))
                            ? state.products.length + 1
                            : state.products.length + 1,
                  ),
                ),
              ],
            );
          }
          return Placeholder();
        },
      ),
    );
  }

  _scrollListener() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 20) {
      final ProductState state = context.read<ProductBloc>().state;
      if (state is ProductSuccessState) {
        if (state.isLoadingMore == true || state.isEnd == true) return;
        context.read<ProductBloc>().add(LoadMoreProductEvent());
      }
    }
  }
}
