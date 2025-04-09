import 'package:flutter/material.dart';

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});

  @override
  State<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  final TextEditingController _valueController = TextEditingController();

  final List<String> _lengthUnits = ['Meters', 'Kilometers', 'Centimeters'];
  final List<String> _weightUnits = ['Kilograms', 'Grams', 'Pounds'];

  String _selectedCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double? _convertedValue;

  void _convert() {
    final input = double.tryParse(_valueController.text);
    if (input == null) return;

    double result = input;

    if (_selectedCategory == 'Length') {
      if (_fromUnit == 'Meters' && _toUnit == 'Kilometers') result = input / 1000;
      else if (_fromUnit == 'Kilometers' && _toUnit == 'Meters') result = input * 1000;
      else if (_fromUnit == 'Centimeters' && _toUnit == 'Meters') result = input / 100;
      else if (_fromUnit == 'Meters' && _toUnit == 'Centimeters') result = input * 100;
      else if (_fromUnit == 'Centimeters' && _toUnit == 'Kilometers') result = input / 100000;
      else if (_fromUnit == 'Kilometers' && _toUnit == 'Centimeters') result = input * 100000;
      else result = input;
    } else {
      if (_fromUnit == 'Kilograms' && _toUnit == 'Grams') result = input * 1000;
      else if (_fromUnit == 'Grams' && _toUnit == 'Kilograms') result = input / 1000;
      else if (_fromUnit == 'Kilograms' && _toUnit == 'Pounds') result = input * 2.20462;
      else if (_fromUnit == 'Pounds' && _toUnit == 'Kilograms') result = input / 2.20462;
      else if (_fromUnit == 'Grams' && _toUnit == 'Pounds') result = input / 453.592;
      else if (_fromUnit == 'Pounds' && _toUnit == 'Grams') result = input * 453.592;
      else result = input;
    }

    setState(() {
      _convertedValue = result;
    });
  }

  List<String> get _unitOptions =>
      _selectedCategory == 'Length' ? _lengthUnits : _weightUnits;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: 'Length', child: Text('Length')),
                DropdownMenuItem(value: 'Weight', child: Text('Weight')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _fromUnit = _unitOptions[0];
                  _toUnit = _unitOptions[1];
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromUnit,
                    isExpanded: true,
                    items: _unitOptions
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (value) => setState(() => _fromUnit = value!),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.swap_horiz),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toUnit,
                    isExpanded: true,
                    items: _unitOptions
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (value) => setState(() => _toUnit = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            if (_convertedValue != null)
              Text(
                'Converted Value: ${_convertedValue!.toStringAsFixed(2)} $_toUnit',
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
