import 'package:unit_converter/domain/dimension.dart';

class Unit {
  final Dimension dimension;
  final double conversionFactorToCategoryBase;
  final String name;

  Unit(this.dimension, this.name, this.conversionFactorToCategoryBase);

  // Equality stuff (because Dart uses instance equality instead of value equality)
  @override
  bool operator ==(Object other) =>
      other is Unit &&
      name == other.name &&
      dimension == other.dimension &&
      conversionFactorToCategoryBase == other.conversionFactorToCategoryBase;

  @override
  int get hashCode =>
      name.hashCode ^
      conversionFactorToCategoryBase.hashCode ^
      dimension.hashCode;
}
