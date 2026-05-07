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
    r'idHealthDiary': PropertySchema(
      id: 1,
      name: r'idHealthDiary',
      type: IsarType.string,
    ),
    r'idHealthDiaryVaccine': PropertySchema(
      id: 2,
      name: r'idHealthDiaryVaccine',
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
    r'idHealthDiaryVaccine': IndexSchema(
      id: -6451809160525202054,
      name: r'idHealthDiaryVaccine',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idHealthDiaryVaccine',
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
    r'idHealthDiary': IndexSchema(
      id: -5690220367706079709,
      name: r'idHealthDiary',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idHealthDiary',
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
  bytesCount += 3 + object.idHealthDiary.length * 3;
  bytesCount += 3 + object.idHealthDiaryVaccine.length * 3;
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
  writer.writeString(offsets[1], object.idHealthDiary);
  writer.writeString(offsets[2], object.idHealthDiaryVaccine);
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
  object.id = id;
  object.idHealthDiary = reader.readString(offsets[1]);
  object.idHealthDiaryVaccine = reader.readString(offsets[2]);
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
  Future<HealthDiaryVaccineCache?> getByIdHealthDiaryVaccine(
      String idHealthDiaryVaccine) {
    return getByIndex(r'idHealthDiaryVaccine', [idHealthDiaryVaccine]);
  }

  HealthDiaryVaccineCache? getByIdHealthDiaryVaccineSync(
      String idHealthDiaryVaccine) {
    return getByIndexSync(r'idHealthDiaryVaccine', [idHealthDiaryVaccine]);
  }

  Future<bool> deleteByIdHealthDiaryVaccine(String idHealthDiaryVaccine) {
    return deleteByIndex(r'idHealthDiaryVaccine', [idHealthDiaryVaccine]);
  }

  bool deleteByIdHealthDiaryVaccineSync(String idHealthDiaryVaccine) {
    return deleteByIndexSync(r'idHealthDiaryVaccine', [idHealthDiaryVaccine]);
  }

  Future<List<HealthDiaryVaccineCache?>> getAllByIdHealthDiaryVaccine(
      List<String> idHealthDiaryVaccineValues) {
    final values = idHealthDiaryVaccineValues.map((e) => [e]).toList();
    return getAllByIndex(r'idHealthDiaryVaccine', values);
  }

  List<HealthDiaryVaccineCache?> getAllByIdHealthDiaryVaccineSync(
      List<String> idHealthDiaryVaccineValues) {
    final values = idHealthDiaryVaccineValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idHealthDiaryVaccine', values);
  }

  Future<int> deleteAllByIdHealthDiaryVaccine(
      List<String> idHealthDiaryVaccineValues) {
    final values = idHealthDiaryVaccineValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idHealthDiaryVaccine', values);
  }

  int deleteAllByIdHealthDiaryVaccineSync(
      List<String> idHealthDiaryVaccineValues) {
    final values = idHealthDiaryVaccineValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idHealthDiaryVaccine', values);
  }

  Future<Id> putByIdHealthDiaryVaccine(HealthDiaryVaccineCache object) {
    return putByIndex(r'idHealthDiaryVaccine', object);
  }

  Id putByIdHealthDiaryVaccineSync(HealthDiaryVaccineCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'idHealthDiaryVaccine', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdHealthDiaryVaccine(
      List<HealthDiaryVaccineCache> objects) {
    return putAllByIndex(r'idHealthDiaryVaccine', objects);
  }

  List<Id> putAllByIdHealthDiaryVaccineSync(
      List<HealthDiaryVaccineCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idHealthDiaryVaccine', objects,
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
      idHealthDiaryVaccineEqualTo(String idHealthDiaryVaccine) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idHealthDiaryVaccine',
        value: [idHealthDiaryVaccine],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterWhereClause>
      idHealthDiaryVaccineNotEqualTo(String idHealthDiaryVaccine) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiaryVaccine',
              lower: [],
              upper: [idHealthDiaryVaccine],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiaryVaccine',
              lower: [idHealthDiaryVaccine],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiaryVaccine',
              lower: [idHealthDiaryVaccine],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idHealthDiaryVaccine',
              lower: [],
              upper: [idHealthDiaryVaccine],
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
      QAfterWhereClause> idHealthDiaryEqualTo(String idHealthDiary) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idHealthDiary',
        value: [idHealthDiary],
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterWhereClause> idHealthDiaryNotEqualTo(String idHealthDiary) {
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
      QAfterFilterCondition> idHealthDiaryEqualTo(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryGreaterThan(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryLessThan(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryBetween(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryStartsWith(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryEndsWith(
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

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      idHealthDiaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idHealthDiary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      idHealthDiaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idHealthDiary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idHealthDiary',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idHealthDiary',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idHealthDiaryVaccine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idHealthDiaryVaccine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idHealthDiaryVaccine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idHealthDiaryVaccine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idHealthDiaryVaccine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idHealthDiaryVaccine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      idHealthDiaryVaccineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idHealthDiaryVaccine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
          QAfterFilterCondition>
      idHealthDiaryVaccineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idHealthDiaryVaccine',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idHealthDiaryVaccine',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache,
      QAfterFilterCondition> idHealthDiaryVaccineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idHealthDiaryVaccine',
        value: '',
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
      sortByIdHealthDiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByIdHealthDiaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByIdHealthDiaryVaccine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiaryVaccine', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      sortByIdHealthDiaryVaccineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiaryVaccine', Sort.desc);
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
      thenByIdHealthDiary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByIdHealthDiaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiary', Sort.desc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByIdHealthDiaryVaccine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiaryVaccine', Sort.asc);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QAfterSortBy>
      thenByIdHealthDiaryVaccineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idHealthDiaryVaccine', Sort.desc);
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
      distinctByIdHealthDiary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idHealthDiary',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, HealthDiaryVaccineCache, QDistinct>
      distinctByIdHealthDiaryVaccine({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idHealthDiaryVaccine',
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
      idHealthDiaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idHealthDiary');
    });
  }

  QueryBuilder<HealthDiaryVaccineCache, String, QQueryOperations>
      idHealthDiaryVaccineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idHealthDiaryVaccine');
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
