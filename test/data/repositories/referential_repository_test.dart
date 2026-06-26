import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';

import '../../helpers/supabase_mocks.dart';

void main() {
  late MockSupabaseClient supabase;
  late ReferentialRepository repo;

  setUpAll(registerSupabaseFallbacks);

  setUp(() {
    supabase = MockSupabaseClient();
    repo = ReferentialRepository(supabase);
  });

  group('fetchSpecies', () {
    test('maps the rows into species models', () async {
      stubSelect(
        supabase,
        'pet_species',
        resolver: () => [
          {
            'id_pet_species': 's-cat',
            'species_name': 'Chat',
            'weight_unit': 'kg',
            'icon_key': 'cat',
          },
        ],
      );

      final species = await repo.fetchSpecies();

      expect(species, hasLength(1));
      expect(species.first.petSpeciesId, 's-cat');
      expect(species.first.iconKey, 'cat');
    });

    test('wraps errors into an Exception', () async {
      stubSelect(
        supabase,
        'pet_species',
        resolver: () => throw Exception('network'),
      );

      expect(repo.fetchSpecies(), throwsA(isA<Exception>()));
    });
  });

  group('fetchRacesBySpecies', () {
    test('maps the rows into race models', () async {
      stubSelect(
        supabase,
        'pet_race',
        resolver: () => [
          {
            'id_pet_race': 'r-eu',
            'pet_race_name': 'Européen',
            'pet_species_id': 's-cat',
          },
        ],
      );

      final races = await repo.fetchRacesBySpecies('s-cat');

      expect(races, hasLength(1));
      expect(races.first.petRaceId, 'r-eu');
      expect(races.first.petSpeciesId, 's-cat');
    });

    test('wraps errors into an Exception', () async {
      stubSelect(
        supabase,
        'pet_race',
        resolver: () => throw Exception('boom'),
      );

      expect(repo.fetchRacesBySpecies('s-cat'), throwsA(isA<Exception>()));
    });
  });

  group('fetchEventTypes', () {
    test('maps the rows into event type models', () async {
      stubSelect(
        supabase,
        'event_type',
        resolver: () => [
          {
            'id_event_type': 't-balade',
            'name': 'Balade',
            'code': 'balade',
            'is_premium': false,
          },
        ],
      );

      final types = await repo.fetchEventTypes();

      expect(types, hasLength(1));
      expect(types.first.eventTypeId, 't-balade');
      expect(types.first.code, 'balade');
    });

    test('wraps errors into an Exception', () async {
      stubSelect(
        supabase,
        'event_type',
        resolver: () => throw Exception('boom'),
      );

      expect(repo.fetchEventTypes(), throwsA(isA<Exception>()));
    });
  });

  group('fetchRecommendedVaccinesBySpecies', () {
    test('maps the rows into recommended vaccine models', () async {
      stubSelect(
        supabase,
        'recommended_vaccines',
        resolver: () => [
          {
            'name': 'Rage',
            'category': 'Obligatoire',
            'recurrence_days': 365,
          },
        ],
      );

      final vaccines = await repo.fetchRecommendedVaccinesBySpecies('s-cat');

      expect(vaccines, hasLength(1));
      expect(vaccines.first.name, 'Rage');
      expect(vaccines.first.recurrenceDays, 365);
    });

    test('wraps errors into an Exception', () async {
      stubSelect(
        supabase,
        'recommended_vaccines',
        resolver: () => throw Exception('boom'),
      );

      expect(
        repo.fetchRecommendedVaccinesBySpecies('s-cat'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
