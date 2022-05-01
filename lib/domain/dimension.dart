class Dimension {
  final String name;
  final String baseUnitName;

  Dimension(this.name, this.baseUnitName);

  // Equality stuff (because Dart uses instance equality instead of value equality)
  @override
  bool operator ==(Object other) =>
      other is Dimension &&
      name == other.name &&
      baseUnitName == other.baseUnitName;

  @override
  int get hashCode => name.hashCode ^ baseUnitName.hashCode;
}
