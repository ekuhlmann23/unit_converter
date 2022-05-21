import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/i_unit_converter_repository.dart';
import 'package:unit_converter/domain/unit.dart';
import 'package:unit_converter/domain/unit_converter_service.dart';

class UnitConverterUseCase {
  final UnitConverterService unitConverterService;
  final IUnitConverterRepository unitConverterRepository;

  UnitConverterUseCase(this.unitConverterService, this.unitConverterRepository);

  double convertValue(
      Unit baseUnit, Unit targetUnit, double scalarValueInBaseUnit) {
    return unitConverterService.convertValue(
        baseUnit, targetUnit, scalarValueInBaseUnit);
  }

  Future<Iterable<Dimension>> getAllDimensions() {
    return unitConverterRepository.getAllDimensions();
  }

  Future<Iterable<Unit>> getAllUnits() {
    return unitConverterRepository.getAllUnits();
  }

  Iterable<Unit> filterUnitsForADimension(
      Iterable<Unit> allUnits, Dimension? targetDimension) {
    return allUnits.where((unit) => unit.dimension == targetDimension);
  }
}
