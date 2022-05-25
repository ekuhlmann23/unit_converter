import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_converter/application/unit_converter_use_case.dart';
import 'package:unit_converter/domain/dimension.dart';
import 'package:unit_converter/domain/unit.dart';

class UnitConverterPage extends StatefulWidget {
  final UnitConverterUseCase _unitConverterUseCase;

  const UnitConverterPage({required UnitConverterUseCase useCase, Key? key})
      : _unitConverterUseCase = useCase,
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
        await widget._unitConverterUseCase.getAllDimensions();
    setState(() {
      dimensions = dimensionResults;
    });
    if (dimensions.isNotEmpty) {
      final unitResults = await widget._unitConverterUseCase.getAllUnits();
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
                  useCase: widget._unitConverterUseCase,
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
  final UnitConverterUseCase useCase;

  const _UnitConverterWidget({
    Key? key,
    required this.useCase,
    required this.dimensions,
    required this.units,
  }) : super(key: key);

  @override
  State<_UnitConverterWidget> createState() => _UnitConverterWidgetState();
}

class _UnitConverterWidgetState extends State<_UnitConverterWidget> {
  Dimension? selectedDimension;

  Unit? selectedBaseUnit;
  Unit? selectedTargetUnit;

  double? scalarInBaseUnit;
  double? scalarInTargetUnit;

  Iterable<Unit> unitsOfDimension = [];

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
                unitsOfDimension = widget.useCase
                    .filterUnitsForADimension(widget.units, selectedDimension);
              });
            },
          ),
          const SizedBox(height: 30),
          if (selectedDimension == null)
            const Text('Please select a dimension.')
          else if (selectedDimension != null && unitsOfDimension.isEmpty)
            Text(
                'No units are available for dimension ${selectedDimension?.name}.')
          else ...[
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                enabled: selectedBaseUnit != null && selectedTargetUnit != null,
                decoration: InputDecoration(
                  labelText: 'Input',
                  suffix: selectedBaseUnit != null
                      ? Text(selectedBaseUnit!.symbol)
                      : null,
                ),
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
            ),
            const SizedBox(height: 30),
            if (scalarInTargetUnit != null)
              Text('$scalarInTargetUnit ${selectedTargetUnit!.symbol}')
          ]
        ]
      ],
    );
  }

  void convert() {
    if (selectedBaseUnit != null &&
        selectedTargetUnit != null &&
        scalarInBaseUnit != null) {
      scalarInTargetUnit = widget.useCase.convertValue(
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
