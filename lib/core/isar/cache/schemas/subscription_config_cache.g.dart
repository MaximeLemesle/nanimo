// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSubscriptionConfigCacheCollection on Isar {
  IsarCollection<SubscriptionConfigCache> get subscriptionConfigCaches =>
      this.collection();
}

const SubscriptionConfigCacheSchema = CollectionSchema(
  name: r'SubscriptionConfigCache',
  id: 1226880869150589037,
  properties: {
    r'configId': PropertySchema(
      id: 0,
      name: r'configId',
      type: IsarType.string,
    ),
    r'maxImagesPerEvent': PropertySchema(
      id: 1,
      name: r'maxImagesPerEvent',
      type: IsarType.long,
    ),
    r'maxPets': PropertySchema(
      id: 2,
      name: r'maxPets',
      type: IsarType.long,
    ),
    r'maxStorageMb': PropertySchema(
      id: 3,
      name: r'maxStorageMb',
      type: IsarType.long,
    ),
    r'planName': PropertySchema(
      id: 4,
      name: r'planName',
      type: IsarType.string,
    )
  },
  estimateSize: _subscriptionConfigCacheEstimateSize,
  serialize: _subscriptionConfigCacheSerialize,
  deserialize: _subscriptionConfigCacheDeserialize,
  deserializeProp: _subscriptionConfigCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'configId': IndexSchema(
      id: 7164334513802924883,
      name: r'configId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'configId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _subscriptionConfigCacheGetId,
  getLinks: _subscriptionConfigCacheGetLinks,
  attach: _subscriptionConfigCacheAttach,
  version: '3.1.0+1',
);

int _subscriptionConfigCacheEstimateSize(
  SubscriptionConfigCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.configId.length * 3;
  bytesCount += 3 + object.planName.length * 3;
  return bytesCount;
}

void _subscriptionConfigCacheSerialize(
  SubscriptionConfigCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.configId);
  writer.writeLong(offsets[1], object.maxImagesPerEvent);
  writer.writeLong(offsets[2], object.maxPets);
  writer.writeLong(offsets[3], object.maxStorageMb);
  writer.writeString(offsets[4], object.planName);
}

SubscriptionConfigCache _subscriptionConfigCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SubscriptionConfigCache();
  object.configId = reader.readString(offsets[0]);
  object.id = id;
  object.maxImagesPerEvent = reader.readLong(offsets[1]);
  object.maxPets = reader.readLong(offsets[2]);
  object.maxStorageMb = reader.readLong(offsets[3]);
  object.planName = reader.readString(offsets[4]);
  return object;
}

P _subscriptionConfigCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _subscriptionConfigCacheGetId(SubscriptionConfigCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _subscriptionConfigCacheGetLinks(
    SubscriptionConfigCache object) {
  return [];
}

void _subscriptionConfigCacheAttach(
    IsarCollection<dynamic> col, Id id, SubscriptionConfigCache object) {
  object.id = id;
}

extension SubscriptionConfigCacheByIndex
    on IsarCollection<SubscriptionConfigCache> {
  Future<SubscriptionConfigCache?> getByConfigId(String configId) {
    return getByIndex(r'configId', [configId]);
  }

  SubscriptionConfigCache? getByConfigIdSync(String configId) {
    return getByIndexSync(r'configId', [configId]);
  }

  Future<bool> deleteByConfigId(String configId) {
    return deleteByIndex(r'configId', [configId]);
  }

  bool deleteByConfigIdSync(String configId) {
    return deleteByIndexSync(r'configId', [configId]);
  }

  Future<List<SubscriptionConfigCache?>> getAllByConfigId(
      List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'configId', values);
  }

  List<SubscriptionConfigCache?> getAllByConfigIdSync(
      List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'configId', values);
  }

  Future<int> deleteAllByConfigId(List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'configId', values);
  }

  int deleteAllByConfigIdSync(List<String> configIdValues) {
    final values = configIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'configId', values);
  }

  Future<Id> putByConfigId(SubscriptionConfigCache object) {
    return putByIndex(r'configId', object);
  }

  Id putByConfigIdSync(SubscriptionConfigCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'configId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByConfigId(List<SubscriptionConfigCache> objects) {
    return putAllByIndex(r'configId', objects);
  }

  List<Id> putAllByConfigIdSync(List<SubscriptionConfigCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'configId', objects, saveLinks: saveLinks);
  }
}

