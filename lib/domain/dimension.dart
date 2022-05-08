class Dimension {
  final String name;
  final String baseUnitName;

  Dimension(this.name, this.baseUnitName);

  // Json serialization / deserialization
  factory Dimension.fromJson(Map<String, dynamic> json) =>
      Dimension(json['name'] as String, json['baseUnitName'] as String);

  Map<String, dynamic> toJson() => {'name': name, 'baseUnitName': baseUnitName};

  @override
  String toString() => name;

  // Equality stuff (because Dart uses instance equality instead of value equality)
  @override
  bool operator ==(Object other) =>
      other is Dimension &&
      name == other.name &&
      baseUnitName == other.baseUnitName;

  @override
  int get hashCode => name.hashCode ^ baseUnitName.hashCode;
}
