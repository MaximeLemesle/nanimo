// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_diary_vaccine_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHealthDiaryVaccineCacheCollection on Isar {
  IsarCollection<HealthDiaryVaccineCache> get healthDiaryVaccineCaches =>
      this.collection();
}

const HealthDiaryVaccineCacheSchema = CollectionSchema(
  name: r'HealthDiaryVaccineCache',
  id: 5306873959917987629,
  properties: {
    r'doseNumber': PropertySchema(
      id: 0,
      name: r'doseNumber',
      type: IsarType.long,
    ),
    r'healthDiaryId': PropertySchema(
      id: 1,
      name: r'healthDiaryId',
      type: IsarType.string,
    ),
    r'healthDiaryVaccineId': PropertySchema(
      id: 2,
      name: r'healthDiaryVaccineId',
      type: IsarType.string,
    ),
    r'lastDate': PropertySchema(
      id: 3,
      name: r'lastDate',
      type: IsarType.dateTime,
    ),
    r'nextDate': PropertySchema(
      id: 4,
      name: r'nextDate',
      type: IsarType.dateTime,
    ),
    r'recurrence': PropertySchema(
      id: 5,
      name: r'recurrence',
      type: IsarType.long,
    ),
    r'totalDoseNumber': PropertySchema(
      id: 6,
      name: r'totalDoseNumber',
      type: IsarType.long,
    ),
    r'vaccineName': PropertySchema(
      id: 7,
      name: r'vaccineName',
      type: IsarType.string,
    )
  },
  estimateSize: _healthDiaryVaccineCacheEstimateSize,
  serialize: _healthDiaryVaccineCacheSerialize,
  deserialize: _healthDiaryVaccineCacheDeserialize,
  deserializeProp: _healthDiaryVaccineCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'healthDiaryVaccineId': IndexSchema(
      id: -3004541809343265158,
      name: r'healthDiaryVaccineId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'healthDiaryVaccineId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'nextDate': IndexSchema(
      id: -8866798344314558658,
      name: r'nextDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nextDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'healthDiaryId': IndexSchema(
      id: -7547671222084665630,
      name: r'healthDiaryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'healthDiaryId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _healthDiaryVaccineCacheGetId,
  getLinks: _healthDiaryVaccineCacheGetLinks,
  attach: _healthDiaryVaccineCacheAttach,
  version: '3.1.0+1',
);

int _healthDiaryVaccineCacheEstimateSize(
  HealthDiaryVaccineCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.healthDiaryId.length * 3;
  bytesCount += 3 + object.healthDiaryVaccineId.length * 3;
  bytesCount += 3 + object.vaccineName.length * 3;
  return bytesCount;
}

void _healthDiaryVaccineCacheSerialize(
  HealthDiaryVaccineCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.doseNumber);
  writer.writeString(offsets[1], object.healthDiaryId);
  writer.writeString(offsets[2], object.healthDiaryVaccineId);
  writer.writeDateTime(offsets[3], object.lastDate);
  writer.writeDateTime(offsets[4], object.nextDate);
  writer.writeLong(offsets[5], object.recurrence);
  writer.writeLong(offsets[6], object.totalDoseNumber);
  writer.writeString(offsets[7], object.vaccineName);
}

HealthDiaryVaccineCache _healthDiaryVaccineCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HealthDiaryVaccineCache();
  object.doseNumber = reader.readLongOrNull(offsets[0]);
  object.healthDiaryId = reader.readString(offsets[1]);
  object.healthDiaryVaccineId = reader.readString(offsets[2]);
  object.id = id;
  object.lastDate = reader.readDateTimeOrNull(offsets[3]);
  object.nextDate = reader.readDateTimeOrNull(offsets[4]);
  object.recurrence = reader.readLongOrNull(offsets[5]);
  object.totalDoseNumber = reader.readLongOrNull(offsets[6]);
  object.vaccineName = reader.readString(offsets[7]);
  return object;
}

