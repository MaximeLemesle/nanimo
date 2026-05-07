// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPetCacheCollection on Isar {
  IsarCollection<PetCache> get petCaches => this.collection();
}

const PetCacheSchema = CollectionSchema(
  name: r'PetCache',
  id: -1717551516130563504,
  properties: {
    r'birthdate': PropertySchema(
      id: 0,
      name: r'birthdate',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'gender': PropertySchema(
      id: 2,
      name: r'gender',
      type: IsarType.string,
    ),
    r'idIcon': PropertySchema(
      id: 3,
      name: r'idIcon',
      type: IsarType.string,
    ),
    r'idPet': PropertySchema(
      id: 4,
      name: r'idPet',
      type: IsarType.string,
    ),
    r'idRace': PropertySchema(
      id: 5,
      name: r'idRace',
      type: IsarType.string,
    ),
    r'idSpecies': PropertySchema(
      id: 6,
      name: r'idSpecies',
      type: IsarType.string,
    ),
    r'petName': PropertySchema(
      id: 7,
      name: r'petName',
      type: IsarType.string,
    )
  },
  estimateSize: _petCacheEstimateSize,
  serialize: _petCacheSerialize,
  deserialize: _petCacheDeserialize,
  deserializeProp: _petCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'idPet': IndexSchema(
      id: 4974873299035081535,
      name: r'idPet',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idPet',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _petCacheGetId,
  getLinks: _petCacheGetLinks,
  attach: _petCacheAttach,
  version: '3.1.0+1',
);

int _petCacheEstimateSize(
  PetCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.gender.length * 3;
  {
    final value = object.idIcon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idPet.length * 3;
  {
    final value = object.idRace;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.idSpecies;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.petName.length * 3;
  return bytesCount;
}

void _petCacheSerialize(
  PetCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.birthdate);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.gender);
  writer.writeString(offsets[3], object.idIcon);
  writer.writeString(offsets[4], object.idPet);
  writer.writeString(offsets[5], object.idRace);
  writer.writeString(offsets[6], object.idSpecies);
  writer.writeString(offsets[7], object.petName);
}

PetCache _petCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PetCache();
  object.birthdate = reader.readDateTimeOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.gender = reader.readString(offsets[2]);
  object.id = id;
  object.idIcon = reader.readStringOrNull(offsets[3]);
  object.idPet = reader.readString(offsets[4]);
  object.idRace = reader.readStringOrNull(offsets[5]);
  object.idSpecies = reader.readStringOrNull(offsets[6]);
  object.petName = reader.readString(offsets[7]);
  return object;
}

P _petCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _petCacheGetId(PetCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _petCacheGetLinks(PetCache object) {
  return [];
}

void _petCacheAttach(IsarCollection<dynamic> col, Id id, PetCache object) {
  object.id = id;
}

extension PetCacheByIndex on IsarCollection<PetCache> {
  Future<PetCache?> getByIdPet(String idPet) {
    return getByIndex(r'idPet', [idPet]);
  }

  PetCache? getByIdPetSync(String idPet) {
    return getByIndexSync(r'idPet', [idPet]);
  }

  Future<bool> deleteByIdPet(String idPet) {
    return deleteByIndex(r'idPet', [idPet]);
  }

  bool deleteByIdPetSync(String idPet) {
    return deleteByIndexSync(r'idPet', [idPet]);
  }

  Future<List<PetCache?>> getAllByIdPet(List<String> idPetValues) {
    final values = idPetValues.map((e) => [e]).toList();
    return getAllByIndex(r'idPet', values);
  }

  List<PetCache?> getAllByIdPetSync(List<String> idPetValues) {
    final values = idPetValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idPet', values);
  }

  Future<int> deleteAllByIdPet(List<String> idPetValues) {
    final values = idPetValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idPet', values);
  }

  int deleteAllByIdPetSync(List<String> idPetValues) {
    final values = idPetValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idPet', values);
  }

  Future<Id> putByIdPet(PetCache object) {
    return putByIndex(r'idPet', object);
  }

  Id putByIdPetSync(PetCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'idPet', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdPet(List<PetCache> objects) {
    return putAllByIndex(r'idPet', objects);
  }

  List<Id> putAllByIdPetSync(List<PetCache> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'idPet', objects, saveLinks: saveLinks);
  }
}

extension PetCacheQueryWhereSort on QueryBuilder<PetCache, PetCache, QWhere> {
  QueryBuilder<PetCache, PetCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PetCacheQueryWhere on QueryBuilder<PetCache, PetCache, QWhereClause> {
  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idPetEqualTo(
      String idPet) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idPet',
        value: [idPet],
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> idPetNotEqualTo(
      String idPet) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idPet',
              lower: [],
              upper: [idPet],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idPet',
              lower: [idPet],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idPet',
              lower: [idPet],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idPet',
              lower: [],
              upper: [idPet],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PetCacheQueryFilter
    on QueryBuilder<PetCache, PetCache, QFilterCondition> {
  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> birthdateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'birthdate',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> birthdateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'birthdate',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> birthdateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'birthdate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> birthdateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'birthdate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> birthdateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'birthdate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> birthdateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'birthdate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idIcon',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idIcon',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idIcon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idIcon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idIconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idPet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idPet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idPet',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idPetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idPet',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idRace',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idRace',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idRace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idRace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idRace',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idRace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idRace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idRace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idRace',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRace',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idRaceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idRace',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idSpecies',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idSpecies',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSpecies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idSpecies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idSpecies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idSpecies',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idSpecies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idSpecies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idSpecies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idSpecies',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> idSpeciesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idSpecies',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
      idSpeciesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idSpecies',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petName',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petName',
        value: '',
      ));
    });
  }
}

