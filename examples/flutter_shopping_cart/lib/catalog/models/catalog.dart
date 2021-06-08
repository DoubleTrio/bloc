import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';

@immutable
class Catalog extends Equatable {
  Catalog({required this.itemNames});

  final List<String> itemNames;

  Item getById(int id) => Item(id, itemNames[id % itemNames.length]);

  Item getByPosition(int position) => getById(position);

  @override
  List<Object> get props => [itemNames];
}
