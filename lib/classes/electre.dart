import 'dart:math';

class Electre1 {
  // The performance matrix of the alternatives on the criteria
  List<List<double>> performanceMatrix;

  // The weights of the criteria
  List<double> criteriaWeights;

  // The concordance and discordance thresholds
  double concordanceThreshold;
  double discordanceThreshold;

  // The constructor of the class, which takes the performance matrix, the criteria weights, and the thresholds as arguments
  Electre1(this.performanceMatrix, this.criteriaWeights,
      this.concordanceThreshold, this.discordanceThreshold);

  // A method to compute the concordance matrix, which returns a list of lists of doubles
  List<List<double>> computeConcordanceMatrix() {
    // Get the number of alternatives and criteria
    int n = performanceMatrix.length;
    int m = performanceMatrix[0].length;

    // Initialize the concordance matrix with zeros
    List<List<double>> concordanceMatrix =
        List.generate(n, (i) => List.filled(n, 0.0));

    // Loop over each pair of alternatives
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // Skip the diagonal elements
        if (i == j) continue;

        // Initialize the concordance index
        double concordanceIndex = 0.0;

        // Loop over each criterion
        for (int k = 0; k < m; k++) {
          // If the performance of alternative i is greater than or equal to alternative j on criterion k, add the weight of the criterion to the concordance index
          if (performanceMatrix[i][k] >= performanceMatrix[j][k]) {
            concordanceIndex += criteriaWeights[k];
          }
        }

        // Divide the concordance index by the sum of the weights to get the concordance degree
        double concordanceDegree =
            concordanceIndex / criteriaWeights.reduce((a, b) => a + b);

        // Assign the concordance degree to the concordance matrix
        concordanceMatrix[i][j] = concordanceDegree;
      }
    }

    // Return the concordance matrix
    return concordanceMatrix;
  }

  // A method to compute the discordance matrix, which returns a list of lists of doubles
  List<List<double>> computeDiscordanceMatrix() {
    // Get the number of alternatives and criteria
    int n = performanceMatrix.length;
    int m = performanceMatrix[0].length;

    // Initialize the discordance matrix with zeros
    List<List<double>> discordanceMatrix =
        List.generate(n, (i) => List.filled(n, 0.0));

    // Loop over each pair of alternatives
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // Skip the diagonal elements
        if (i == j) continue;

        // Initialize the discordance index
        double discordanceIndex = 0.0;

        // Loop over each criterion
        for (int k = 0; k < m; k++) {
          // If the performance of alternative i is less than alternative j on criterion k, calculate the difference and update the discordance index if it is larger than the current value
          if (performanceMatrix[i][k] < performanceMatrix[j][k]) {
            double difference =
                performanceMatrix[j][k] - performanceMatrix[i][k];
            discordanceIndex = max(discordanceIndex, difference);
          }
        }

        // Find the maximum difference among all the criteria for the pair of alternatives
        double maxDifference = 0.0;
        for (int k = 0; k < m; k++) {
          double difference =
              (performanceMatrix[i][k] - performanceMatrix[j][k]).abs();
          maxDifference = max(maxDifference, difference);
        }

        // Divide the discordance index by the maximum difference to get the discordance degree
        double discordanceDegree = discordanceIndex / maxDifference;

        // Assign the discordance degree to the discordance matrix
        discordanceMatrix[i][j] = discordanceDegree;
      }
    }

    // Return the discordance matrix
    return discordanceMatrix;
  }

  // A method to define the concordance and discordance thresholds, which returns a list of two doubles
  List<double> defineThresholds() {
    // Get the concordance and discordance matrices
    List<List<double>> concordanceMatrix = computeConcordanceMatrix();
    List<List<double>> discordanceMatrix = computeDiscordanceMatrix();

    // Get the number of alternatives
    int n = performanceMatrix.length;

    // Initialize the lists to store the concordance and discordance degrees
    List<double> concordanceDegrees = [];
    List<double> discordanceDegrees = [];

    // Loop over each pair of alternatives
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // Skip the diagonal elements
        if (i == j) continue;

        // Add the concordance and discordance degrees to the lists
        concordanceDegrees.add(concordanceMatrix[i][j]);
        discordanceDegrees.add(discordanceMatrix[i][j]);
      }
    }

    // Sort the lists in ascending order
    concordanceDegrees.sort();
    discordanceDegrees.sort();

    // Calculate the median of the lists
    double medianConcordanceDegree = (concordanceDegrees[n * (n - 1) ~/ 4] +
            concordanceDegrees[n * (n - 1) ~/ 4 - 1]) /
        2;
    double medianDiscordanceDegree = (discordanceDegrees[n * (n - 1) ~/ 4] +
            discordanceDegrees[n * (n - 1) ~/ 4 - 1]) /
        2;

    // Return the thresholds as a list
    return [medianConcordanceDegree, medianDiscordanceDegree];
  }

  List<List<bool>> compare() {
    // Get the concordance and discordance matrices
    List<List<double>> concordanceMatrix = computeConcordanceMatrix();
    List<List<double>> discordanceMatrix = computeDiscordanceMatrix();

    // Get the number of alternatives
    int n = performanceMatrix.length;

    // Initialize the list to store the results
    List<List<bool>> results = List.generate(n, (i) => List.filled(n, false));

    // Loop over each pair of alternatives
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // Skip the diagonal elements
        if (i == j) continue;

        // If the concordance degree is greater than or equal to the concordance threshold and the discordance degree is less than or equal to the discordance threshold, set the result to true
        if (concordanceMatrix[i][j] >= concordanceThreshold &&
            discordanceMatrix[i][j] <= discordanceThreshold) {
          results[i][j] = true;
        }
      }
    }

    // Return the results
    return results;
  }

  static List<List<double>> computeConcordanceMatrix2(
      List<List<double>> performanceMatrix, List<double> criteriaWeights) {
    // Get the number of alternatives and criteria
    int n = performanceMatrix.length;
    int m = performanceMatrix[0].length;

    // Initialize the concordance matrix with zeros
    List<List<double>> concordanceMatrix =
        List.generate(n, (i) => List.filled(n, 0.0));

    // Loop over each pair of alternatives
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // Skip the diagonal elements
        if (i == j) continue;

        // Initialize the concordance index
        double concordanceIndex = 0.0;

        // Loop over each criterion
        for (int k = 0; k < m; k++) {
          // If the performance of alternative i is greater than or equal to alternative j on criterion k, add the weight of the criterion to the concordance index
          if (performanceMatrix[i][k] >= performanceMatrix[j][k]) {
            concordanceIndex += criteriaWeights[k];
          }
        }

        // Divide the concordance index by the sum of the weights to get the concordance degree
        double concordanceDegree =
            concordanceIndex / criteriaWeights.reduce((a, b) => a + b);

        // Assign the concordance degree to the concordance matrix
        concordanceMatrix[i][j] = concordanceDegree;
      }
    }

    // Return the concordance matrix
    return concordanceMatrix;
  }

  static List<List<double>> computeDiscordanceMatrix2(
      List<List<double>> performanceMatrix) {
    // Get the number of alternatives and criteria
    int n = performanceMatrix.length;
    int m = performanceMatrix[0].length;

    double minMatrix = performanceMatrix[0][0];
    //loop to search for the minimum value in the matrix
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        if (performanceMatrix[i][j] < minMatrix) {
          minMatrix = performanceMatrix[i][j];
        }
      }
    }

    // Initialize the discordance matrix with zeros
    List<List<double>> discordanceMatrix =
        List.generate(n, (i) => List.filled(n, 0.0));

    // Loop over each pair of alternatives
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // Skip the diagonal elements
        if (i == j) continue;

        // Initialize the discordance index
        double discordanceIndex = 0.0;

        // Loop over each criterion
        for (int k = 0; k < m; k++) {
          // If the performance of alternative i is less than alternative j on criterion k, calculate the difference and update the discordance index if it is larger than the current value
          if (performanceMatrix[i][k] < performanceMatrix[j][k]) {
            double difference =
                performanceMatrix[j][k] - performanceMatrix[i][k];
            discordanceIndex = max(discordanceIndex, difference) / minMatrix;
          }
        }

        // Assign the discordance index to the discordance matrix
        discordanceMatrix[i][j] = discordanceIndex;
      }
    }

    // Return the discordance matrix
    return discordanceMatrix;
  }
}
