// import 'package:electre/screens/add_alt.dart';
import 'package:electre/screens/alt_screen.dart';
import 'package:flutter/material.dart';
import '../classes/criteria.dart';

class AddCriteriaScreen extends StatefulWidget {
  const AddCriteriaScreen({super.key});

  @override
  _AddCriteriaScreenState createState() => _AddCriteriaScreenState();
}

class _AddCriteriaScreenState extends State<AddCriteriaScreen> {
  final _criteriaList = <Criteria>[];
  // final _criteriaList = <String>[];
  // final _coefficientList = <double>[];

  final _criteriaController = TextEditingController();
  final _coefficientController = TextEditingController();

  @override
  void dispose() {
    _criteriaController.dispose();
    _coefficientController.dispose();
    super.dispose();
  }

  /// Adds a new criteria to the [_criteriaList] and its corresponding coefficient to the [_coefficientList].
  /// If the criteria is already in the list, it will not be added again.
  /// Clears the [_criteriaController] and [_coefficientController] after adding the criteria.
  void _addCriteria() {
    final iter_criteria = _criteriaController.text;
    final coefficient = double.tryParse(_coefficientController.text) ?? 0.0;

    if (iter_criteria.isNotEmpty && !_criteriaList.contains(iter_criteria)) {
      setState(() {
        _criteriaList.add(Criteria(criteria: iter_criteria, coefficient: coefficient));
        // _coefficientList.add(coefficient);
      });

      _criteriaController.clear();
      _coefficientController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Criteria'),
        //a button to go to the next screen
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AltScreen(criteriaList: _criteriaList),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _criteriaList.length,
        itemBuilder: (context, index) {
          final criteria = _criteriaList[index].criteria;
          final coefficient = _criteriaList[index].coefficient;
          // final criteria = _criteriaList[index];
          // final coefficient = _coefficientList[index];

          return ListTile(
            title: Text(criteria),
            subtitle: Text('Coefficient: $coefficient'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Criteria'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _criteriaController,
                      decoration: const InputDecoration(
                        labelText: 'Criteria',
                      ),
                    ),
                    TextField(
                      controller: _coefficientController,
                      decoration: const InputDecoration(
                        labelText: 'Coefficient',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addCriteria();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
