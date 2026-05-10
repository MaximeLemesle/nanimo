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
    r'healthDiaryWeightLogId': PropertySchema(
      id: 0,
      name: r'healthDiaryWeightLogId',
      type: IsarType.string,
    ),
    r'loggedAt': PropertySchema(
      id: 1,
      name: r'loggedAt',
      type: IsarType.dateTime,
    ),
    r'petId': PropertySchema(
      id: 2,
      name: r'petId',
      type: IsarType.string,
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
    r'healthDiaryWeightLogId': IndexSchema(
      id: -8418231218117005332,
      name: r'healthDiaryWeightLogId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'healthDiaryWeightLogId',
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
    r'petId': IndexSchema(
      id: -7951607706841349632,
      name: r'petId',
      unique: false,
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
  bytesCount += 3 + object.healthDiaryWeightLogId.length * 3;
  bytesCount += 3 + object.petId.length * 3;
  return bytesCount;
}

void _weightLogCacheSerialize(
  WeightLogCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.healthDiaryWeightLogId);
  writer.writeDateTime(offsets[1], object.loggedAt);
  writer.writeString(offsets[2], object.petId);
  writer.writeDouble(offsets[3], object.weight);
}

WeightLogCache _weightLogCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeightLogCache();
  object.healthDiaryWeightLogId = reader.readString(offsets[0]);
  object.id = id;
  object.loggedAt = reader.readDateTime(offsets[1]);
  object.petId = reader.readString(offsets[2]);
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
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
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
  Future<WeightLogCache?> getByHealthDiaryWeightLogId(
      String healthDiaryWeightLogId) {
    return getByIndex(r'healthDiaryWeightLogId', [healthDiaryWeightLogId]);
  }

  WeightLogCache? getByHealthDiaryWeightLogIdSync(
      String healthDiaryWeightLogId) {
    return getByIndexSync(r'healthDiaryWeightLogId', [healthDiaryWeightLogId]);
  }

  Future<bool> deleteByHealthDiaryWeightLogId(String healthDiaryWeightLogId) {
    return deleteByIndex(r'healthDiaryWeightLogId', [healthDiaryWeightLogId]);
  }

  bool deleteByHealthDiaryWeightLogIdSync(String healthDiaryWeightLogId) {
    return deleteByIndexSync(
        r'healthDiaryWeightLogId', [healthDiaryWeightLogId]);
  }

  Future<List<WeightLogCache?>> getAllByHealthDiaryWeightLogId(
      List<String> healthDiaryWeightLogIdValues) {
    final values = healthDiaryWeightLogIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'healthDiaryWeightLogId', values);
  }

  List<WeightLogCache?> getAllByHealthDiaryWeightLogIdSync(
      List<String> healthDiaryWeightLogIdValues) {
    final values = healthDiaryWeightLogIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'healthDiaryWeightLogId', values);
  }

  Future<int> deleteAllByHealthDiaryWeightLogId(
      List<String> healthDiaryWeightLogIdValues) {
    final values = healthDiaryWeightLogIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'healthDiaryWeightLogId', values);
  }

  int deleteAllByHealthDiaryWeightLogIdSync(
      List<String> healthDiaryWeightLogIdValues) {
    final values = healthDiaryWeightLogIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'healthDiaryWeightLogId', values);
  }

  Future<Id> putByHealthDiaryWeightLogId(WeightLogCache object) {
    return putByIndex(r'healthDiaryWeightLogId', object);
  }

  Id putByHealthDiaryWeightLogIdSync(WeightLogCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'healthDiaryWeightLogId', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHealthDiaryWeightLogId(
      List<WeightLogCache> objects) {
    return putAllByIndex(r'healthDiaryWeightLogId', objects);
  }

  List<Id> putAllByHealthDiaryWeightLogIdSync(List<WeightLogCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'healthDiaryWeightLogId', objects,
        saveLinks: saveLinks);
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
      healthDiaryWeightLogIdEqualTo(String healthDiaryWeightLogId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'healthDiaryWeightLogId',
        value: [healthDiaryWeightLogId],
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
      healthDiaryWeightLogIdNotEqualTo(String healthDiaryWeightLogId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryWeightLogId',
              lower: [],
              upper: [healthDiaryWeightLogId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryWeightLogId',
              lower: [healthDiaryWeightLogId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryWeightLogId',
              lower: [healthDiaryWeightLogId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'healthDiaryWeightLogId',
              lower: [],
              upper: [healthDiaryWeightLogId],
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause> petIdEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petId',
        value: [petId],
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterWhereClause>
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

extension WeightLogCacheQueryFilter
    on QueryBuilder<WeightLogCache, WeightLogCache, QFilterCondition> {
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryWeightLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'healthDiaryWeightLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'healthDiaryWeightLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'healthDiaryWeightLogId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'healthDiaryWeightLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'healthDiaryWeightLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'healthDiaryWeightLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'healthDiaryWeightLogId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthDiaryWeightLogId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      healthDiaryWeightLogIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'healthDiaryWeightLogId',
        value: '',
      ));
    });
  }

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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      petIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      petIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      petIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterFilterCondition>
      petIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petId',
        value: '',
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
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      sortByHealthDiaryWeightLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryWeightLogId', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      sortByHealthDiaryWeightLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryWeightLogId', Sort.desc);
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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> sortByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> sortByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
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
  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      thenByHealthDiaryWeightLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryWeightLogId', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy>
      thenByHealthDiaryWeightLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthDiaryWeightLogId', Sort.desc);
    });
  }

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

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QAfterSortBy> thenByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
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
  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct>
      distinctByHealthDiaryWeightLogId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthDiaryWeightLogId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> distinctByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loggedAt');
    });
  }

  QueryBuilder<WeightLogCache, WeightLogCache, QDistinct> distinctByPetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petId', caseSensitive: caseSensitive);
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

  QueryBuilder<WeightLogCache, String, QQueryOperations>
      healthDiaryWeightLogIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthDiaryWeightLogId');
    });
  }

  QueryBuilder<WeightLogCache, DateTime, QQueryOperations> loggedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loggedAt');
    });
  }

  QueryBuilder<WeightLogCache, String, QQueryOperations> petIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petId');
    });
  }

  QueryBuilder<WeightLogCache, double, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}
