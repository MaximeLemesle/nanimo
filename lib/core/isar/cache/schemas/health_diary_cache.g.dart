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
    r'healthDiaryId': PropertySchema(
      id: 1,
      name: r'healthDiaryId',
      type: IsarType.string,
    ),
    r'isChipped': PropertySchema(
      id: 2,
      name: r'isChipped',
      type: IsarType.bool,
    ),
    r'isSterilized': PropertySchema(
      id: 3,
      name: r'isSterilized',
      type: IsarType.bool,
    ),
    r'lastDeworming': PropertySchema(
      id: 4,
      name: r'lastDeworming',
      type: IsarType.dateTime,
    ),
    r'lastVetAppointment': PropertySchema(
      id: 5,
      name: r'lastVetAppointment',
      type: IsarType.dateTime,
    ),
    r'petId': PropertySchema(
      id: 6,
      name: r'petId',
      type: IsarType.string,
    )
  },
  estimateSize: _healthDiaryCacheEstimateSize,
  serialize: _healthDiaryCacheSerialize,
  deserialize: _healthDiaryCacheDeserialize,
  deserializeProp: _healthDiaryCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'healthDiaryId': IndexSchema(
      id: -7547671222084665630,
      name: r'healthDiaryId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'healthDiaryId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
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
  bytesCount += 3 + object.healthDiaryId.length * 3;
  bytesCount += 3 + object.petId.length * 3;
  return bytesCount;
}

void _healthDiaryCacheSerialize(
  HealthDiaryCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chipNumber);
  writer.writeString(offsets[1], object.healthDiaryId);
  writer.writeBool(offsets[2], object.isChipped);
  writer.writeBool(offsets[3], object.isSterilized);
  writer.writeDateTime(offsets[4], object.lastDeworming);
  writer.writeDateTime(offsets[5], object.lastVetAppointment);
  writer.writeString(offsets[6], object.petId);
}

