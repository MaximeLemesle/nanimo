// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserCacheCollection on Isar {
  IsarCollection<UserCache> get userCaches => this.collection();
}

const UserCacheSchema = CollectionSchema(
  name: r'UserCache',
  id: 7644985736581713414,
  properties: {
    r'idUser': PropertySchema(
      id: 0,
      name: r'idUser',
      type: IsarType.string,
    ),
    r'mail': PropertySchema(
      id: 1,
      name: r'mail',
      type: IsarType.string,
    ),
    r'subscriptionExpiresAt': PropertySchema(
      id: 2,
      name: r'subscriptionExpiresAt',
      type: IsarType.dateTime,
    ),
    r'subscriptionStatus': PropertySchema(
      id: 3,
      name: r'subscriptionStatus',
      type: IsarType.string,
    ),
    r'userName': PropertySchema(
      id: 4,
      name: r'userName',
      type: IsarType.string,
    )
  },
  estimateSize: _userCacheEstimateSize,
  serialize: _userCacheSerialize,
  deserialize: _userCacheDeserialize,
  deserializeProp: _userCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'idUser': IndexSchema(
      id: 4457735720952084498,
      name: r'idUser',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idUser',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userCacheGetId,
  getLinks: _userCacheGetLinks,
  attach: _userCacheAttach,
  version: '3.1.0+1',
);

int _userCacheEstimateSize(
  UserCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.idUser.length * 3;
  bytesCount += 3 + object.mail.length * 3;
  bytesCount += 3 + object.subscriptionStatus.length * 3;
  {
    final value = object.userName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userCacheSerialize(
  UserCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.idUser);
  writer.writeString(offsets[1], object.mail);
  writer.writeDateTime(offsets[2], object.subscriptionExpiresAt);
  writer.writeString(offsets[3], object.subscriptionStatus);
  writer.writeString(offsets[4], object.userName);
}

UserCache _userCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserCache();
  object.id = id;
  object.idUser = reader.readString(offsets[0]);
  object.mail = reader.readString(offsets[1]);
  object.subscriptionExpiresAt = reader.readDateTimeOrNull(offsets[2]);
  object.subscriptionStatus = reader.readString(offsets[3]);
  object.userName = reader.readStringOrNull(offsets[4]);
  return object;
}

P _userCacheDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userCacheGetId(UserCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userCacheGetLinks(UserCache object) {
  return [];
}

void _userCacheAttach(IsarCollection<dynamic> col, Id id, UserCache object) {
  object.id = id;
}

extension UserCacheByIndex on IsarCollection<UserCache> {
  Future<UserCache?> getByIdUser(String idUser) {
    return getByIndex(r'idUser', [idUser]);
  }

  UserCache? getByIdUserSync(String idUser) {
    return getByIndexSync(r'idUser', [idUser]);
  }

  Future<bool> deleteByIdUser(String idUser) {
    return deleteByIndex(r'idUser', [idUser]);
  }

  bool deleteByIdUserSync(String idUser) {
    return deleteByIndexSync(r'idUser', [idUser]);
  }

  Future<List<UserCache?>> getAllByIdUser(List<String> idUserValues) {
    final values = idUserValues.map((e) => [e]).toList();
    return getAllByIndex(r'idUser', values);
  }

  List<UserCache?> getAllByIdUserSync(List<String> idUserValues) {
    final values = idUserValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idUser', values);
  }

  Future<int> deleteAllByIdUser(List<String> idUserValues) {
    final values = idUserValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idUser', values);
  }

  int deleteAllByIdUserSync(List<String> idUserValues) {
    final values = idUserValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idUser', values);
  }

  Future<Id> putByIdUser(UserCache object) {
    return putByIndex(r'idUser', object);
  }

  Id putByIdUserSync(UserCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'idUser', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdUser(List<UserCache> objects) {
    return putAllByIndex(r'idUser', objects);
  }

  List<Id> putAllByIdUserSync(List<UserCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idUser', objects, saveLinks: saveLinks);
  }
}

extension UserCacheQueryWhereSort
    on QueryBuilder<UserCache, UserCache, QWhere> {
  QueryBuilder<UserCache, UserCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserCacheQueryWhere
    on QueryBuilder<UserCache, UserCache, QWhereClause> {
  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idUserEqualTo(
      String idUser) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idUser',
        value: [idUser],
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterWhereClause> idUserNotEqualTo(
      String idUser) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUser',
              lower: [],
              upper: [idUser],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUser',
              lower: [idUser],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUser',
              lower: [idUser],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idUser',
              lower: [],
              upper: [idUser],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UserCacheQueryFilter
    on QueryBuilder<UserCache, UserCache, QFilterCondition> {
  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idUser',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idUser',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idUser',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idUser',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> idUserIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idUser',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mail',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> mailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mail',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionExpiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subscriptionExpiresAt',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionExpiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subscriptionExpiresAt',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionExpiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionExpiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionExpiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionExpiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionExpiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionExpiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionExpiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionExpiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subscriptionStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      subscriptionStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subscriptionStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition> userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterFilterCondition>
      userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userName',
        value: '',
      ));
    });
  }
}

extension UserCacheQueryObject
    on QueryBuilder<UserCache, UserCache, QFilterCondition> {}

extension UserCacheQueryLinks
    on QueryBuilder<UserCache, UserCache, QFilterCondition> {}

extension UserCacheQuerySortBy on QueryBuilder<UserCache, UserCache, QSortBy> {
  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortByIdUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUser', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortByIdUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUser', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortByMail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mail', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortByMailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mail', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy>
      sortBySubscriptionExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiresAt', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy>
      sortBySubscriptionExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiresAt', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortBySubscriptionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy>
      sortBySubscriptionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension UserCacheQuerySortThenBy
    on QueryBuilder<UserCache, UserCache, QSortThenBy> {
  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByIdUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUser', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByIdUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idUser', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByMail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mail', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByMailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mail', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy>
      thenBySubscriptionExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiresAt', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy>
      thenBySubscriptionExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiresAt', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenBySubscriptionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy>
      thenBySubscriptionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.desc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<UserCache, UserCache, QAfterSortBy> thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension UserCacheQueryWhereDistinct
    on QueryBuilder<UserCache, UserCache, QDistinct> {
  QueryBuilder<UserCache, UserCache, QDistinct> distinctByIdUser(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idUser', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserCache, UserCache, QDistinct> distinctByMail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserCache, UserCache, QDistinct>
      distinctBySubscriptionExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionExpiresAt');
    });
  }

  QueryBuilder<UserCache, UserCache, QDistinct> distinctBySubscriptionStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserCache, UserCache, QDistinct> distinctByUserName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension UserCacheQueryProperty
    on QueryBuilder<UserCache, UserCache, QQueryProperty> {
  QueryBuilder<UserCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserCache, String, QQueryOperations> idUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idUser');
    });
  }

  QueryBuilder<UserCache, String, QQueryOperations> mailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mail');
    });
  }

  QueryBuilder<UserCache, DateTime?, QQueryOperations>
      subscriptionExpiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionExpiresAt');
    });
  }

  QueryBuilder<UserCache, String, QQueryOperations>
      subscriptionStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionStatus');
    });
  }

  QueryBuilder<UserCache, String?, QQueryOperations> userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}
