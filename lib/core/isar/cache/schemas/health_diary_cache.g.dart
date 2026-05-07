// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_diary_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHealthDiaryCacheCollection on Isar {
  IsarCollection<HealthDiaryCache> get healthDiaryCaches => this.collection();
}

const HealthDiaryCacheSchema = CollectionSchema(
  name: r'HealthDiaryCache',
  id: 2202541904144742200,
  properties: {
    r'chipNumber': PropertySchema(
      id: 0,
      name: r'chipNumber',
      type: IsarType.string,
    ),
    r'idHealthDiary': PropertySchema(
      id: 1,
      name: r'idHealthDiary',
      type: IsarType.string,
    ),
    r'idPet': PropertySchema(
      id: 2,
      name: r'idPet',
      type: IsarType.string,
    ),
    r'isChipped': PropertySchema(
      id: 3,
      name: r'isChipped',
      type: IsarType.bool,
    ),
    r'isSterilized': PropertySchema(
      id: 4,
      name: r'isSterilized',
      type: IsarType.bool,
    ),
    r'lastDewormingAt': PropertySchema(
      id: 5,
      name: r'lastDewormingAt',
      type: IsarType.dateTime,
    ),
    r'lastVetAppointment': PropertySchema(
      id: 6,
      name: r'lastVetAppointment',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _healthDiaryCacheEstimateSize,
  serialize: _healthDiaryCacheSerialize,
  deserialize: _healthDiaryCacheDeserialize,
  deserializeProp: _healthDiaryCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'idHealthDiary': IndexSchema(
      id: -5690220367706079709,
      name: r'idHealthDiary',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idHealthDiary',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
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
  getId: _healthDiaryCacheGetId,
  getLinks: _healthDiaryCacheGetLinks,
  attach: _healthDiaryCacheAttach,
  version: '3.1.0+1',
);

int _healthDiaryCacheEstimateSize(
  HealthDiaryCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chipNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idHealthDiary.length * 3;
  bytesCount += 3 + object.idPet.length * 3;
  return bytesCount;
}

void _healthDiaryCacheSerialize(
  HealthDiaryCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chipNumber);
  writer.writeString(offsets[1], object.idHealthDiary);
  writer.writeString(offsets[2], object.idPet);
  writer.writeBool(offsets[3], object.isChipped);
  writer.writeBool(offsets[4], object.isSterilized);
  writer.writeDateTime(offsets[5], object.lastDewormingAt);
  writer.writeDateTime(offsets[6], object.lastVetAppointment);
}

HealthDiaryCache _healthDiaryCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HealthDiaryCache();
  object.chipNumber = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.idHealthDiary = reader.readString(offsets[1]);
  object.idPet = reader.readString(offsets[2]);
  object.isChipped = reader.readBool(offsets[3]);
  object.isSterilized = reader.readBool(offsets[4]);
  object.lastDewormingAt = reader.readDateTimeOrNull(offsets[5]);
  object.lastVetAppointment = reader.readDateTimeOrNull(offsets[6]);
  return object;
}

P _healthDiaryCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _healthDiaryCacheGetId(HealthDiaryCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _healthDiaryCacheGetLinks(HealthDiaryCache object) {
  return [];
}

void _healthDiaryCacheAttach(
    IsarCollection<dynamic> col, Id id, HealthDiaryCache object) {
  object.id = id;
}

extension HealthDiaryCacheByIndex on IsarCollection<HealthDiaryCache> {
  Future<HealthDiaryCache?> getByIdHealthDiary(String idHealthDiary) {
    return getByIndex(r'idHealthDiary', [idHealthDiary]);
  }

  HealthDiaryCache? getByIdHealthDiarySync(String idHealthDiary) {
    return getByIndexSync(r'idHealthDiary', [idHealthDiary]);
  }

  Future<bool> deleteByIdHealthDiary(String idHealthDiary) {
    return deleteByIndex(r'idHealthDiary', [idHealthDiary]);
  }

  bool deleteByIdHealthDiarySync(String idHealthDiary) {
    return deleteByIndexSync(r'idHealthDiary', [idHealthDiary]);
  }

  Future<List<HealthDiaryCache?>> getAllByIdHealthDiary(
      List<String> idHealthDiaryValues) {
    final values = idHealthDiaryValues.map((e) => [e]).toList();
    return getAllByIndex(r'idHealthDiary', values);
  }

  List<HealthDiaryCache?> getAllByIdHealthDiarySync(
      List<String> idHealthDiaryValues) {
    final values = idHealthDiaryValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idHealthDiary', values);
  }

  Future<int> deleteAllByIdHealthDiary(List<String> idHealthDiaryValues) {
    final values = idHealthDiaryValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idHealthDiary', values);
  }

  int deleteAllByIdHealthDiarySync(List<String> idHealthDiaryValues) {
    final values = idHealthDiaryValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idHealthDiary', values);
  }

  Future<Id> putByIdHealthDiary(HealthDiaryCache object) {
    return putByIndex(r'idHealthDiary', object);
  }

  Id putByIdHealthDiarySync(HealthDiaryCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'idHealthDiary', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdHealthDiary(List<HealthDiaryCache> objects) {
    return putAllByIndex(r'idHealthDiary', objects);
  }

  List<Id> putAllByIdHealthDiarySync(List<HealthDiaryCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idHealthDiary', objects, saveLinks: saveLinks);
  }

  Future<HealthDiaryCache?> getByIdPet(String idPet) {
    return getByIndex(r'idPet', [idPet]);
  }

  HealthDiaryCache? getByIdPetSync(String idPet) {
    return getByIndexSync(r'idPet', [idPet]);
  }

  Future<bool> deleteByIdPet(String idPet) {
    return deleteByIndex(r'idPet', [idPet]);
  }

  bool deleteByIdPetSync(String idPet) {
    return deleteByIndexSync(r'idPet', [idPet]);
  }

  Future<List<HealthDiaryCache?>> getAllByIdPet(List<String> idPetValues) {
    final values = idPetValues.map((e) => [e]).toList();
    return getAllByIndex(r'idPet', values);
  }

  List<HealthDiaryCache?> getAllByIdPetSync(List<String> idPetValues) {
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

  Future<Id> putByIdPet(HealthDiaryCache object) {
    return putByIndex(r'idPet', object);
  }

  Id putByIdPetSync(HealthDiaryCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'idPet', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdPet(List<HealthDiaryCache> objects) {
    return putAllByIndex(r'idPet', objects);
  }

  List<Id> putAllByIdPetSync(List<HealthDiaryCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idPet', objects, saveLinks: saveLinks);
  }
}

extension HealthDiaryCacheQueryWhereSort
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QWhere> {
  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HealthDiaryCacheQueryWhere
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QWhereClause> {
  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      idHealthDiaryEqualTo(String idHealthDiary) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idHealthDiary',
        value: [idHealthDiary],
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      idHealthDiaryNotEqualTo(String idHealthDiary) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiary',
              lower: [],
              upper: [idHealthDiary],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiary',
              lower: [idHealthDiary],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiary',
              lower: [idHealthDiary],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiary',
              lower: [],
              upper: [idHealthDiary],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      idPetEqualTo(String idPet) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idPet',
        value: [idPet],
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      idPetNotEqualTo(String idPet) {
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

extension HealthDiaryCacheQueryFilter
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QFilterCondition> {
  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chipNumber',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chipNumber',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chipNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chipNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chipNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chipNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chipNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chipNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chipNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chipNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chipNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      chipNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chipNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idHealthDiary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idHealthDiary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idHealthDiary',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idHealthDiaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idHealthDiary',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetEqualTo(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetGreaterThan(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetLessThan(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetBetween(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetStartsWith(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetEndsWith(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idPet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idPet',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      idPetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idPet',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isChippedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isChipped',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isSterilizedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSterilized',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDewormingAt',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDewormingAt',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDewormingAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDewormingAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDewormingAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDewormingAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastVetAppointmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastVetAppointment',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastVetAppointmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastVetAppointment',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastVetAppointmentEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastVetAppointment',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastVetAppointmentGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastVetAppointment',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastVetAppointmentLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastVetAppointment',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastVetAppointmentBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastVetAppointment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HealthDiaryCacheQueryObject
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QFilterCondition> {}

extension HealthDiaryCacheQueryLinks
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QFilterCondition> {}

extension HealthDiaryCacheQuerySortBy
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QSortBy> {
  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByChipNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chipNumber', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByChipNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chipNumber', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIdHealthDiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIdHealthDiaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy> sortByIdPet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIdPetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIsChipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChipped', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIsChippedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChipped', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIsSterilized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSterilized', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByIsSterilizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSterilized', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByLastDewormingAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDewormingAt', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByLastDewormingAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDewormingAt', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByLastVetAppointment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVetAppointment', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByLastVetAppointmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVetAppointment', Sort.desc);
    });
  }
}

extension HealthDiaryCacheQuerySortThenBy
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QSortThenBy> {
  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByChipNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chipNumber', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByChipNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chipNumber', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIdHealthDiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIdHealthDiaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy> thenByIdPet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIdPetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIsChipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChipped', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIsChippedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChipped', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIsSterilized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSterilized', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByIsSterilizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSterilized', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByLastDewormingAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDewormingAt', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByLastDewormingAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDewormingAt', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByLastVetAppointment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVetAppointment', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByLastVetAppointmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVetAppointment', Sort.desc);
    });
  }
}

extension HealthDiaryCacheQueryWhereDistinct
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct> {
  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByChipNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chipNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByIdHealthDiary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idHealthDiary',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct> distinctByIdPet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idPet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByIsChipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isChipped');
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByIsSterilized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSterilized');
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByLastDewormingAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDewormingAt');
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByLastVetAppointment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastVetAppointment');
    });
  }
}

extension HealthDiaryCacheQueryProperty
    on QueryBuilder<HealthDiaryCache, HealthDiaryCache, QQueryProperty> {
  QueryBuilder<HealthDiaryCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HealthDiaryCache, String?, QQueryOperations>
      chipNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chipNumber');
    });
  }

  QueryBuilder<HealthDiaryCache, String, QQueryOperations>
      idHealthDiaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idHealthDiary');
    });
  }

  QueryBuilder<HealthDiaryCache, String, QQueryOperations> idPetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idPet');
    });
  }

  QueryBuilder<HealthDiaryCache, bool, QQueryOperations> isChippedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isChipped');
    });
  }

  QueryBuilder<HealthDiaryCache, bool, QQueryOperations>
      isSterilizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSterilized');
    });
  }

  QueryBuilder<HealthDiaryCache, DateTime?, QQueryOperations>
      lastDewormingAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDewormingAt');
    });
  }

  QueryBuilder<HealthDiaryCache, DateTime?, QQueryOperations>
      lastVetAppointmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastVetAppointment');
    });
  }
}
