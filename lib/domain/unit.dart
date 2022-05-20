import 'package:unit_converter/domain/dimension.dart';

class Unit {
  final Dimension dimension;
  final double conversionFactorToDimensionBase;
  final String name;
  final String symbol;

  Unit(this.dimension, this.name, this.symbol,
      this.conversionFactorToDimensionBase);

  // Json serialization / deserialization
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        Dimension.fromJson(json['dimension']),
        json['name'] as String,
        json['symbol'] as String,
        (json['conversionFactorToDimensionBase'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'dimension': dimension.toJson(),
        'name': name,
        'symbol': symbol,
        'conversionFactorToDimensionBase': conversionFactorToDimensionBase,
      };

  @override
  String toString() => '$name ($conversionFactorToDimensionBase)';

  // Equality stuff (because Dart uses instance equality instead of value equality)
  @override
  bool operator ==(Object other) =>
      other is Unit &&
      name == other.name &&
      dimension == other.dimension &&
      conversionFactorToDimensionBase == other.conversionFactorToDimensionBase;

  @override
  int get hashCode =>
      name.hashCode ^
      conversionFactorToDimensionBase.hashCode ^
      dimension.hashCode;
}
