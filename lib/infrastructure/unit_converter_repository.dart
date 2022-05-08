import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/unit.dart';

abstract class UnitConverterRepository {
  Future<Iterable<Dimension>> getAllDimensions();
  Future<Iterable<Unit>> getAllUnitsForDimension(Dimension dimension);
}