extension PetCacheQueryObject
    on QueryBuilder<PetCache, PetCache, QFilterCondition> {}

extension PetCacheQueryLinks
    on QueryBuilder<PetCache, PetCache, QFilterCondition> {}

extension PetCacheQuerySortBy on QueryBuilder<PetCache, PetCache, QSortBy> {
  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByBirthdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthdate', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByBirthdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthdate', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idIcon', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idIcon', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdPet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdPetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdRace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRace', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdRaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRace', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdSpecies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecies', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByIdSpeciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecies', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.desc);
    });
  }
}

extension PetCacheQuerySortThenBy
    on QueryBuilder<PetCache, PetCache, QSortThenBy> {
  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByBirthdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthdate', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByBirthdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthdate', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idIcon', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idIcon', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdPet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdPetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdRace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRace', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdRaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRace', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdSpecies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecies', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByIdSpeciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idSpecies', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.desc);
    });
  }
}

extension PetCacheQueryWhereDistinct
    on QueryBuilder<PetCache, PetCache, QDistinct> {
  QueryBuilder<PetCache, PetCache, QDistinct> distinctByBirthdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'birthdate');
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByIdIcon(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idIcon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByIdPet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idPet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByIdRace(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idRace', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByIdSpecies(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idSpecies', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByPetName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petName', caseSensitive: caseSensitive);
    });
  }
}

extension PetCacheQueryProperty
    on QueryBuilder<PetCache, PetCache, QQueryProperty> {
  QueryBuilder<PetCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PetCache, DateTime?, QQueryOperations> birthdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'birthdate');
    });
  }

  QueryBuilder<PetCache, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PetCache, String, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<PetCache, String?, QQueryOperations> idIconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idIcon');
    });
  }

  QueryBuilder<PetCache, String, QQueryOperations> idPetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idPet');
    });
  }

  QueryBuilder<PetCache, String?, QQueryOperations> idRaceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idRace');
    });
  }

  QueryBuilder<PetCache, String?, QQueryOperations> idSpeciesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idSpecies');
    });
  }

  QueryBuilder<PetCache, String, QQueryOperations> petNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petName');
    });
  }
}
