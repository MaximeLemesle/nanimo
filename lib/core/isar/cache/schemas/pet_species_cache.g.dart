// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_species_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPetSpeciesCacheCollection on Isar {
  IsarCollection<PetSpeciesCache> get petSpeciesCaches => this.collection();
}

const PetSpeciesCacheSchema = CollectionSchema(
  name: r'PetSpeciesCache',
  id: -3963884509549158657,
  properties: {
    r'iconKey': PropertySchema(
      id: 0,
      name: r'iconKey',
      type: IsarType.string,
    ),
    r'petSpeciesId': PropertySchema(
      id: 1,
      name: r'petSpeciesId',
      type: IsarType.string,
    ),
    r'speciesName': PropertySchema(
      id: 2,
      name: r'speciesName',
      type: IsarType.string,
    ),
    r'weightUnit': PropertySchema(
      id: 3,
      name: r'weightUnit',
      type: IsarType.string,
    )
  },
  estimateSize: _petSpeciesCacheEstimateSize,
  serialize: _petSpeciesCacheSerialize,
  deserialize: _petSpeciesCacheDeserialize,
  deserializeProp: _petSpeciesCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'petSpeciesId': IndexSchema(
      id: 6831563341087857817,
      name: r'petSpeciesId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petSpeciesId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _petSpeciesCacheGetId,
  getLinks: _petSpeciesCacheGetLinks,
  attach: _petSpeciesCacheAttach,
  version: '3.1.0+1',
);

int _petSpeciesCacheEstimateSize(
  PetSpeciesCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.iconKey.length * 3;
  bytesCount += 3 + object.petSpeciesId.length * 3;
  bytesCount += 3 + object.speciesName.length * 3;
  bytesCount += 3 + object.weightUnit.length * 3;
  return bytesCount;
}

void _petSpeciesCacheSerialize(
  PetSpeciesCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.iconKey);
  writer.writeString(offsets[1], object.petSpeciesId);
  writer.writeString(offsets[2], object.speciesName);
  writer.writeString(offsets[3], object.weightUnit);
}

PetSpeciesCache _petSpeciesCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PetSpeciesCache();
  object.iconKey = reader.readString(offsets[0]);
  object.id = id;
  object.petSpeciesId = reader.readString(offsets[1]);
  object.speciesName = reader.readString(offsets[2]);
  object.weightUnit = reader.readString(offsets[3]);
  return object;
}

P _petSpeciesCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _petSpeciesCacheGetId(PetSpeciesCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _petSpeciesCacheGetLinks(PetSpeciesCache object) {
  return [];
}

void _petSpeciesCacheAttach(
    IsarCollection<dynamic> col, Id id, PetSpeciesCache object) {
  object.id = id;
}

extension PetSpeciesCacheByIndex on IsarCollection<PetSpeciesCache> {
  Future<PetSpeciesCache?> getByPetSpeciesId(String petSpeciesId) {
    return getByIndex(r'petSpeciesId', [petSpeciesId]);
  }

  PetSpeciesCache? getByPetSpeciesIdSync(String petSpeciesId) {
    return getByIndexSync(r'petSpeciesId', [petSpeciesId]);
  }

  Future<bool> deleteByPetSpeciesId(String petSpeciesId) {
    return deleteByIndex(r'petSpeciesId', [petSpeciesId]);
  }

  bool deleteByPetSpeciesIdSync(String petSpeciesId) {
    return deleteByIndexSync(r'petSpeciesId', [petSpeciesId]);
  }

  Future<List<PetSpeciesCache?>> getAllByPetSpeciesId(
      List<String> petSpeciesIdValues) {
    final values = petSpeciesIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'petSpeciesId', values);
  }

  List<PetSpeciesCache?> getAllByPetSpeciesIdSync(
      List<String> petSpeciesIdValues) {
    final values = petSpeciesIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'petSpeciesId', values);
  }

  Future<int> deleteAllByPetSpeciesId(List<String> petSpeciesIdValues) {
    final values = petSpeciesIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'petSpeciesId', values);
  }

  int deleteAllByPetSpeciesIdSync(List<String> petSpeciesIdValues) {
    final values = petSpeciesIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'petSpeciesId', values);
  }

  Future<Id> putByPetSpeciesId(PetSpeciesCache object) {
    return putByIndex(r'petSpeciesId', object);
  }

  Id putByPetSpeciesIdSync(PetSpeciesCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'petSpeciesId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPetSpeciesId(List<PetSpeciesCache> objects) {
    return putAllByIndex(r'petSpeciesId', objects);
  }

  List<Id> putAllByPetSpeciesIdSync(List<PetSpeciesCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'petSpeciesId', objects, saveLinks: saveLinks);
  }
}

extension PetSpeciesCacheQueryWhereSort
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QWhere> {
  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PetSpeciesCacheQueryWhere
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QWhereClause> {
  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause>
      petSpeciesIdEqualTo(String petSpeciesId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petSpeciesId',
        value: [petSpeciesId],
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterWhereClause>
      petSpeciesIdNotEqualTo(String petSpeciesId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [],
              upper: [petSpeciesId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [petSpeciesId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [petSpeciesId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [],
              upper: [petSpeciesId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PetSpeciesCacheQueryFilter
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QFilterCondition> {
  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      iconKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petSpeciesId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petSpeciesId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petSpeciesId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      petSpeciesIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petSpeciesId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speciesName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speciesName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speciesName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speciesName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'speciesName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'speciesName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'speciesName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'speciesName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speciesName',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      speciesNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'speciesName',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weightUnit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterFilterCondition>
      weightUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weightUnit',
        value: '',
      ));
    });
  }
}

extension PetSpeciesCacheQueryObject
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QFilterCondition> {}

extension PetSpeciesCacheQueryLinks
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QFilterCondition> {}

extension PetSpeciesCacheQuerySortBy
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QSortBy> {
  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy> sortByIconKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconKey', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortByIconKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconKey', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortByPetSpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortByPetSpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortBySpeciesName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesName', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortBySpeciesNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesName', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortByWeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      sortByWeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.desc);
    });
  }
}

extension PetSpeciesCacheQuerySortThenBy
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QSortThenBy> {
  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy> thenByIconKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconKey', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenByIconKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconKey', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenByPetSpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenByPetSpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenBySpeciesName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesName', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenBySpeciesNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesName', Sort.desc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenByWeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.asc);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QAfterSortBy>
      thenByWeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.desc);
    });
  }
}

extension PetSpeciesCacheQueryWhereDistinct
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QDistinct> {
  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QDistinct> distinctByIconKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QDistinct>
      distinctByPetSpeciesId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petSpeciesId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QDistinct>
      distinctBySpeciesName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speciesName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetSpeciesCache, PetSpeciesCache, QDistinct>
      distinctByWeightUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightUnit', caseSensitive: caseSensitive);
    });
  }
}

extension PetSpeciesCacheQueryProperty
    on QueryBuilder<PetSpeciesCache, PetSpeciesCache, QQueryProperty> {
  QueryBuilder<PetSpeciesCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PetSpeciesCache, String, QQueryOperations> iconKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconKey');
    });
  }

  QueryBuilder<PetSpeciesCache, String, QQueryOperations>
      petSpeciesIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petSpeciesId');
    });
  }

  QueryBuilder<PetSpeciesCache, String, QQueryOperations>
      speciesNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speciesName');
    });
  }

  QueryBuilder<PetSpeciesCache, String, QQueryOperations> weightUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightUnit');
    });
  }
}
