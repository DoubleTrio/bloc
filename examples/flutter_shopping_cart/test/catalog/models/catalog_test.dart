import 'package:flutter_shopping_cart/catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Catalog', () {
    final mockItemNames = ['Orange Juice', 'Milk', 'Macaroons', 'Cookies'];

    test('supports value comparison', () async {
      expect(
        Catalog(itemNames: mockItemNames),
        Catalog(itemNames: mockItemNames),
      );
    });

    test('gets correct item by id', () async {
      expect(
        Catalog(itemNames: mockItemNames).getById(1),
        Item(1, 'Milk'),
      );
    });

    test('gets correct item by id', () async {
      expect(
        Catalog(itemNames: mockItemNames).getByPosition(2),
        Item(2, 'Macaroons'),
      );
    });
  });
}
