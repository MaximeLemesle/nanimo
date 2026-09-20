// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArticleCacheCollection on Isar {
  IsarCollection<ArticleCache> get articleCaches => this.collection();
}

const ArticleCacheSchema = CollectionSchema(
  name: r'ArticleCache',
  id: -6020525293928884502,
  properties: {
    r'articleId': PropertySchema(
      id: 0,
      name: r'articleId',
      type: IsarType.string,
    ),
    r'paragraphs': PropertySchema(
      id: 1,
      name: r'paragraphs',
      type: IsarType.stringList,
    ),
    r'publishedAt': PropertySchema(
      id: 2,
      name: r'publishedAt',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _articleCacheEstimateSize,
  serialize: _articleCacheSerialize,
  deserialize: _articleCacheDeserialize,
  deserializeProp: _articleCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'articleId': IndexSchema(
      id: 2849477555030470394,
      name: r'articleId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'articleId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'publishedAt': IndexSchema(
      id: -7203464909218318400,
      name: r'publishedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'publishedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _articleCacheGetId,
  getLinks: _articleCacheGetLinks,
  attach: _articleCacheAttach,
  version: '3.1.0+1',
);

int _articleCacheEstimateSize(
  ArticleCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.articleId.length * 3;
  bytesCount += 3 + object.paragraphs.length * 3;
  {
    for (var i = 0; i < object.paragraphs.length; i++) {
      final value = object.paragraphs[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _articleCacheSerialize(
  ArticleCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.articleId);
  writer.writeStringList(offsets[1], object.paragraphs);
  writer.writeDateTime(offsets[2], object.publishedAt);
  writer.writeString(offsets[3], object.title);
}

ArticleCache _articleCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ArticleCache();
  object.articleId = reader.readString(offsets[0]);
  object.id = id;
  object.paragraphs = reader.readStringList(offsets[1]) ?? [];
  object.publishedAt = reader.readDateTime(offsets[2]);
  object.title = reader.readString(offsets[3]);
  return object;
}

P _articleCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _articleCacheGetId(ArticleCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _articleCacheGetLinks(ArticleCache object) {
  return [];
}

void _articleCacheAttach(
    IsarCollection<dynamic> col, Id id, ArticleCache object) {
  object.id = id;
}

extension ArticleCacheByIndex on IsarCollection<ArticleCache> {
  Future<ArticleCache?> getByArticleId(String articleId) {
    return getByIndex(r'articleId', [articleId]);
  }

  ArticleCache? getByArticleIdSync(String articleId) {
    return getByIndexSync(r'articleId', [articleId]);
  }

  Future<bool> deleteByArticleId(String articleId) {
    return deleteByIndex(r'articleId', [articleId]);
  }

  bool deleteByArticleIdSync(String articleId) {
    return deleteByIndexSync(r'articleId', [articleId]);
  }

  Future<List<ArticleCache?>> getAllByArticleId(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'articleId', values);
  }

  List<ArticleCache?> getAllByArticleIdSync(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'articleId', values);
  }

  Future<int> deleteAllByArticleId(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'articleId', values);
  }

  int deleteAllByArticleIdSync(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'articleId', values);
  }

  Future<Id> putByArticleId(ArticleCache object) {
    return putByIndex(r'articleId', object);
  }

  Id putByArticleIdSync(ArticleCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'articleId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByArticleId(List<ArticleCache> objects) {
    return putAllByIndex(r'articleId', objects);
  }

  List<Id> putAllByArticleIdSync(List<ArticleCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'articleId', objects, saveLinks: saveLinks);
  }
}

extension ArticleCacheQueryWhereSort
    on QueryBuilder<ArticleCache, ArticleCache, QWhere> {
  QueryBuilder<ArticleCache, ArticleCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhere> anyPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'publishedAt'),
      );
    });
  }
}

extension ArticleCacheQueryWhere
    on QueryBuilder<ArticleCache, ArticleCache, QWhereClause> {
  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause> articleIdEqualTo(
      String articleId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'articleId',
        value: [articleId],
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause>
      articleIdNotEqualTo(String articleId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [],
              upper: [articleId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [articleId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [articleId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [],
              upper: [articleId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause>
      publishedAtEqualTo(DateTime publishedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'publishedAt',
        value: [publishedAt],
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause>
      publishedAtNotEqualTo(DateTime publishedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'publishedAt',
              lower: [],
              upper: [publishedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'publishedAt',
              lower: [publishedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'publishedAt',
              lower: [publishedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'publishedAt',
              lower: [],
              upper: [publishedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause>
      publishedAtGreaterThan(
    DateTime publishedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'publishedAt',
        lower: [publishedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause>
      publishedAtLessThan(
    DateTime publishedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'publishedAt',
        lower: [],
        upper: [publishedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterWhereClause>
      publishedAtBetween(
    DateTime lowerPublishedAt,
    DateTime upperPublishedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'publishedAt',
        lower: [lowerPublishedAt],
        includeLower: includeLower,
        upper: [upperPublishedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ArticleCacheQueryFilter
    on QueryBuilder<ArticleCache, ArticleCache, QFilterCondition> {
  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'articleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'articleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'articleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      articleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'articleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paragraphs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paragraphs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paragraphs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paragraphs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paragraphs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paragraphs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paragraphs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paragraphs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paragraphs',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paragraphs',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paragraphs',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paragraphs',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paragraphs',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paragraphs',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paragraphs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      paragraphsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paragraphs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      publishedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      publishedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      publishedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publishedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      publishedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publishedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension ArticleCacheQueryObject
    on QueryBuilder<ArticleCache, ArticleCache, QFilterCondition> {}

extension ArticleCacheQueryLinks
    on QueryBuilder<ArticleCache, ArticleCache, QFilterCondition> {}

extension ArticleCacheQuerySortBy
    on QueryBuilder<ArticleCache, ArticleCache, QSortBy> {
  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> sortByArticleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> sortByArticleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.desc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> sortByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy>
      sortByPublishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.desc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ArticleCacheQuerySortThenBy
    on QueryBuilder<ArticleCache, ArticleCache, QSortThenBy> {
  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenByArticleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenByArticleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.desc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy>
      thenByPublishedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishedAt', Sort.desc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ArticleCacheQueryWhereDistinct
    on QueryBuilder<ArticleCache, ArticleCache, QDistinct> {
  QueryBuilder<ArticleCache, ArticleCache, QDistinct> distinctByArticleId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'articleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QDistinct> distinctByParagraphs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paragraphs');
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QDistinct> distinctByPublishedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publishedAt');
    });
  }

  QueryBuilder<ArticleCache, ArticleCache, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ArticleCacheQueryProperty
    on QueryBuilder<ArticleCache, ArticleCache, QQueryProperty> {
  QueryBuilder<ArticleCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ArticleCache, String, QQueryOperations> articleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'articleId');
    });
  }

  QueryBuilder<ArticleCache, List<String>, QQueryOperations>
      paragraphsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paragraphs');
    });
  }

  QueryBuilder<ArticleCache, DateTime, QQueryOperations> publishedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publishedAt');
    });
  }

  QueryBuilder<ArticleCache, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
