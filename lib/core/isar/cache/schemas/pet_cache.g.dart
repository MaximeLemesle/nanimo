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
    r'petId': PropertySchema(
      id: 3,
      name: r'petId',
      type: IsarType.string,
    ),
    r'petName': PropertySchema(
      id: 4,
      name: r'petName',
      type: IsarType.string,
    ),
    r'petRaceId': PropertySchema(
      id: 5,
      name: r'petRaceId',
      type: IsarType.string,
    ),
    r'petSpeciesId': PropertySchema(
      id: 6,
      name: r'petSpeciesId',
      type: IsarType.string,
    )
  },
  estimateSize: _petCacheEstimateSize,
  serialize: _petCacheSerialize,
  deserialize: _petCacheDeserialize,
  deserializeProp: _petCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'petId': IndexSchema(
      id: -7951607706841349632,
      name: r'petId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petId',
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
  bytesCount += 3 + object.petId.length * 3;
  bytesCount += 3 + object.petName.length * 3;
  {
    final value = object.petRaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.petSpeciesId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
  writer.writeString(offsets[3], object.petId);
  writer.writeString(offsets[4], object.petName);
  writer.writeString(offsets[5], object.petRaceId);
  writer.writeString(offsets[6], object.petSpeciesId);
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
  object.petId = reader.readString(offsets[3]);
  object.petName = reader.readString(offsets[4]);
  object.petRaceId = reader.readStringOrNull(offsets[5]);
  object.petSpeciesId = reader.readStringOrNull(offsets[6]);
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
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
  Future<PetCache?> getByPetId(String petId) {
    return getByIndex(r'petId', [petId]);
  }

  PetCache? getByPetIdSync(String petId) {
    return getByIndexSync(r'petId', [petId]);
  }

  Future<bool> deleteByPetId(String petId) {
    return deleteByIndex(r'petId', [petId]);
  }

  bool deleteByPetIdSync(String petId) {
    return deleteByIndexSync(r'petId', [petId]);
  }

  Future<List<PetCache?>> getAllByPetId(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'petId', values);
  }

  List<PetCache?> getAllByPetIdSync(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'petId', values);
  }

  Future<int> deleteAllByPetId(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'petId', values);
  }

  int deleteAllByPetIdSync(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'petId', values);
  }

  Future<Id> putByPetId(PetCache object) {
    return putByIndex(r'petId', object);
  }

  Id putByPetIdSync(PetCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'petId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPetId(List<PetCache> objects) {
    return putAllByIndex(r'petId', objects);
  }

  List<Id> putAllByPetIdSync(List<PetCache> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'petId', objects, saveLinks: saveLinks);
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

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> petIdEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petId',
        value: [petId],
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterWhereClause> petIdNotEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [],
              upper: [petId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [petId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [petId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [],
              upper: [petId],
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petId',
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'petRaceId',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'petRaceId',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petRaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petRaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petRaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petRaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
      petRaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petRaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'petSpeciesId',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
      petSpeciesIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'petSpeciesId',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdEqualTo(
    String? value, {
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
      petSpeciesIdGreaterThan(
    String? value, {
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdLessThan(
    String? value, {
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdEndsWith(
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

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition> petSpeciesIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petSpeciesId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
      petSpeciesIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petSpeciesId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterFilterCondition>
      petSpeciesIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petSpeciesId',
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

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
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

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetRaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetRaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetSpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> sortByPetSpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.desc);
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

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
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

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetRaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetRaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.desc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetSpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.asc);
    });
  }

  QueryBuilder<PetCache, PetCache, QAfterSortBy> thenByPetSpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.desc);
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

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByPetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByPetName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByPetRaceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petRaceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetCache, PetCache, QDistinct> distinctByPetSpeciesId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petSpeciesId', caseSensitive: caseSensitive);
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

  QueryBuilder<PetCache, String, QQueryOperations> petIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petId');
    });
  }

  QueryBuilder<PetCache, String, QQueryOperations> petNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petName');
    });
  }

  QueryBuilder<PetCache, String?, QQueryOperations> petRaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petRaceId');
    });
  }

  QueryBuilder<PetCache, String?, QQueryOperations> petSpeciesIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petSpeciesId');
    });
  }
}
