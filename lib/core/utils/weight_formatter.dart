class WeightFormatter {

  /// Replace . by ,
  static String label(double weight) {
    return '${weight.toStringAsFixed(1).replaceAll('.', ',')} kg';
  }
}
