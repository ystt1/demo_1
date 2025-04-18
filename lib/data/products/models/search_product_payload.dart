import 'package:demo_1/common/constants/enum.dart';

class SearchProductPayload {
  final int idCategory;
  final String name;
  final int index;
  final TypeSortProduct? sort;
  final SortDirection? direction;

  SearchProductPayload({
    this.direction,
    this.sort,
    required this.idCategory,
    required this.name,
    required this.index,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCategory': this.idCategory,
      'name': this.name,
      'index': this.index,
    };
  }

  SearchProductPayload copyWith({
    int? idCategory,
    String? name,
    int? index,
    TypeSortProduct? type,
    SortDirection? direction,
  }) {
    return SearchProductPayload(
      idCategory: idCategory ?? this.idCategory,
      name: name ?? this.name,
      index: index ?? this.index,
      sort: type ?? this.sort,
      direction: direction ?? this.direction,
    );
  }
}
