import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/unit.dart';

void main() {
  test('Equality', () {
    final dimension = Dimension('Length', 'Meter');
    final unit = Unit(dimension, 'Meter', 1.0);
    final unit2 = Unit(dimension, 'Meter', 1.0);
    expect(unit, unit2);
  });

  test('HashCode', () {
    final dimension = Dimension('Length', 'Meter');
    final unit = Unit(dimension, 'Meter', 1.0);
    final unit2 = Unit(dimension, 'Meter', 1.0);
    expect(unit.hashCode, unit2.hashCode);
  });

  test('ToString', () {
    final dimension = Dimension('Length', 'Meter');
    final unit = Unit(dimension, 'Meter', 1.0);
    expect(unit.toString(), 'Meter (1.0)');
  });

  test('ToJson', () {
    final dimension = Dimension('Length', 'Meter');
    final unit = Unit(dimension, 'Meter', 1.0);
    final expectedResult = {
      'dimension': {'name': 'Length', 'baseUnitName': 'Meter'},
      'name': 'Meter',
      'conversionFactorToBaseUnit': 1.0,
    };
    expect(unit.toJson(), expectedResult);
  });

  test('FromJson', () {
    final json = {
      'dimension': {'name': 'Length', 'baseUnitName': 'Meter'},
      'name': 'Meter',
      'conversionFactorToBaseUnit': 1.0,
    };
    final dimension = Dimension('Length', 'Meter');
    final expectedResult = Unit(dimension, 'Meter', 1.0);
    expect(Unit.fromJson(json), expectedResult);
  });
}
