// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_prefs_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationPrefsCacheCollection on Isar {
  IsarCollection<NotificationPrefsCache> get notificationPrefsCaches =>
      this.collection();
}

const NotificationPrefsCacheSchema = CollectionSchema(
  name: r'NotificationPrefsCache',
  id: 6299327096720558592,
  properties: {
    r'anniversaryReminders': PropertySchema(
      id: 0,
      name: r'anniversaryReminders',
      type: IsarType.bool,
    ),
    r'dewormingReminders': PropertySchema(
      id: 1,
      name: r'dewormingReminders',
      type: IsarType.bool,
    ),
    r'pushEnabled': PropertySchema(
      id: 2,
      name: r'pushEnabled',
      type: IsarType.bool,
    ),
    r'userId': PropertySchema(
      id: 3,
      name: r'userId',
      type: IsarType.string,
    ),
    r'vaccineReminders': PropertySchema(
      id: 4,
      name: r'vaccineReminders',
      type: IsarType.bool,
    ),
    r'vetReminders': PropertySchema(
      id: 5,
      name: r'vetReminders',
      type: IsarType.bool,
    )
  },
  estimateSize: _notificationPrefsCacheEstimateSize,
  serialize: _notificationPrefsCacheSerialize,
  deserialize: _notificationPrefsCacheDeserialize,
  deserializeProp: _notificationPrefsCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _notificationPrefsCacheGetId,
  getLinks: _notificationPrefsCacheGetLinks,
  attach: _notificationPrefsCacheAttach,
  version: '3.1.0+1',
);

int _notificationPrefsCacheEstimateSize(
  NotificationPrefsCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _notificationPrefsCacheSerialize(
  NotificationPrefsCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.anniversaryReminders);
  writer.writeBool(offsets[1], object.dewormingReminders);
  writer.writeBool(offsets[2], object.pushEnabled);
  writer.writeString(offsets[3], object.userId);
  writer.writeBool(offsets[4], object.vaccineReminders);
  writer.writeBool(offsets[5], object.vetReminders);
}

NotificationPrefsCache _notificationPrefsCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationPrefsCache();
  object.anniversaryReminders = reader.readBool(offsets[0]);
  object.dewormingReminders = reader.readBool(offsets[1]);
  object.id = id;
  object.pushEnabled = reader.readBool(offsets[2]);
  object.userId = reader.readString(offsets[3]);
  object.vaccineReminders = reader.readBool(offsets[4]);
  object.vetReminders = reader.readBool(offsets[5]);
  return object;
}

P _notificationPrefsCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationPrefsCacheGetId(NotificationPrefsCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationPrefsCacheGetLinks(
    NotificationPrefsCache object) {
  return [];
}

void _notificationPrefsCacheAttach(
    IsarCollection<dynamic> col, Id id, NotificationPrefsCache object) {
  object.id = id;
}

extension NotificationPrefsCacheByIndex
    on IsarCollection<NotificationPrefsCache> {
  Future<NotificationPrefsCache?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  NotificationPrefsCache? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<NotificationPrefsCache?>> getAllByUserId(
      List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<NotificationPrefsCache?> getAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(NotificationPrefsCache object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(NotificationPrefsCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<NotificationPrefsCache> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<NotificationPrefsCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension NotificationPrefsCacheQueryWhereSort
    on QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QWhere> {
  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationPrefsCacheQueryWhere on QueryBuilder<
    NotificationPrefsCache, NotificationPrefsCache, QWhereClause> {
  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
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

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
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

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterWhereClause> userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterWhereClause> userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NotificationPrefsCacheQueryFilter on QueryBuilder<
    NotificationPrefsCache, NotificationPrefsCache, QFilterCondition> {
  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> anniversaryRemindersEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'anniversaryReminders',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> dewormingRemindersEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dewormingReminders',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
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

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
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

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
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

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> pushEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pushEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
          QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
          QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> vaccineRemindersEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vaccineReminders',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache,
      QAfterFilterCondition> vetRemindersEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetReminders',
        value: value,
      ));
    });
  }
}

extension NotificationPrefsCacheQueryObject on QueryBuilder<
    NotificationPrefsCache, NotificationPrefsCache, QFilterCondition> {}

extension NotificationPrefsCacheQueryLinks on QueryBuilder<
    NotificationPrefsCache, NotificationPrefsCache, QFilterCondition> {}

extension NotificationPrefsCacheQuerySortBy
    on QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QSortBy> {
  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByAnniversaryReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anniversaryReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByAnniversaryRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anniversaryReminders', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByDewormingReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dewormingReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByDewormingRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dewormingReminders', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByPushEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByVaccineReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByVaccineRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineReminders', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByVetReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      sortByVetRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetReminders', Sort.desc);
    });
  }
}

extension NotificationPrefsCacheQuerySortThenBy on QueryBuilder<
    NotificationPrefsCache, NotificationPrefsCache, QSortThenBy> {
  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByAnniversaryReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anniversaryReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByAnniversaryRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anniversaryReminders', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByDewormingReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dewormingReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByDewormingRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dewormingReminders', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByPushEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByVaccineReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByVaccineRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vaccineReminders', Sort.desc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByVetReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetReminders', Sort.asc);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QAfterSortBy>
      thenByVetRemindersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetReminders', Sort.desc);
    });
  }
}

extension NotificationPrefsCacheQueryWhereDistinct
    on QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct> {
  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct>
      distinctByAnniversaryReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'anniversaryReminders');
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct>
      distinctByDewormingReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dewormingReminders');
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct>
      distinctByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pushEnabled');
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct>
      distinctByVaccineReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vaccineReminders');
    });
  }

  QueryBuilder<NotificationPrefsCache, NotificationPrefsCache, QDistinct>
      distinctByVetReminders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vetReminders');
    });
  }
}

extension NotificationPrefsCacheQueryProperty on QueryBuilder<
    NotificationPrefsCache, NotificationPrefsCache, QQueryProperty> {
  QueryBuilder<NotificationPrefsCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationPrefsCache, bool, QQueryOperations>
      anniversaryRemindersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'anniversaryReminders');
    });
  }

  QueryBuilder<NotificationPrefsCache, bool, QQueryOperations>
      dewormingRemindersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dewormingReminders');
    });
  }

  QueryBuilder<NotificationPrefsCache, bool, QQueryOperations>
      pushEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pushEnabled');
    });
  }

  QueryBuilder<NotificationPrefsCache, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<NotificationPrefsCache, bool, QQueryOperations>
      vaccineRemindersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vaccineReminders');
    });
  }

  QueryBuilder<NotificationPrefsCache, bool, QQueryOperations>
      vetRemindersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vetReminders');
    });
  }
}
