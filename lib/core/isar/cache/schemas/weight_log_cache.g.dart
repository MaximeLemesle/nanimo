// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_log_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeightLogCacheCollection on Isar {
  IsarCollection<WeightLogCache> get weightLogCaches => this.collection();
}

const WeightLogCacheSchema = CollectionSchema(
  name: r'WeightLogCache',
  id: 681148501513933406,
  properties: {
    r'idPet': PropertySchema(
      id: 0,
      name: r'idPet',
      type: IsarType.string,
    ),
    r'idWeightLog': PropertySchema(
      id: 1,
      name: r'idWeightLog',
      type: IsarType.string,
    ),
    r'loggedAt': PropertySchema(
      id: 2,
      name: r'loggedAt',
      type: IsarType.dateTime,
    ),
    r'weight': PropertySchema(
      id: 3,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _weightLogCacheEstimateSize,
  serialize: _weightLogCacheSerialize,
  deserialize: _weightLogCacheDeserialize,
  deserializeProp: _weightLogCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'idWeightLog': IndexSchema(
      id: -3071114064124797865,
      name: r'idWeightLog',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idWeightLog',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'loggedAt': IndexSchema(
      id: 1838198766103160564,
      name: r'loggedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'loggedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'idPet': IndexSchema(
      id: 4974873299035081535,
      name: r'idPet',
      unique: false,
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
  getId: _weightLogCacheGetId,
  getLinks: _weightLogCacheGetLinks,
  attach: _weightLogCacheAttach,
  version: '3.1.0+1',
);

int _weightLogCacheEstimateSize(
  WeightLogCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.idPet.length * 3;
  bytesCount += 3 + object.idWeightLog.length * 3;
  return bytesCount;
}

void _weightLogCacheSerialize(
  WeightLogCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.idPet);
  writer.writeString(offsets[1], object.idWeightLog);
  writer.writeDateTime(offsets[2], object.loggedAt);
  writer.writeDouble(offsets[3], object.weight);
}

WeightLogCache _weightLogCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeightLogCache();
  object.id = id;
  object.idPet = reader.readString(offsets[0]);
  object.idWeightLog = reader.readString(offsets[1]);
  object.loggedAt = reader.readDateTime(offsets[2]);
  object.weight = reader.readDouble(offsets[3]);
  return object;
}

P _weightLogCacheDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weightLogCacheGetId(WeightLogCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weightLogCacheGetLinks(WeightLogCache object) {
  return [];
}

void _weightLogCacheAttach(
    IsarCollection<dynamic> col, Id id, WeightLogCache object) {
  object.id = id;
}

extension WeightLogCacheByIndex on IsarCollection<WeightLogCache> {
  Future<WeightLogCache?> getByIdWeightLog(String idWeightLog) {
    return getByIndex(r'idWeightLog', [idWeightLog]);
  }

  WeightLogCache? getByIdWeightLogSync(String idWeightLog) {
    return getByIndexSync(r'idWeightLog', [idWeightLog]);
  }

  Future<bool> deleteByIdWeightLog(String idWeightLog) {
    return deleteByIndex(r'idWeightLog', [idWeightLog]);
  }

  bool deleteByIdWeightLogSync(String idWeightLog) {
    return deleteByIndexSync(r'idWeightLog', [idWeightLog]);
  }

  Future<List<WeightLogCache?>> getAllByIdWeightLog(
      List<String> idWeightLogValues) {
    final values = idWeightLogValues.map((e) => [e]).toList();
    return getAllByIndex(r'idWeightLog', values);
  }

  List<WeightLogCache?> getAllByIdWeightLogSync(
      List<String> idWeightLogValues) {
    final values = idWeightLogValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idWeightLog', values);
  }

  Future<int> deleteAllByIdWeightLog(List<String> idWeightLogValues) {
    final values = idWeightLogValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idWeightLog', values);
  }

  int deleteAllByIdWeightLogSync(List<String> idWeightLogValues) {
    final values = idWeightLogValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idWeightLog', values);
  }

  Future<Id> putByIdWeightLog(WeightLogCache object) {
    return putByIndex(r'idWeightLog', object);
  }

  Id putByIdWeightLogSync(WeightLogCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'idWeightLog', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdWeightLog(List<WeightLogCache> objects) {
    return putAllByIndex(r'idWeightLog', objects);
  }

  List<Id> putAllByIdWeightLogSync(List<WeightLogCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idWeightLog', objects, saveLinks: saveLinks);
  }
}

extension WeightLogCacheQueryWhereSort
    on QueryBuilder<WeightLogCache, WeightLogCache, QWhere> {
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhere> anyLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'loggedAt'),
      );
    });
  }
}

