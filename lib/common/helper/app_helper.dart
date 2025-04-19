import 'package:intl/intl.dart';

class AppHelper{
  static String vietNamMoneyFormat(double money)
  {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    String formatted = formatter.format(money.round());
    return formatted;
  }
}