extension SubscriptionConfigCacheQueryWhereSort
    on QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QWhere> {
  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SubscriptionConfigCacheQueryWhere on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QWhereClause> {
  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
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

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
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

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterWhereClause> configIdEqualTo(String configId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'configId',
        value: [configId],
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterWhereClause> configIdNotEqualTo(String configId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [],
              upper: [configId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [configId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [configId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configId',
              lower: [],
              upper: [configId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SubscriptionConfigCacheQueryFilter on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QFilterCondition> {
  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
          QAfterFilterCondition>
      configIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
          QAfterFilterCondition>
      configIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configId',
        value: '',
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> configIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configId',
        value: '',
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
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

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
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

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
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

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxImagesPerEventEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxImagesPerEvent',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxImagesPerEventGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxImagesPerEvent',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxImagesPerEventLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxImagesPerEvent',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxImagesPerEventBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxImagesPerEvent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxPetsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxPets',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxPetsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxPets',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxPetsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxPets',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxPetsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxPets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxStorageMbEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxStorageMb',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxStorageMbGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxStorageMb',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxStorageMbLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxStorageMb',
        value: value,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> maxStorageMbBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxStorageMb',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
          QAfterFilterCondition>
      planNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
          QAfterFilterCondition>
      planNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planName',
        value: '',
      ));
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache,
      QAfterFilterCondition> planNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planName',
        value: '',
      ));
    });
  }
}

extension SubscriptionConfigCacheQueryObject on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QFilterCondition> {}

extension SubscriptionConfigCacheQueryLinks on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QFilterCondition> {}

extension SubscriptionConfigCacheQuerySortBy
    on QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QSortBy> {
  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByConfigIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByMaxImagesPerEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxImagesPerEvent', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByMaxImagesPerEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxImagesPerEvent', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByMaxPets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPets', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByMaxPetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPets', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByMaxStorageMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStorageMb', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByMaxStorageMbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStorageMb', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      sortByPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.desc);
    });
  }
}

extension SubscriptionConfigCacheQuerySortThenBy on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QSortThenBy> {
  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByConfigIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configId', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByMaxImagesPerEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxImagesPerEvent', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByMaxImagesPerEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxImagesPerEvent', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByMaxPets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPets', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByMaxPetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPets', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByMaxStorageMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStorageMb', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByMaxStorageMbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStorageMb', Sort.desc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.asc);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QAfterSortBy>
      thenByPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.desc);
    });
  }
}

extension SubscriptionConfigCacheQueryWhereDistinct on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QDistinct> {
  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QDistinct>
      distinctByConfigId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QDistinct>
      distinctByMaxImagesPerEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxImagesPerEvent');
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QDistinct>
      distinctByMaxPets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxPets');
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QDistinct>
      distinctByMaxStorageMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxStorageMb');
    });
  }

  QueryBuilder<SubscriptionConfigCache, SubscriptionConfigCache, QDistinct>
      distinctByPlanName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planName', caseSensitive: caseSensitive);
    });
  }
}

extension SubscriptionConfigCacheQueryProperty on QueryBuilder<
    SubscriptionConfigCache, SubscriptionConfigCache, QQueryProperty> {
  QueryBuilder<SubscriptionConfigCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SubscriptionConfigCache, String, QQueryOperations>
      configIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configId');
    });
  }

  QueryBuilder<SubscriptionConfigCache, int, QQueryOperations>
      maxImagesPerEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxImagesPerEvent');
    });
  }

  QueryBuilder<SubscriptionConfigCache, int, QQueryOperations>
      maxPetsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxPets');
    });
  }

  QueryBuilder<SubscriptionConfigCache, int, QQueryOperations>
      maxStorageMbProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxStorageMb');
    });
  }

  QueryBuilder<SubscriptionConfigCache, String, QQueryOperations>
      planNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planName');
    });
  }
}
