import 'package:demo_1/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDividerVertical extends StatelessWidget {
  final double? width;
  const AppDividerVertical({super.key,this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: width??1,
      color: AppColors.secondBackgroundColor,
    );
  }
}