extension WeightLogCacheQueryWhere
    on QueryBuilder<WeightLogCache, WeightLogCache, QWhereClause> {
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      idWeightLogEqualTo(String idWeightLog) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idWeightLog',
        value: [idWeightLog],
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      idWeightLogNotEqualTo(String idWeightLog) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idWeightLog',
              lower: [],
              upper: [idWeightLog],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idWeightLog',
              lower: [idWeightLog],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idWeightLog',
              lower: [idWeightLog],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idWeightLog',
              lower: [],
              upper: [idWeightLog],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      loggedAtEqualTo(DateTime loggedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'loggedAt',
        value: [loggedAt],
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      loggedAtNotEqualTo(DateTime loggedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loggedAt',
              lower: [],
              upper: [loggedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loggedAt',
              lower: [loggedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loggedAt',
              lower: [loggedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loggedAt',
              lower: [],
              upper: [loggedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      loggedAtGreaterThan(
    DateTime loggedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'loggedAt',
        lower: [loggedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      loggedAtLessThan(
    DateTime loggedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'loggedAt',
        lower: [],
        upper: [loggedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      loggedAtBetween(
    DateTime lowerLoggedAt,
    DateTime upperLoggedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'loggedAt',
        lower: [lowerLoggedAt],
        includeLower: includeLower,
        upper: [upperLoggedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> idPetEqualTo(
      String idPet) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idPet',
        value: [idPet],
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
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

extension WeightLogCacheQueryFilter
    on QueryBuilder<WeightLogCache, WeightLogCache, QFilterCondition> {
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idPetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idPet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idPetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idPet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idPetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idPet',
        value: '',
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idPetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idPet',
        value: '',
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idWeightLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idWeightLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idWeightLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idWeightLog',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idWeightLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idWeightLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idWeightLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idWeightLog',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idWeightLog',
        value: '',
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      idWeightLogIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idWeightLog',
        value: '',
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      loggedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loggedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      loggedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loggedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      loggedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loggedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      loggedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loggedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      weightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      weightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      weightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      weightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension WeightLogCacheQueryObject
    on QueryBuilder<WeightLogCache, WeightLogCache, QFilterCondition> {}

extension WeightLogCacheQueryLinks
    on QueryBuilder<WeightLogCache, WeightLogCache, QFilterCondition> {}

extension WeightLogCacheQuerySortBy
    on QueryBuilder<WeightLogCache, WeightLogCache, QSortBy> {
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> sortByIdPet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> sortByIdPetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      sortByIdWeightLog() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idWeightLog', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      sortByIdWeightLogDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idWeightLog', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> sortByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      sortByLoggedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension WeightLogCacheQuerySortThenBy
    on QueryBuilder<WeightLogCache, WeightLogCache, QSortThenBy> {
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByIdPet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByIdPetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPet', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      thenByIdWeightLog() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idWeightLog', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      thenByIdWeightLogDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idWeightLog', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      thenByLoggedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.desc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension WeightLogCacheQueryWhereDistinct
    on QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> {
  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> distinctByIdPet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idPet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> distinctByIdWeightLog(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idWeightLog', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> distinctByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loggedAt');
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }
}

extension WeightLogCacheQueryProperty
    on QueryBuilder<WeightLogCache, WeightLogCache, QQueryProperty> {
  QueryBuilder<WeightLogCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeightLogCache, String, QQueryOperations> idPetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idPet');
    });
  }

  QueryBuilder<WeightLogCache, String, QQueryOperations> idWeightLogProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idWeightLog');
    });
  }

  QueryBuilder<WeightLogCache, DateTime, QQueryOperations> loggedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loggedAt');
    });
  }

  QueryBuilder<WeightLogCache, double, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}
