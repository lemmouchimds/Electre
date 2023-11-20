import 'package:electre/classes/criteria.dart';
import 'package:electre/classes/electre.dart';
import 'package:tuple/tuple.dart';

class Alternative {
  String name;
  Map<String, double> criteriaValues;

  Alternative({required this.name, required this.criteriaValues});

  Alternative.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        criteriaValues = map['criteriaValues'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'criteriaValues': criteriaValues,
      };

  static List<Tuple2<String, String>> compare(
      List<Alternative> alts,
      // List<double> weights,
      List<Criteria> criteria,
      double concordanceThreshold,
      double discordanceThreshold) {
    List<Tuple2<String, String>> result = [];
    List<List<double>> performanceMatrix = [];
    for (int i = 0; i < alts.length; i++) {
      List<double> row = [];
      for (int j = 0; j < criteria.length; j++) {
        row.add(alts[i].criteriaValues[criteria[j].criteria]!);
      }
      performanceMatrix.add(row);
    }

    List<double> weights = [];
    for (int i = 0; i < criteria.length; i++) {
      weights.add(criteria[i].coefficient);
    }
    List<List<double>> concordanceMatrix =
        Electre1.computeConcordanceMatrix2(performanceMatrix, weights);
    List<List<double>> discordanceMatrix =
        Electre1.computeDiscordanceMatrix2(performanceMatrix);
    for (int i = 0; i < alts.length; i++) {
      for (int j = 0; j < alts.length; j++) {
        if (i == j) continue;
        if (concordanceMatrix[i][j] >= concordanceThreshold &&
            discordanceMatrix[i][j] <= discordanceThreshold) {
          result.add(Tuple2(alts[i].name, alts[j].name));
        }
      }
    }
    return result;
  }
}
