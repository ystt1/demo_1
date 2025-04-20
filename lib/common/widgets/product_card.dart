import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/common/helper/app_helper.dart';
import 'package:demo_1/common/widgets/app_divider_horizontal.dart';
import 'package:demo_1/common/widgets/app_divider_vertical.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/products/widgets/add_voucher_sheet.dart';
import '../constants/enum.dart';

class ProductCard extends StatefulWidget {
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final TextEditingController _amountWholeSaleController =
      TextEditingController();
  final TextEditingController _amountRetailController = TextEditingController();
  bool isEditingRetail = false;
  bool isEditingWholeSale = false;
  final focusNodeRetail = FocusNode();
  final focusNodeWholeSale = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNodeRetail.addListener(() {
      if (!focusNodeRetail.hasFocus) {
        setState(() {
          isEditingRetail = false;
        });
      }
      if (int.tryParse(_amountRetailController.text) != null) {
        context.read<ProductBloc>().add(
          ChangeAmountProductEvent(
            amount:
                int.parse(_amountRetailController.text) -
                (widget.retailAmount ?? 0),
            typeAmountProduct: TypeAmountProduct.retail,
            productId: widget.product.id,
          ),
        );
      }
    });

    focusNodeWholeSale.addListener(() {
      if (!focusNodeWholeSale.hasFocus) {
        setState(() {
          isEditingWholeSale = false;
        });
      }

      if (int.tryParse(_amountWholeSaleController.text) != null) {
        context.read<ProductBloc>().add(
          ChangeAmountProductEvent(
            amount:
            int.parse(_amountWholeSaleController.text) -
                (widget.wholeSaleAmount ?? 0),
            typeAmountProduct: TypeAmountProduct.wholeSale,
            productId: widget.product.id,
          ),
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _amountWholeSaleController.text = widget.wholeSaleAmount.toString();
    _amountRetailController.text = widget.retailAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFFFFFF),
      child: Column(
        children: [
          _property(context),
          Visibility(
            visible: widget.isCheckOutPage ?? true,
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
                widget.product.name,
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
                  border: Border.all(width: 0.5, color: AppColors.secondaryColor),
                ),
                child: Text(
                  "${widget.product.unit} | ${widget.product.volume}",
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
        Expanded(flex: 3, child: _price(TypeAmountProduct.retail, context)),
      ],
    );
  }

  Widget _price(TypeAmountProduct type, BuildContext context) {
    int? amount =
        type == TypeAmountProduct.retail
            ? widget.retailAmount
            : widget.wholeSaleAmount;
    TextEditingController _controller =
        type == TypeAmountProduct.retail
            ? _amountRetailController
            : _amountWholeSaleController;
    bool _isChoosing =
        type == TypeAmountProduct.retail ? isEditingRetail : isEditingWholeSale;
    FocusNode _focus =
        type == TypeAmountProduct.retail ? focusNodeRetail : focusNodeWholeSale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            AppHelper.vietNamMoneyFormat(
              type == TypeAmountProduct.retail
                  ? widget.product.retailPrice
                  : widget.product.wholesalePrice,
            ),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.dataTextColor,
              fontWeight: FontWeight.w500,
            ),
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
                    productId: widget.product.id,
                  ),
                );
              },
              child: _changeAmountButton(Icon(Icons.remove)),
            ),
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 40
                ),
                height: 28,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (type == TypeAmountProduct.retail) {
                        isEditingRetail = true;
                        _controller.text = widget.retailAmount.toString();
                      } else {
                        isEditingWholeSale = true;
                        _controller.text = widget.wholeSaleAmount.toString();
                      }
                    });
                  },
                  child:
                      !_isChoosing
                          ? Text(
                            amount.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  amount! > 0
                                      ? AppColors.dataTextColor
                                      : AppColors.secondaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                          : Container(
                            alignment: Alignment.center,
                            height: 28,
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: TextField(
                              autofocus: true,
                              controller: _controller,
                              focusNode: _focus,
                              onEditingComplete: () {
                                _focus.unfocus();
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                color: AppColors.dataTextColor,
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 2,
                                ),
                              ),
                            ),
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
                    productId: widget.product.id,
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
              widget.moneyVoucher != 0
                  ? "${TextData.discount2} ${widget.moneyVoucher} đ".toString()
                  : (widget.rateVoucher != 0
                      ? "${TextData.discount2} ${widget.rateVoucher}%"
                          .toString()
                      : TextData.addVoucher),
              style: TextStyle(color: AppColors.dataTextColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder:
                    (_) => Container(
                      height: 318,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: AddVoucherSheet(
                        product: widget.product,
                        context: context,
                        moneyVoucher: widget.moneyVoucher!,
                        rateVoucher: widget.rateVoucher!,
                      ),
                    ),
              ).then((_) {
                context.read<ProductBloc>().add(OnCloseSheetEvent());
                return null;
              });
            },
            child: Icon(Icons.navigate_next, size: 24),
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
        border: Border.all(width: 0.5, color: AppColors.secondaryColor),
      ),
      child: icon,
    );
  }
}
