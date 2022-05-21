import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/unit.dart';
import 'package:unit_converter/domain/unit_converter_service.dart';

void main() {
  final category = Dimension('Weight', 'gram');
  final gram = Unit(category, 'Gram', 'g', 1.0);
  final kilogram = Unit(category, 'Kilogram', 'kg', 1000.0);
  final pound = Unit(category, 'Pound', 'lb', 453.59237);
  final ukTonne = Unit(category, 'UK Tonne', 't', 1016046.9088);

  final unitConversionService = UnitConverterService();

  test('Value is not changed when converting to the same unit', () {
    const value = 3.0;
    const expectedResult = 3.0;

    final actualResult = unitConversionService.convertValue(gram, gram, value);

    expect(actualResult, expectedResult,
        reason: 'Conversion to the same unit does not change the value');
  });

  test('Conversion works as expected when converting to a bigger SI unit.', () {
    const value = 3.0;
    const expectedResult = 0.003;

    final actualResult =
        unitConversionService.convertValue(gram, kilogram, value);

    expect(actualResult, expectedResult,
        reason: 'Conversion to the same unit does not change the value');
  });

  test('Conversion works as expected when converting to a smaller SI unit.',
      () {
    const value = 3.0;
    const expectedResult = 3000.0;

    final actualResult =
        unitConversionService.convertValue(kilogram, gram, value);

    expect(actualResult, expectedResult,
        reason: 'Conversion to the same unit does not change the value');
  });

  test(
      'Conversion works as expected when converting from the base unit to a different unit.',
      () {
    const value = 3.0;
    const expectedResult = 0.00661387;

    final actualResult = unitConversionService.convertValue(gram, pound, value);

    expect(
        actualResult, closeTo(expectedResult, UnitConverterService.errorDelta),
        reason: 'Conversion yields the correct result.');
  });

  test(
      'Conversion works as expected when converting from a different unit to the base.',
      () {
    const value = 3.0;
    const expectedResult = 1360.77711;

    final actualResult = unitConversionService.convertValue(pound, gram, value);

    expect(
        actualResult, closeTo(expectedResult, UnitConverterService.errorDelta),
        reason: 'Conversion yields the correct result.');
  });

  test(
      'Conversion works as expected when converting from a different unit to the base.',
      () {
    const value = 3.0;
    const expectedResult = 6720;

    final actualResult =
        unitConversionService.convertValue(ukTonne, pound, value);

    expect(
        actualResult, closeTo(expectedResult, UnitConverterService.errorDelta),
        reason: 'Conversion yields the correct result.');
  });
}
