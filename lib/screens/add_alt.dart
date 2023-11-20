import 'package:electre/classes/alt.dart';
import 'package:electre/classes/criteria.dart';
import 'package:flutter/material.dart';

class AddAlternativeScreen extends StatefulWidget {
  final List<Criteria> criteriaList;

  const AddAlternativeScreen({super.key, required this.criteriaList});

  @override
  _AddAlternativeScreenState createState() => _AddAlternativeScreenState();
}

class _AddAlternativeScreenState extends State<AddAlternativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _alternativeNameController = TextEditingController();
  final Map<String, double> _criteriaValues = {};

  @override
  void dispose() {
    _alternativeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Alternative'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _alternativeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Alternative Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an alternative name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ...widget.criteriaList.map((criteria) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(criteria.criteria),
                      Slider(
                        value: _criteriaValues[criteria.criteria] ?? 0.0,
                        min: 0.0,
                        max: 10.0,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _criteriaValues[criteria.criteria] = value;
                          });
                        },
                      ),
                      Text('${_criteriaValues[criteria.criteria] ?? 0.0}'),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Save the alternative and criteria values
            final alternativeName = _alternativeNameController.text;
            final criteriaValues = _criteriaValues;
            final alternative = Alternative(
              name: alternativeName,
              criteriaValues: criteriaValues,
            );
            Navigator.pop(context, alternative);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
