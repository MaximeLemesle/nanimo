// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEventImageCacheCollection on Isar {
  IsarCollection<EventImageCache> get eventImageCaches => this.collection();
}

const EventImageCacheSchema = CollectionSchema(
  name: r'EventImageCache',
  id: 2275463598409469049,
  properties: {
    r'assetPath': PropertySchema(
      id: 0,
      name: r'assetPath',
      type: IsarType.string,
    ),
    r'eventId': PropertySchema(
      id: 1,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'eventImageId': PropertySchema(
      id: 2,
      name: r'eventImageId',
      type: IsarType.string,
    )
  },
  estimateSize: _eventImageCacheEstimateSize,
  serialize: _eventImageCacheSerialize,
  deserialize: _eventImageCacheDeserialize,
  deserializeProp: _eventImageCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'eventImageId': IndexSchema(
      id: 6782498299685691037,
      name: r'eventImageId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'eventImageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'eventId': IndexSchema(
      id: -2707901133518603130,
      name: r'eventId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'eventId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _eventImageCacheGetId,
  getLinks: _eventImageCacheGetLinks,
  attach: _eventImageCacheAttach,
  version: '3.1.0+1',
);

int _eventImageCacheEstimateSize(
  EventImageCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetPath.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.eventImageId.length * 3;
  return bytesCount;
}

void _eventImageCacheSerialize(
  EventImageCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetPath);
  writer.writeString(offsets[1], object.eventId);
  writer.writeString(offsets[2], object.eventImageId);
}

EventImageCache _eventImageCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EventImageCache();
  object.assetPath = reader.readString(offsets[0]);
  object.eventId = reader.readString(offsets[1]);
  object.eventImageId = reader.readString(offsets[2]);
  object.id = id;
  return object;
}

P _eventImageCacheDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _eventImageCacheGetId(EventImageCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _eventImageCacheGetLinks(EventImageCache object) {
  return [];
}

void _eventImageCacheAttach(
    IsarCollection<dynamic> col, Id id, EventImageCache object) {
  object.id = id;
}

extension EventImageCacheByIndex on IsarCollection<EventImageCache> {
  Future<EventImageCache?> getByEventImageId(String eventImageId) {
    return getByIndex(r'eventImageId', [eventImageId]);
  }

  EventImageCache? getByEventImageIdSync(String eventImageId) {
    return getByIndexSync(r'eventImageId', [eventImageId]);
  }

  Future<bool> deleteByEventImageId(String eventImageId) {
    return deleteByIndex(r'eventImageId', [eventImageId]);
  }

  bool deleteByEventImageIdSync(String eventImageId) {
    return deleteByIndexSync(r'eventImageId', [eventImageId]);
  }

  Future<List<EventImageCache?>> getAllByEventImageId(
      List<String> eventImageIdValues) {
    final values = eventImageIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'eventImageId', values);
  }

  List<EventImageCache?> getAllByEventImageIdSync(
      List<String> eventImageIdValues) {
    final values = eventImageIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'eventImageId', values);
  }

  Future<int> deleteAllByEventImageId(List<String> eventImageIdValues) {
    final values = eventImageIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'eventImageId', values);
  }

  int deleteAllByEventImageIdSync(List<String> eventImageIdValues) {
    final values = eventImageIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'eventImageId', values);
  }

  Future<Id> putByEventImageId(EventImageCache object) {
    return putByIndex(r'eventImageId', object);
  }

  Id putByEventImageIdSync(EventImageCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'eventImageId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEventImageId(List<EventImageCache> objects) {
    return putAllByIndex(r'eventImageId', objects);
  }

  List<Id> putAllByEventImageIdSync(List<EventImageCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'eventImageId', objects, saveLinks: saveLinks);
  }
}

extension EventImageCacheQueryWhereSort
    on QueryBuilder<EventImageCache, EventImageCache, QWhere> {
  QueryBuilder<EventImageCache, EventImageCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EventImageCacheQueryWhere
    on QueryBuilder<EventImageCache, EventImageCache, QWhereClause> {
  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      eventImageIdEqualTo(String eventImageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventImageId',
        value: [eventImageId],
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      eventImageIdNotEqualTo(String eventImageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventImageId',
              lower: [],
              upper: [eventImageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventImageId',
              lower: [eventImageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventImageId',
              lower: [eventImageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventImageId',
              lower: [],
              upper: [eventImageId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      eventIdEqualTo(String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      eventIdNotEqualTo(String eventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EventImageCacheQueryFilter
    on QueryBuilder<EventImageCache, EventImageCache, QFilterCondition> {
  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      assetPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventImageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventImageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventImageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventImageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventImageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventImageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventImageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventImageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventImageId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      eventImageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventImageId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
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
}

extension EventImageCacheQueryObject
    on QueryBuilder<EventImageCache, EventImageCache, QFilterCondition> {}

extension EventImageCacheQueryLinks
    on QueryBuilder<EventImageCache, EventImageCache, QFilterCondition> {}

extension EventImageCacheQuerySortBy
    on QueryBuilder<EventImageCache, EventImageCache, QSortBy> {
  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByEventImageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventImageId', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByEventImageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventImageId', Sort.desc);
    });
  }
}

extension EventImageCacheQuerySortThenBy
    on QueryBuilder<EventImageCache, EventImageCache, QSortThenBy> {
  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByEventImageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventImageId', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByEventImageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventImageId', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension EventImageCacheQueryWhereDistinct
    on QueryBuilder<EventImageCache, EventImageCache, QDistinct> {
  QueryBuilder<EventImageCache, EventImageCache, QDistinct> distinctByAssetPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QDistinct>
      distinctByEventImageId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventImageId', caseSensitive: caseSensitive);
    });
  }
}

extension EventImageCacheQueryProperty
    on QueryBuilder<EventImageCache, EventImageCache, QQueryProperty> {
  QueryBuilder<EventImageCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EventImageCache, String, QQueryOperations> assetPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetPath');
    });
  }

  QueryBuilder<EventImageCache, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<EventImageCache, String, QQueryOperations>
      eventImageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventImageId');
    });
  }
}
