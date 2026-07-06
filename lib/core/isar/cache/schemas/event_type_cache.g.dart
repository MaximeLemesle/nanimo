// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_type_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEventTypeCacheCollection on Isar {
  IsarCollection<EventTypeCache> get eventTypeCaches => this.collection();
}

const EventTypeCacheSchema = CollectionSchema(
  name: r'EventTypeCache',
  id: -2375426031303618173,
  properties: {
    r'code': PropertySchema(
      id: 0,
      name: r'code',
      type: IsarType.string,
    ),
    r'eventTypeId': PropertySchema(
      id: 1,
      name: r'eventTypeId',
      type: IsarType.string,
    ),
    r'isPremium': PropertySchema(
      id: 2,
      name: r'isPremium',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _eventTypeCacheEstimateSize,
  serialize: _eventTypeCacheSerialize,
  deserialize: _eventTypeCacheDeserialize,
  deserializeProp: _eventTypeCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'eventTypeId': IndexSchema(
      id: -3593908424487392989,
      name: r'eventTypeId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'eventTypeId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _eventTypeCacheGetId,
  getLinks: _eventTypeCacheGetLinks,
  attach: _eventTypeCacheAttach,
  version: '3.1.0+1',
);

int _eventTypeCacheEstimateSize(
  EventTypeCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.code;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.eventTypeId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _eventTypeCacheSerialize(
  EventTypeCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.code);
  writer.writeString(offsets[1], object.eventTypeId);
  writer.writeBool(offsets[2], object.isPremium);
  writer.writeString(offsets[3], object.name);
}

EventTypeCache _eventTypeCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EventTypeCache();
  object.code = reader.readStringOrNull(offsets[0]);
  object.eventTypeId = reader.readString(offsets[1]);
  object.id = id;
  object.isPremium = reader.readBool(offsets[2]);
  object.name = reader.readString(offsets[3]);
  return object;
}

P _eventTypeCacheDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _eventTypeCacheGetId(EventTypeCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _eventTypeCacheGetLinks(EventTypeCache object) {
  return [];
}

void _eventTypeCacheAttach(
    IsarCollection<dynamic> col, Id id, EventTypeCache object) {
  object.id = id;
}

extension EventTypeCacheByIndex on IsarCollection<EventTypeCache> {
  Future<EventTypeCache?> getByEventTypeId(String eventTypeId) {
    return getByIndex(r'eventTypeId', [eventTypeId]);
  }

  EventTypeCache? getByEventTypeIdSync(String eventTypeId) {
    return getByIndexSync(r'eventTypeId', [eventTypeId]);
  }

  Future<bool> deleteByEventTypeId(String eventTypeId) {
    return deleteByIndex(r'eventTypeId', [eventTypeId]);
  }

  bool deleteByEventTypeIdSync(String eventTypeId) {
    return deleteByIndexSync(r'eventTypeId', [eventTypeId]);
  }

  Future<List<EventTypeCache?>> getAllByEventTypeId(
      List<String> eventTypeIdValues) {
    final values = eventTypeIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'eventTypeId', values);
  }

  List<EventTypeCache?> getAllByEventTypeIdSync(
      List<String> eventTypeIdValues) {
    final values = eventTypeIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'eventTypeId', values);
  }

  Future<int> deleteAllByEventTypeId(List<String> eventTypeIdValues) {
    final values = eventTypeIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'eventTypeId', values);
  }

  int deleteAllByEventTypeIdSync(List<String> eventTypeIdValues) {
    final values = eventTypeIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'eventTypeId', values);
  }

  Future<Id> putByEventTypeId(EventTypeCache object) {
    return putByIndex(r'eventTypeId', object);
  }

  Id putByEventTypeIdSync(EventTypeCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'eventTypeId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEventTypeId(List<EventTypeCache> objects) {
    return putAllByIndex(r'eventTypeId', objects);
  }

  List<Id> putAllByEventTypeIdSync(List<EventTypeCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'eventTypeId', objects, saveLinks: saveLinks);
  }
}

extension EventTypeCacheQueryWhereSort
    on QueryBuilder<EventTypeCache, EventTypeCache, QWhere> {
  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EventTypeCacheQueryWhere
    on QueryBuilder<EventTypeCache, EventTypeCache, QWhereClause> {
  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause>
      eventTypeIdEqualTo(String eventTypeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventTypeId',
        value: [eventTypeId],
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterWhereClause>
      eventTypeIdNotEqualTo(String eventTypeId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventTypeId',
              lower: [],
              upper: [eventTypeId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventTypeId',
              lower: [eventTypeId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventTypeId',
              lower: [eventTypeId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventTypeId',
              lower: [],
              upper: [eventTypeId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EventTypeCacheQueryFilter
    on QueryBuilder<EventTypeCache, EventTypeCache, QFilterCondition> {
  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventTypeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventTypeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventTypeId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      eventTypeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventTypeId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
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

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
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

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      isPremiumEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPremium',
        value: value,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension EventTypeCacheQueryObject
    on QueryBuilder<EventTypeCache, EventTypeCache, QFilterCondition> {}

extension EventTypeCacheQueryLinks
    on QueryBuilder<EventTypeCache, EventTypeCache, QFilterCondition> {}

extension EventTypeCacheQuerySortBy
    on QueryBuilder<EventTypeCache, EventTypeCache, QSortBy> {
  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy>
      sortByEventTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventTypeId', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy>
      sortByEventTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventTypeId', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> sortByIsPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy>
      sortByIsPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension EventTypeCacheQuerySortThenBy
    on QueryBuilder<EventTypeCache, EventTypeCache, QSortThenBy> {
  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy>
      thenByEventTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventTypeId', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy>
      thenByEventTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventTypeId', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenByIsPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy>
      thenByIsPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.desc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension EventTypeCacheQueryWhereDistinct
    on QueryBuilder<EventTypeCache, EventTypeCache, QDistinct> {
  QueryBuilder<EventTypeCache, EventTypeCache, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QDistinct> distinctByEventTypeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventTypeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QDistinct>
      distinctByIsPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPremium');
    });
  }

  QueryBuilder<EventTypeCache, EventTypeCache, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension EventTypeCacheQueryProperty
    on QueryBuilder<EventTypeCache, EventTypeCache, QQueryProperty> {
  QueryBuilder<EventTypeCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EventTypeCache, String?, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<EventTypeCache, String, QQueryOperations> eventTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventTypeId');
    });
  }

  QueryBuilder<EventTypeCache, bool, QQueryOperations> isPremiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPremium');
    });
  }

  QueryBuilder<EventTypeCache, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
