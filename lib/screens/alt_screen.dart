import 'package:electre/classes/alt.dart';
import 'package:electre/classes/criteria.dart';
import 'package:electre/screens/add_alt.dart';
import 'package:electre/screens/results.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class AltScreen extends StatefulWidget {
  final List<Criteria> criteriaList;

  const AltScreen({super.key, required this.criteriaList});
  @override
  _AltScreenState createState() => _AltScreenState();
}

class _AltScreenState extends State<AltScreen> {
  // List<String> alternatives = ['Alternative 1', 'Alternative 2', 'Alternative 3', 'Alternative 4', 'Alternative 5', 'Alternative 6', 'Alternative 7', 'Alternative 8', 'Alternative 9', 'Alternative 10'];

  List<Alternative> alternatives = [];

  void _AddAlt(Alternative alternative) {
    setState(() {
      // var alternatives;
      if (alternative.name.isNotEmpty && !alternatives.contains(alternative)) {
        alternatives.add(alternative);
      }
    });
  }

  // get criteriaList => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alternatives'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(results: _getResults()),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: alternatives.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(alternatives[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.criteriaList.map((criteria) {
                return Text(
                    '${criteria.criteria}: ${alternatives[index].criteriaValues[criteria.criteria]}');
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddAlternativeScreen(
                      criteriaList: widget.criteriaList,
                    )),
          );

          if (result != null) {
            _AddAlt(result);
          }

          // 'result' now holds the 'alternative' returned from the AddAlternativeScreen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Tuple2<String, String>> _getResults() {
    return Alternative.compare(alternatives, widget.criteriaList, 0.6, 0.4);
  }
}