HealthDiaryCache _healthDiaryCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HealthDiaryCache();
  object.chipNumber = reader.readStringOrNull(offsets[0]);
  object.healthDiaryId = reader.readString(offsets[1]);
  object.id = id;
  object.isChipped = reader.readBoolOrNull(offsets[2]);
  object.isSterilized = reader.readBoolOrNull(offsets[3]);
  object.lastDeworming = reader.readDateTimeOrNull(offsets[4]);
  object.lastVetAppointment = reader.readDateTimeOrNull(offsets[5]);
  object.petId = reader.readString(offsets[6]);
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
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
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
  Future<HealthDiaryCache?> getByHealthDiaryId(String healthDiaryId) {
    return getByIndex(r'healthDiaryId', [healthDiaryId]);
  }

  HealthDiaryCache? getByHealthDiaryIdSync(String healthDiaryId) {
    return getByIndexSync(r'healthDiaryId', [healthDiaryId]);
  }

  Future<bool> deleteByHealthDiaryId(String healthDiaryId) {
    return deleteByIndex(r'healthDiaryId', [healthDiaryId]);
  }

  bool deleteByHealthDiaryIdSync(String healthDiaryId) {
    return deleteByIndexSync(r'healthDiaryId', [healthDiaryId]);
  }

  Future<List<HealthDiaryCache?>> getAllByHealthDiaryId(
      List<String> healthDiaryIdValues) {
    final values = healthDiaryIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'healthDiaryId', values);
  }

  List<HealthDiaryCache?> getAllByHealthDiaryIdSync(
      List<String> healthDiaryIdValues) {
    final values = healthDiaryIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'healthDiaryId', values);
  }

  Future<int> deleteAllByHealthDiaryId(List<String> healthDiaryIdValues) {
    final values = healthDiaryIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'healthDiaryId', values);
  }

  int deleteAllByHealthDiaryIdSync(List<String> healthDiaryIdValues) {
    final values = healthDiaryIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'healthDiaryId', values);
  }

  Future<Id> putByHealthDiaryId(HealthDiaryCache object) {
    return putByIndex(r'healthDiaryId', object);
  }

  Id putByHealthDiaryIdSync(HealthDiaryCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'healthDiaryId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHealthDiaryId(List<HealthDiaryCache> objects) {
    return putAllByIndex(r'healthDiaryId', objects);
  }

  List<Id> putAllByHealthDiaryIdSync(List<HealthDiaryCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'healthDiaryId', objects, saveLinks: saveLinks);
  }

  Future<HealthDiaryCache?> getByPetId(String petId) {
    return getByIndex(r'petId', [petId]);
  }

  HealthDiaryCache? getByPetIdSync(String petId) {
    return getByIndexSync(r'petId', [petId]);
  }

  Future<bool> deleteByPetId(String petId) {
    return deleteByIndex(r'petId', [petId]);
  }

  bool deleteByPetIdSync(String petId) {
    return deleteByIndexSync(r'petId', [petId]);
  }

  Future<List<HealthDiaryCache?>> getAllByPetId(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'petId', values);
  }

  List<HealthDiaryCache?> getAllByPetIdSync(List<String> petIdValues) {
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

  Future<Id> putByPetId(HealthDiaryCache object) {
    return putByIndex(r'petId', object);
  }

  Id putByPetIdSync(HealthDiaryCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'petId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPetId(List<HealthDiaryCache> objects) {
    return putAllByIndex(r'petId', objects);
  }

  List<Id> putAllByPetIdSync(List<HealthDiaryCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'petId', objects, saveLinks: saveLinks);
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
      healthDiaryIdEqualTo(String healthDiaryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'healthDiaryId',
        value: [healthDiaryId],
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      healthDiaryIdNotEqualTo(String healthDiaryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryId',
              lower: [],
              upper: [healthDiaryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryId',
              lower: [healthDiaryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryId',
              lower: [healthDiaryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryId',
              lower: [],
              upper: [healthDiaryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      petIdEqualTo(String petId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petId',
        value: [petId],
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterWhereClause>
      petIdNotEqualTo(String petId) {
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
      healthDiaryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'healthDiaryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'healthDiaryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      healthDiaryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'healthDiaryId',
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
      isChippedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isChipped',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isChippedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isChipped',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isChippedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isChipped',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isSterilizedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isSterilized',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isSterilizedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isSterilized',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      isSterilizedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSterilized',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDeworming',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDeworming',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDeworming',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDeworming',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDeworming',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      lastDewormingBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDeworming',
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdEqualTo(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdGreaterThan(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdLessThan(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdBetween(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdStartsWith(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdEndsWith(
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterFilterCondition>
      petIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petId',
        value: '',
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
      sortByHealthDiaryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByHealthDiaryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.desc);
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
      sortByLastDeworming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDeworming', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByLastDewormingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDeworming', Sort.desc);
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy> sortByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      sortByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByHealthDiaryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByHealthDiaryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.desc);
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
      thenByLastDeworming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDeworming', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByLastDewormingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDeworming', Sort.desc);
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

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy> thenByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QAfterSortBy>
      thenByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
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
      distinctByHealthDiaryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthDiaryId',
          caseSensitive: caseSensitive);
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
      distinctByLastDeworming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDeworming');
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct>
      distinctByLastVetAppointment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastVetAppointment');
    });
  }

  QueryBuilder<HealthDiaryCache, HealthDiaryCache, QDistinct> distinctByPetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petId', caseSensitive: caseSensitive);
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
      healthDiaryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthDiaryId');
    });
  }

  QueryBuilder<HealthDiaryCache, bool?, QQueryOperations> isChippedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isChipped');
    });
  }

  QueryBuilder<HealthDiaryCache, bool?, QQueryOperations>
      isSterilizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSterilized');
    });
  }

  QueryBuilder<HealthDiaryCache, DateTime?, QQueryOperations>
      lastDewormingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDeworming');
    });
  }

  QueryBuilder<HealthDiaryCache, DateTime?, QQueryOperations>
      lastVetAppointmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastVetAppointment');
    });
  }

  QueryBuilder<HealthDiaryCache, String, QQueryOperations> petIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petId');
    });
  }
}
