import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/unit.dart';

abstract class IUnitConverterRepository {
  Future<Iterable<Dimension>> getAllDimensions();
  Future<Iterable<Unit>> getAllUnits();
  Future<Iterable<Unit>> getAllUnitsForDimension(Dimension dimension);
}
