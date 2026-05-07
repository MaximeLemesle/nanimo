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
    r'idEvent': PropertySchema(
      id: 1,
      name: r'idEvent',
      type: IsarType.string,
    ),
    r'idEventImage': PropertySchema(
      id: 2,
      name: r'idEventImage',
      type: IsarType.string,
    )
  },
  estimateSize: _eventImageCacheEstimateSize,
  serialize: _eventImageCacheSerialize,
  deserialize: _eventImageCacheDeserialize,
  deserializeProp: _eventImageCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'idEventImage': IndexSchema(
      id: 7888011538358742443,
      name: r'idEventImage',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idEventImage',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idEvent': IndexSchema(
      id: -72996493576358891,
      name: r'idEvent',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idEvent',
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
  bytesCount += 3 + object.idEvent.length * 3;
  bytesCount += 3 + object.idEventImage.length * 3;
  return bytesCount;
}

void _eventImageCacheSerialize(
  EventImageCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetPath);
  writer.writeString(offsets[1], object.idEvent);
  writer.writeString(offsets[2], object.idEventImage);
}

EventImageCache _eventImageCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EventImageCache();
  object.assetPath = reader.readString(offsets[0]);
  object.id = id;
  object.idEvent = reader.readString(offsets[1]);
  object.idEventImage = reader.readString(offsets[2]);
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
  Future<EventImageCache?> getByIdEventImage(String idEventImage) {
    return getByIndex(r'idEventImage', [idEventImage]);
  }

  EventImageCache? getByIdEventImageSync(String idEventImage) {
    return getByIndexSync(r'idEventImage', [idEventImage]);
  }

  Future<bool> deleteByIdEventImage(String idEventImage) {
    return deleteByIndex(r'idEventImage', [idEventImage]);
  }

  bool deleteByIdEventImageSync(String idEventImage) {
    return deleteByIndexSync(r'idEventImage', [idEventImage]);
  }

  Future<List<EventImageCache?>> getAllByIdEventImage(
      List<String> idEventImageValues) {
    final values = idEventImageValues.map((e) => [e]).toList();
    return getAllByIndex(r'idEventImage', values);
  }

  List<EventImageCache?> getAllByIdEventImageSync(
      List<String> idEventImageValues) {
    final values = idEventImageValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idEventImage', values);
  }

  Future<int> deleteAllByIdEventImage(List<String> idEventImageValues) {
    final values = idEventImageValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idEventImage', values);
  }

  int deleteAllByIdEventImageSync(List<String> idEventImageValues) {
    final values = idEventImageValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idEventImage', values);
  }

  Future<Id> putByIdEventImage(EventImageCache object) {
    return putByIndex(r'idEventImage', object);
  }

  Id putByIdEventImageSync(EventImageCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'idEventImage', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdEventImage(List<EventImageCache> objects) {
    return putAllByIndex(r'idEventImage', objects);
  }

  List<Id> putAllByIdEventImageSync(List<EventImageCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idEventImage', objects, saveLinks: saveLinks);
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
      idEventImageEqualTo(String idEventImage) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idEventImage',
        value: [idEventImage],
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      idEventImageNotEqualTo(String idEventImage) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEventImage',
              lower: [],
              upper: [idEventImage],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEventImage',
              lower: [idEventImage],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEventImage',
              lower: [idEventImage],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEventImage',
              lower: [],
              upper: [idEventImage],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      idEventEqualTo(String idEvent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idEvent',
        value: [idEvent],
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterWhereClause>
      idEventNotEqualTo(String idEvent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEvent',
              lower: [],
              upper: [idEvent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEvent',
              lower: [idEvent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEvent',
              lower: [idEvent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idEvent',
              lower: [],
              upper: [idEvent],
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idEvent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idEvent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEvent',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idEvent',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEventImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idEventImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idEventImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idEventImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idEventImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idEventImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idEventImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idEventImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idEventImage',
        value: '',
      ));
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterFilterCondition>
      idEventImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idEventImage',
        value: '',
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy> sortByIdEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEvent', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByIdEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEvent', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByIdEventImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEventImage', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      sortByIdEventImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEventImage', Sort.desc);
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

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy> thenByIdEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEvent', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByIdEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEvent', Sort.desc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByIdEventImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEventImage', Sort.asc);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QAfterSortBy>
      thenByIdEventImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idEventImage', Sort.desc);
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

  QueryBuilder<EventImageCache, EventImageCache, QDistinct> distinctByIdEvent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idEvent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventImageCache, EventImageCache, QDistinct>
      distinctByIdEventImage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idEventImage', caseSensitive: caseSensitive);
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

  QueryBuilder<EventImageCache, String, QQueryOperations> idEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idEvent');
    });
  }

  QueryBuilder<EventImageCache, String, QQueryOperations>
      idEventImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idEventImage');
    });
  }
}
