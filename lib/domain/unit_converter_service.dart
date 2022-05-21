import 'package:unit_converter/domain/domain_exception.dart';
import 'package:unit_converter/domain/unit.dart';

class UnitConverterService {
  static const errorDelta = 0.0001;

  double convertValue(Unit baseUnit, Unit targetUnit, double valueToConvert) {
    if (baseUnit.dimension != targetUnit.dimension) {
      throw DomainError('Cannot convert between units of different categories');
    }

    double conversionFactorFromBaseToTarget =
        baseUnit.conversionFactorToDimensionBase /
            targetUnit.conversionFactorToDimensionBase;

    return valueToConvert * conversionFactorFromBaseToTarget;
  }
}
