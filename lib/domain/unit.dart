import 'package:unit_converter/domain/dimension.dart';

class Unit {
  final Dimension dimension;
  final double conversionFactorToBaseUnit;
  final String name;

  Unit(this.dimension, this.name, this.conversionFactorToBaseUnit);

  // Json serialization / deserialization
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        Dimension.fromJson(json['dimension']),
        json['name'] as String,
        (json['conversionFactorToBaseUnit'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'dimension': dimension.toJson(),
        'name': name,
        'conversionFactorToBaseUnit': conversionFactorToBaseUnit,
      };

  @override
  String toString() => '$name ($conversionFactorToBaseUnit)';

  // Equality stuff (because Dart uses instance equality instead of value equality)
  @override
  bool operator ==(Object other) =>
      other is Unit &&
      name == other.name &&
      dimension == other.dimension &&
      conversionFactorToBaseUnit == other.conversionFactorToBaseUnit;

  @override
  int get hashCode =>
      name.hashCode ^ conversionFactorToBaseUnit.hashCode ^ dimension.hashCode;
}
