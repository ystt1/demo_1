import 'package:demo_1/common/constants/app_theme.dart';
import 'package:demo_1/genarate_route.dart';
import 'package:demo_1/presentation/products/bloc/category/bloc.dart';
import 'package:demo_1/presentation/products/bloc/category/event.dart';
import 'package:demo_1/presentation/products/bloc/product/bloc.dart';
import 'package:demo_1/presentation/products/bloc/product/event.dart';


import 'package:demo_1/service_locator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            var bloc = CategoryBloc();
            bloc.add(GetCategoryEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            var bloc = ProductBloc();
            bloc.add(ChangeCategoryEvent(idCategory: 0));
            return bloc;
          },
        ),
      ],
      child: MaterialApp(
        initialRoute: ('/'),
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
