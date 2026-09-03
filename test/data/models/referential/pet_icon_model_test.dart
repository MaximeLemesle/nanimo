import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';

void main() {
  const row = {
    'id_pet_icon': 'i1',
    'pet_icon_name': 'Persan',
    'asset_path': 'assets/icons/species/cat-persan.png',
    'is_premium': true,
    'pet_species_id': 'sp-cat',
  };

  test('fromJson reads every column', () {
    final icon = PetIconModel.fromJson(row);

    expect(icon.petIconId, 'i1');
    expect(icon.petIconName, 'Persan');
    expect(icon.assetPath, 'assets/icons/species/cat-persan.png');
    expect(icon.isPremium, isTrue);
    expect(icon.petSpeciesId, 'sp-cat');
  });

  /// The column is NOT NULL in Postgres, but a row read from a stale cache or a
  /// partial select must not crash the catalogue.
  test('fromJson defaults is_premium to false when absent', () {
    final icon = PetIconModel.fromJson({...row}..remove('is_premium'));

    expect(icon.isPremium, isFalse);
  });

  test('fromJson accepts a null species', () {
    final icon = PetIconModel.fromJson({...row, 'pet_species_id': null});

    expect(icon.petSpeciesId, isNull);
  });

  test('toJson round-trips the row', () {
    expect(PetIconModel.fromJson(row).toJson(), row);
  });
}
