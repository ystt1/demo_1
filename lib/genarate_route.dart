import 'package:demo_1/presentation/check_out/pages/checkout_page.dart';
import 'package:demo_1/presentation/products/pages/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/product':
        return MaterialPageRoute(builder: (_) => ProductPage());
      case '/check-out':
        return MaterialPageRoute(builder: (_) => CheckoutPage());
      default:
        return MaterialPageRoute(builder: (_) => ProductPage());
    }
  }
}
