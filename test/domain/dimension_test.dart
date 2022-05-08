import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/domain/dimension.dart';

void main() {
  test('Equality', () {
    final dimension = Dimension('Length', 'Meter');
    final dimension2 = Dimension('Length', 'Meter');
    expect(dimension, dimension2);
  });

  test('HashCode', () {
    final dimension = Dimension('Length', 'Meter');
    final dimension2 = Dimension('Length', 'Meter');
    expect(dimension.hashCode, dimension2.hashCode);
  });

  test('ToString', () {
    final dimension = Dimension('Length', 'Meter');
    expect(dimension.toString(), 'Length');
  });

  test('ToJson', () {
    final dimension = Dimension('Length', 'Meter');
    final expectedResult = {'name': 'Length', 'baseUnitName': 'Meter'};
    expect(dimension.toJson(), expectedResult);
  });

  test('FromJson', () {
    final json = {'name': 'Length', 'baseUnitName': 'Meter'};
    final expectedDimension = Dimension('Length', 'Meter');
    expect(Dimension.fromJson(json), expectedDimension);
  });
}
