import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/i_unit_converter_repository.dart';
import 'package:unit_converter/domain/unit.dart';

class FirebaseUnitConverterRepository implements IUnitConverterRepository {
  final CollectionReference<Unit> _unitsCollection;
  final CollectionReference<Dimension> _dimensionsCollection;

  FirebaseUnitConverterRepository(FirebaseFirestore firestore)
      : _unitsCollection = firestore.collection('units').withConverter<Unit>(
              fromFirestore: (doc, options) => Unit.fromJson(doc.data()!),
              toFirestore: (unit, options) => unit.toJson(),
            ),
        _dimensionsCollection = firestore
            .collection('dimensions')
            .withConverter<Dimension>(
              fromFirestore: (doc, options) => Dimension.fromJson(doc.data()!),
              toFirestore: (dimension, options) => dimension.toJson(),
            );

  @override
  Future<Iterable<Dimension>> getAllDimensions() async {
    final results = await _dimensionsCollection.get();
    return results.docs.map((snapshot) => snapshot.data());
  }

  @override
  Future<Iterable<Unit>> getAllUnits() async {
    final results = await _unitsCollection.get();
    return results.docs.map((snapshot) => snapshot.data());
  }

  @override
  Future<Iterable<Unit>> getAllUnitsForDimension(Dimension dimension) async {
    final results = await _unitsCollection
        .where('dimension', isEqualTo: dimension.toJson())
        .get();
    return results.docs.map((snapshot) => snapshot.data());
  }
}
