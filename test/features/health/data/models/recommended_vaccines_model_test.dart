import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';

void main() {
  test('fromJson maps every field and coerces recurrence to int', () {
    final model = RecommendedVaccineModel.fromJson(const {
      'name': 'Rage',
      'category': 'Obligatoire',
      'recurrence_days': 365.0,
    });

    expect(model.name, 'Rage');
    expect(model.category, 'Obligatoire');
    expect(model.recurrenceDays, 365);
  });
}
