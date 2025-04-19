import 'package:demo_1/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDividerHorizontal extends StatelessWidget {
  final double? height;
  const AppDividerHorizontal({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??2,
      color: AppColors.secondBackgroundColor,
      width: MediaQuery.of(context).size.width
    );
  }
}
