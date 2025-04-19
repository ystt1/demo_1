import 'package:demo_1/assets/text_data.dart';
import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/domain/products/entity/product_entity.dart';
import 'package:demo_1/domain/products/entity/product_in_cart_entity.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:demo_1/presentation/products/bloc/product/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/enum.dart';
import '../../../common/widgets/app_divider_horizontal.dart';

class AddVoucherSheet extends StatefulWidget {
  final ProductEntity product;
  final BuildContext context;
  final double rateVoucher;
  final double moneyVoucher;
  const AddVoucherSheet({
    super.key,
    required this.product,
    required this.context,  required this.rateVoucher, required this.moneyVoucher,
  });

  @override
  State<AddVoucherSheet> createState() => _AddVoucherSheetState();
}

class _AddVoucherSheetState extends State<AddVoucherSheet> {

  TextEditingController _moneyDiscountController = TextEditingController();
  TextEditingController _rateDiscountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moneyDiscountController.text=widget.moneyVoucher!=0?widget.moneyVoucher.toString():"";
    _rateDiscountController.text=widget.rateVoucher!=0?widget.rateVoucher.toString():"";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (BuildContext context, ProductState state) {
        if (state is ProductSuccessState) {
          if (state.returnedApplyVoucher == ReturnedApplyVoucher.success) {
            Navigator.of(context).pop();
          }else{
            setState(() {

            });
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: _header(context),
          ),
          AppDividerHorizontal(),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _textFieldLabel(TextData.moneyDiscount),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _textField(
              TextData.enterMoney,
              'đ',
              TypeVoucher.moneyDiscount,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _textFieldLabel(TextData.rateDiscount),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _textField(
              TextData.enterRate,
              '%',
              TypeVoucher.rateDiscount,
            ),
          ),
          Container(
            height: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _returnedError(),
          ),
          AppDividerHorizontal(),

          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_backButton(), _applyButton()],
            ),
          ),
        ],
      ),
    );




  }
  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          TextData.enterVoucher,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 44,
            width: 44,
            alignment: Alignment.centerRight,
            child: Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Widget _textFieldLabel(String label) {
    return Text(label);
  }

  Widget _textField(String hint, String icon, TypeVoucher type) {
    return TextField(
      controller:
      type == TypeVoucher.rateDiscount
          ? _rateDiscountController
          : _moneyDiscountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderBackgroundColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: SizedBox(
          width: 46,
          child: Row(
            children: [
              Container(
                width: 1,
                height: 40,
                color: AppColors.borderBackgroundColor,
              ),
              Expanded(
                child: Center(
                  child: Text(icon, style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 100, minHeight: 46),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(TextData.back),
      ),
    );
  }

  Widget _applyButton() {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 227, minHeight: 46),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          widget.context.read<ProductBloc>().add(
            ApplyVoucherProductEvent(
              productId: widget.product.id,
              moneyDiscount:
              double.tryParse(_moneyDiscountController.text) ?? 0,
              rateDiscount: double.tryParse(_rateDiscountController.text) ?? 0,
            ),
          );
        },
        child: Text(TextData.apply, style: TextStyle(color: Colors.white)),
      ),
    );
  }


  Widget _returnedError()
  {
    return Visibility(
      visible:
      (widget.context.watch<ProductBloc>().state as ProductSuccessState)
          .returnedApplyVoucher !=
          null,
      child: Text(
        (widget.context.watch<ProductBloc>().state as ProductSuccessState)
            .returnedApplyVoucher ==
            ReturnedApplyVoucher.error1
            ? TextData.applyVoucherError1
            : ((widget.context.watch<ProductBloc>().state
        as ProductSuccessState)
            .returnedApplyVoucher ==
            ReturnedApplyVoucher.error2
            ? TextData.applyVoucherError2
            : ((widget.context.watch<ProductBloc>().state
        as ProductSuccessState)
            .returnedApplyVoucher ==
            ReturnedApplyVoucher.error3
            ? TextData.applyVoucherError3
            : "")),
        style: TextStyle(color: Colors.red),
      ),
    );
  }

}