P _healthDiaryVaccineCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _healthDiaryVaccineCacheGetId(HealthDiaryVaccineCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _healthDiaryVaccineCacheGetLinks(
    HealthDiaryVaccineCache object) {
  return [];
}

void _healthDiaryVaccineCacheAttach(
    IsarCollection<dynamic> col, Id id, HealthDiaryVaccineCache object) {
  object.id = id;
}

extension HealthDiaryVaccineCacheByIndex
    on IsarCollection<HealthDiaryVaccineCache> {
  Future<HealthDiaryVaccineCache?> getByHealthDiaryVaccineId(
      String healthDiaryVaccineId) {
    return getByIndex(r'healthDiaryVaccineId', [healthDiaryVaccineId]);
  }

  HealthDiaryVaccineCache? getByHealthDiaryVaccineIdSync(
      String healthDiaryVaccineId) {
    return getByIndexSync(r'healthDiaryVaccineId', [healthDiaryVaccineId]);
  }

  Future<bool> deleteByHealthDiaryVaccineId(String healthDiaryVaccineId) {
    return deleteByIndex(r'healthDiaryVaccineId', [healthDiaryVaccineId]);
  }

  bool deleteByHealthDiaryVaccineIdSync(String healthDiaryVaccineId) {
    return deleteByIndexSync(r'healthDiaryVaccineId', [healthDiaryVaccineId]);
  }

  Future<List<HealthDiaryVaccineCache?>> getAllByHealthDiaryVaccineId(
      List<String> healthDiaryVaccineIdValues) {
    final values = healthDiaryVaccineIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'healthDiaryVaccineId', values);
  }

  List<HealthDiaryVaccineCache?> getAllByHealthDiaryVaccineIdSync(
      List<String> healthDiaryVaccineIdValues) {
    final values = healthDiaryVaccineIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'healthDiaryVaccineId', values);
  }

  Future<int> deleteAllByHealthDiaryVaccineId(
      List<String> healthDiaryVaccineIdValues) {
    final values = healthDiaryVaccineIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'healthDiaryVaccineId', values);
  }

  int deleteAllByHealthDiaryVaccineIdSync(
      List<String> healthDiaryVaccineIdValues) {
    final values = healthDiaryVaccineIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'healthDiaryVaccineId', values);
  }

  Future<Id> putByHealthDiaryVaccineId(HealthDiaryVaccineCache object) {
    return putByIndex(r'healthDiaryVaccineId', object);
  }

  Id putByHealthDiaryVaccineIdSync(HealthDiaryVaccineCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'healthDiaryVaccineId', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHealthDiaryVaccineId(
      List<HealthDiaryVaccineCache> objects) {
    return putAllByIndex(r'healthDiaryVaccineId', objects);
  }

  List<Id> putAllByHealthDiaryVaccineIdSync(
      List<HealthDiaryVaccineCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'healthDiaryVaccineId', objects,
        saveLinks: saveLinks);
  }
}

extension HealthDiaryVaccineCacheQueryWhereSort
    on QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QWhere> {
  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterWhere>
      anyNextDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nextDate'),
      );
    });
  }
}

