import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/unit.dart';
import 'package:unit_converter/domain/unit_conversion_service.dart';
import 'package:unit_converter/infrastructure/unit_converter_repository.dart';

class UnitConverterPage extends StatefulWidget {
  final UnitConverterRepository _unitConverterRepository;
  final UnitConversionService _unitConversionService;

  const UnitConverterPage({
    Key? key,
    required UnitConverterRepository unitConverterRepository,
    required UnitConversionService unitConversionService,
  })  : _unitConverterRepository = unitConverterRepository,
        _unitConversionService = unitConversionService,
        super(key: key);

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  _UnitConverterPageState()
      : isLoading = true,
        dimensions = [],
        units = [];

  bool isLoading;
  Iterable<Dimension> dimensions;
  Iterable<Unit> units;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final dimensionResults =
        await widget._unitConverterRepository.getAllDimensions();
    setState(() {
      dimensions = dimensionResults;
    });
    if (dimensions.isNotEmpty) {
      final unitResults = await widget._unitConverterRepository
          .getAllUnitsForDimension(dimensions.first);
      setState(() {
        units = unitResults;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? const _LoadingWidget()
              : _UnitConverterWidget(
                  unitConversionService: widget._unitConversionService,
                  dimensions: dimensions,
                  units: units,
                ),
        ),
      ),
    );
  }
}

class _UnitConverterWidget extends StatefulWidget {
  final Iterable<Dimension> dimensions;
  final Iterable<Unit> units;

  final UnitConversionService unitConversionService;

  const _UnitConverterWidget(
      {Key? key,
      required this.dimensions,
      required this.units,
      required this.unitConversionService})
      : super(key: key);

  @override
  State<_UnitConverterWidget> createState() => _UnitConverterWidgetState();
}

class _UnitConverterWidgetState extends State<_UnitConverterWidget> {
  Dimension? selectedDimension;

  Unit? selectedBaseUnit;
  Unit? selectedTargetUnit;

  double? scalarInBaseUnit;
  double? scalarInTargetUnit;

  Iterable<Unit> get unitsOfDimension =>
      widget.units.where((unit) => unit.dimension == selectedDimension);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.dimensions.isEmpty)
          const Text('No dimensions are available.')
        else ...[
          DropdownButton<Dimension>(
            value: selectedDimension,
            hint: const Text('Dimension'),
            items: widget.dimensions
                .map(
                  (d) => DropdownMenuItem<Dimension>(
                    child: Text(d.name),
                    value: d,
                  ),
                )
                .toList(),
            onChanged: (dimension) {
              setState(() {
                selectedDimension = dimension;
              });
            },
          ),
          const SizedBox(height: 30),
          if (widget.units.isEmpty)
            const Text('No units are available.')
          else if (selectedDimension != null) ...[
            DropdownButton<Unit>(
              value: selectedBaseUnit,
              hint: const Text('Base unit'),
              items: unitsOfDimension
                  .map(
                    (u) => DropdownMenuItem<Unit>(
                      child: Text(u.name),
                      value: u,
                    ),
                  )
                  .toList(),
              onChanged: (unit) {
                setState(() {
                  selectedBaseUnit = unit;
                  convert();
                });
              },
            ),
            const SizedBox(height: 30),
            DropdownButton<Unit>(
              value: selectedTargetUnit,
              hint: const Text('Target unit'),
              items: unitsOfDimension
                  .map(
                    (u) => DropdownMenuItem<Unit>(
                      child: Text(u.name),
                      value: u,
                    ),
                  )
                  .toList(),
              onChanged: (unit) {
                setState(() {
                  selectedTargetUnit = unit;
                  convert();
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              enabled: selectedBaseUnit != null && selectedTargetUnit != null,
              decoration: const InputDecoration(labelText: 'Input'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'\d+([\.]\d*)?')),
              ], // Only numbers can be entered
              onChanged: (value) {
                setState(() {
                  scalarInBaseUnit =
                      value.isNotEmpty ? double.parse(value) : null;
                  convert();
                });
              },
            ),
            const SizedBox(height: 30),
            if (scalarInTargetUnit != null)
              Text('Result is: $scalarInTargetUnit')
          ]
        ]
      ],
    );
  }

  void convert() {
    if (selectedBaseUnit != null &&
        selectedTargetUnit != null &&
        scalarInBaseUnit != null) {
      scalarInTargetUnit = widget.unitConversionService.convertValue(
          selectedBaseUnit!, selectedTargetUnit!, scalarInBaseUnit!);
    } else {
      scalarInTargetUnit = null;
    }
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
