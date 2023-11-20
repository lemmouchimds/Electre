
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ResultsScreen extends StatelessWidget {
  final List<Tuple2<String, String>> results;

  const ResultsScreen({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text(result.item1),
            trailing: Icon(Icons.arrow_forward),
            subtitle: Text(result.item2),
          );
        },
      ),
    );
  }
}
