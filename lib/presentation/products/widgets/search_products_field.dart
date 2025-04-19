import 'package:demo_1/common/constants/app_colors.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';
import 'package:flutter/material.dart';
import 'package:demo_1/assets/text_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProductsField extends StatefulWidget {
  const SearchProductsField({super.key});

  @override
  State<SearchProductsField> createState() => _SearchProductsFieldState();
}

class _SearchProductsFieldState extends State<SearchProductsField> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<ProductBloc>().add(
            SearchProductEvent(name: _searchController.text),
          );
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 6,bottom: 6,right: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.borderBackgroundColor),
          ),
          hintText: TextData.searchProduct,
          hintStyle: TextStyle(color: AppColors.secondaryColor,fontSize: 14),
          isDense: true,
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 12,),
              child: Icon(Icons.search,size: 24,),
            ),
          prefixIconConstraints: BoxConstraints(
            maxWidth: 48,
            maxHeight: 24
          )
        ),
      ),
    );
  }
}
