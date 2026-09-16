// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_sync_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArticleSyncCacheCollection on Isar {
  IsarCollection<ArticleSyncCache> get articleSyncCaches => this.collection();
}

const ArticleSyncCacheSchema = CollectionSchema(
  name: r'ArticleSyncCache',
  id: 4309462599872541211,
  properties: {
    r'syncedAt': PropertySchema(
      id: 0,
      name: r'syncedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _articleSyncCacheEstimateSize,
  serialize: _articleSyncCacheSerialize,
  deserialize: _articleSyncCacheDeserialize,
  deserializeProp: _articleSyncCacheDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _articleSyncCacheGetId,
  getLinks: _articleSyncCacheGetLinks,
  attach: _articleSyncCacheAttach,
  version: '3.1.0+1',
);

int _articleSyncCacheEstimateSize(
  ArticleSyncCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _articleSyncCacheSerialize(
  ArticleSyncCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.syncedAt);
}

ArticleSyncCache _articleSyncCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ArticleSyncCache();
  object.id = id;
  object.syncedAt = reader.readDateTime(offsets[0]);
  return object;
}

P _articleSyncCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _articleSyncCacheGetId(ArticleSyncCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _articleSyncCacheGetLinks(ArticleSyncCache object) {
  return [];
}

void _articleSyncCacheAttach(
    IsarCollection<dynamic> col, Id id, ArticleSyncCache object) {
  object.id = id;
}

extension ArticleSyncCacheQueryWhereSort
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QWhere> {
  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ArticleSyncCacheQueryWhere
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QWhereClause> {
  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterWhereClause>
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

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterWhereClause> idBetween(
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
}

extension ArticleSyncCacheQueryFilter
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QFilterCondition> {
  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
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

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
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

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
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

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
      syncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
      syncedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
      syncedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterFilterCondition>
      syncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ArticleSyncCacheQueryObject
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QFilterCondition> {}

extension ArticleSyncCacheQueryLinks
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QFilterCondition> {}

extension ArticleSyncCacheQuerySortBy
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QSortBy> {
  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterSortBy>
      sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterSortBy>
      sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension ArticleSyncCacheQuerySortThenBy
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QSortThenBy> {
  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterSortBy>
      thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QAfterSortBy>
      thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension ArticleSyncCacheQueryWhereDistinct
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QDistinct> {
  QueryBuilder<ArticleSyncCache, ArticleSyncCache, QDistinct>
      distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }
}

extension ArticleSyncCacheQueryProperty
    on QueryBuilder<ArticleSyncCache, ArticleSyncCache, QQueryProperty> {
  QueryBuilder<ArticleSyncCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ArticleSyncCache, DateTime, QQueryOperations>
      syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }
}
