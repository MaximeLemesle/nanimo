import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_icon_cache.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';

void main() {
  const row = {
    'id_pet_icon': 'i1',
    'pet_icon_name': 'Persan',
    'asset_path': 'assets/icons/species/cat-persan.png',
    'is_premium': true,
    'pet_species_id': 'sp-cat',
  };

  const model = PetIconModel(
    petIconId: 'i1',
    petIconName: 'Persan',
    assetPath: 'assets/icons/species/cat-persan.png',
    isPremium: true,
    petSpeciesId: 'sp-cat',
  );

  test('fromJson maps a Supabase row', () {
    final cache = PetIconCache.fromJson(row);

    expect(cache.petIconId, 'i1');
    expect(cache.petIconName, 'Persan');
    expect(cache.assetPath, 'assets/icons/species/cat-persan.png');
    expect(cache.isPremium, isTrue);
    expect(cache.petSpeciesId, 'sp-cat');
  });

  test('fromJson defaults is_premium to false when absent', () {
    final cache = PetIconCache.fromJson({...row}..remove('is_premium'));

    expect(cache.isPremium, isFalse);
  });

  test('fromModel then toModel round-trips every field', () {
    final result = PetIconCache.fromModel(model).toModel();

    expect(result.toJson(), model.toJson());
  });

  test('keeps a null species', () {
    final cache = PetIconCache.fromJson({...row, 'pet_species_id': null});

    expect(cache.petSpeciesId, isNull);
    expect(cache.toModel().petSpeciesId, isNull);
  });
}