extension HealthDiaryVaccineCacheQueryWhere on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QWhereClause> {
  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterWhereClause>
      healthDiaryVaccineIdEqualTo(String healthDiaryVaccineId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'healthDiaryVaccineId',
        value: [healthDiaryVaccineId],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterWhereClause>
      healthDiaryVaccineIdNotEqualTo(String healthDiaryVaccineId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryVaccineId',
              lower: [],
              upper: [healthDiaryVaccineId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryVaccineId',
              lower: [healthDiaryVaccineId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryVaccineId',
              lower: [healthDiaryVaccineId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryVaccineId',
              lower: [],
              upper: [healthDiaryVaccineId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nextDate',
        value: [null],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextDate',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateEqualTo(DateTime? nextDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nextDate',
        value: [nextDate],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateNotEqualTo(DateTime? nextDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextDate',
              lower: [],
              upper: [nextDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextDate',
              lower: [nextDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextDate',
              lower: [nextDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nextDate',
              lower: [],
              upper: [nextDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateGreaterThan(
    DateTime? nextDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextDate',
        lower: [nextDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateLessThan(
    DateTime? nextDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextDate',
        lower: [],
        upper: [nextDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> nextDateBetween(
    DateTime? lowerNextDate,
    DateTime? upperNextDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nextDate',
        lower: [lowerNextDate],
        includeLower: includeLower,
        upper: [upperNextDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> healthDiaryIdEqualTo(String healthDiaryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'healthDiaryId',
        value: [healthDiaryId],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> healthDiaryIdNotEqualTo(String healthDiaryId) {
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
}

extension HealthDiaryVaccineCacheQueryFilter on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QFilterCondition> {
  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> doseNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'doseNumber',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> doseNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'doseNumber',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> doseNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> doseNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> doseNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> doseNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doseNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdEqualTo(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdGreaterThan(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdLessThan(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdBetween(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdStartsWith(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdEndsWith(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      healthDiaryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'healthDiaryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      healthDiaryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'healthDiaryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'healthDiaryId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryVaccineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'healthDiaryVaccineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'healthDiaryVaccineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'healthDiaryVaccineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'healthDiaryVaccineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'healthDiaryVaccineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      healthDiaryVaccineIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'healthDiaryVaccineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      healthDiaryVaccineIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'healthDiaryVaccineId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryVaccineId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> healthDiaryVaccineIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'healthDiaryVaccineId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> lastDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDate',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> lastDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDate',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> lastDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> lastDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> lastDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> lastDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> nextDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextDate',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> nextDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextDate',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> nextDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> nextDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> nextDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> nextDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> recurrenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrence',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> recurrenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrence',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> recurrenceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrence',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> recurrenceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrence',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> recurrenceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrence',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> recurrenceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> totalDoseNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalDoseNumber',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> totalDoseNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalDoseNumber',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> totalDoseNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDoseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> totalDoseNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDoseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> totalDoseNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDoseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> totalDoseNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDoseNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vaccineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vaccineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vaccineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vaccineName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vaccineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vaccineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      vaccineNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vaccineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      vaccineNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vaccineName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vaccineName',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> vaccineNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vaccineName',
        value: '',
      ));
    });
  }
}

extension HealthDiaryVaccineCacheQueryObject on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QFilterCondition> {}

extension HealthDiaryVaccineCacheQueryLinks on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QFilterCondition> {}

extension HealthDiaryVaccineCacheQuerySortBy
    on QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QSortBy> {
  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByDoseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseNumber', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByDoseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseNumber', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByHealthDiaryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByHealthDiaryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByHealthDiaryVaccineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryVaccineId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByHealthDiaryVaccineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryVaccineId', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByLastDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByLastDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByNextDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDate', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByNextDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDate', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByRecurrence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByRecurrenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByTotalDoseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDoseNumber', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByTotalDoseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDoseNumber', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByVaccineName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineName', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByVaccineNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineName', Sort.desc);
    });
  }
}

extension HealthDiaryVaccineCacheQuerySortThenBy on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QSortThenBy> {
  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByDoseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseNumber', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByDoseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseNumber', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByHealthDiaryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByHealthDiaryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryId', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByHealthDiaryVaccineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryVaccineId', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByHealthDiaryVaccineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryVaccineId', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByLastDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByLastDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByNextDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDate', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByNextDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDate', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByRecurrence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByRecurrenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByTotalDoseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDoseNumber', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByTotalDoseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDoseNumber', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByVaccineName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineName', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByVaccineNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineName', Sort.desc);
    });
  }
}

extension HealthDiaryVaccineCacheQueryWhereDistinct on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct> {
  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByDoseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doseNumber');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByHealthDiaryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthDiaryId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByHealthDiaryVaccineId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthDiaryVaccineId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByLastDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDate');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByNextDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextDate');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByRecurrence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrence');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByTotalDoseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDoseNumber');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByVaccineName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vaccineName', caseSensitive: caseSensitive);
    });
  }
}

extension HealthDiaryVaccineCacheQueryProperty on QueryBuilder<
    HealthDiaryVaccineCache, HealthDiaryVaccineCache, QQueryProperty> {
  QueryBuilder<HealthDiaryVaccineCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, int?, QQueryOperations>
      doseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doseNumber');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, String, QQueryOperations>
      healthDiaryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthDiaryId');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, String, QQueryOperations>
      healthDiaryVaccineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthDiaryVaccineId');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, DateTime?, QQueryOperations>
      lastDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDate');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, DateTime?, QQueryOperations>
      nextDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextDate');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, int?, QQueryOperations>
      recurrenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrence');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, int?, QQueryOperations>
      totalDoseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDoseNumber');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, String, QQueryOperations>
      vaccineNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vaccineName');
    });
  }
}
