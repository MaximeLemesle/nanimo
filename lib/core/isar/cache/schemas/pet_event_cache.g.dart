// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_event_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPetEventCacheCollection on Isar {
  IsarCollection<PetEventCache> get petEventCaches => this.collection();
}

const PetEventCacheSchema = CollectionSchema(
  name: r'PetEventCache',
  id: 4199162700036365805,
  properties: {
    r'eventId': PropertySchema(
      id: 0,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'petEventId': PropertySchema(
      id: 1,
      name: r'petEventId',
      type: IsarType.string,
    ),
    r'petId': PropertySchema(
      id: 2,
      name: r'petId',
      type: IsarType.string,
    )
  },
  estimateSize: _petEventCacheEstimateSize,
  serialize: _petEventCacheSerialize,
  deserialize: _petEventCacheDeserialize,
  deserializeProp: _petEventCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'petEventId': IndexSchema(
      id: -9164749710464284990,
      name: r'petEventId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petEventId',
          type: IndexType.hash,
          caseSensitive: true,
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
  getId: _petEventCacheGetId,
  getLinks: _petEventCacheGetLinks,
  attach: _petEventCacheAttach,
  version: '3.1.0+1',
);

int _petEventCacheEstimateSize(
  PetEventCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.petEventId.length * 3;
  bytesCount += 3 + object.petId.length * 3;
  return bytesCount;
}

void _petEventCacheSerialize(
  PetEventCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.eventId);
  writer.writeString(offsets[1], object.petEventId);
  writer.writeString(offsets[2], object.petId);
}

PetEventCache _petEventCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PetEventCache();
  object.eventId = reader.readString(offsets[0]);
  object.id = id;
  object.petEventId = reader.readString(offsets[1]);
  object.petId = reader.readString(offsets[2]);
  return object;
}

P _petEventCacheDeserializeProp<P>(
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

Id _petEventCacheGetId(PetEventCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _petEventCacheGetLinks(PetEventCache object) {
  return [];
}

void _petEventCacheAttach(
    IsarCollection<dynamic> col, Id id, PetEventCache object) {
  object.id = id;
}

extension PetEventCacheByIndex on IsarCollection<PetEventCache> {
  Future<PetEventCache?> getByPetEventId(String petEventId) {
    return getByIndex(r'petEventId', [petEventId]);
  }

  PetEventCache? getByPetEventIdSync(String petEventId) {
    return getByIndexSync(r'petEventId', [petEventId]);
  }

  Future<bool> deleteByPetEventId(String petEventId) {
    return deleteByIndex(r'petEventId', [petEventId]);
  }

  bool deleteByPetEventIdSync(String petEventId) {
    return deleteByIndexSync(r'petEventId', [petEventId]);
  }

  Future<List<PetEventCache?>> getAllByPetEventId(
      List<String> petEventIdValues) {
    final values = petEventIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'petEventId', values);
  }

  List<PetEventCache?> getAllByPetEventIdSync(List<String> petEventIdValues) {
    final values = petEventIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'petEventId', values);
  }

  Future<int> deleteAllByPetEventId(List<String> petEventIdValues) {
    final values = petEventIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'petEventId', values);
  }

  int deleteAllByPetEventIdSync(List<String> petEventIdValues) {
    final values = petEventIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'petEventId', values);
  }

  Future<Id> putByPetEventId(PetEventCache object) {
    return putByIndex(r'petEventId', object);
  }

  Id putByPetEventIdSync(PetEventCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'petEventId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPetEventId(List<PetEventCache> objects) {
    return putAllByIndex(r'petEventId', objects);
  }

  List<Id> putAllByPetEventIdSync(List<PetEventCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'petEventId', objects, saveLinks: saveLinks);
  }
}

extension PetEventCacheQueryWhereSort
    on QueryBuilder<PetEventCache, PetEventCache, QWhere> {
  QueryBuilder<PetEventCache, PetEventCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PetEventCacheQueryWhere
    on QueryBuilder<PetEventCache, PetEventCache, QWhereClause> {
  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause>
      petEventIdEqualTo(String petEventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petEventId',
        value: [petEventId],
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause>
      petEventIdNotEqualTo(String petEventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petEventId',
              lower: [],
              upper: [petEventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petEventId',
              lower: [petEventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petEventId',
              lower: [petEventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petEventId',
              lower: [],
              upper: [petEventId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> petIdEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petId',
        value: [petId],
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> petIdNotEqualTo(
      String petId) {
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause> eventIdEqualTo(
      String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterWhereClause>
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

extension PetEventCacheQueryFilter
    on QueryBuilder<PetEventCache, PetEventCache, QFilterCondition> {
  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petEventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petEventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petEventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
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

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterFilterCondition>
      petIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petId',
        value: '',
      ));
    });
  }
}

extension PetEventCacheQueryObject
    on QueryBuilder<PetEventCache, PetEventCache, QFilterCondition> {}

extension PetEventCacheQueryLinks
    on QueryBuilder<PetEventCache, PetEventCache, QFilterCondition> {}

extension PetEventCacheQuerySortBy
    on QueryBuilder<PetEventCache, PetEventCache, QSortBy> {
  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> sortByPetEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petEventId', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy>
      sortByPetEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petEventId', Sort.desc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> sortByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> sortByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
    });
  }
}

extension PetEventCacheQuerySortThenBy
    on QueryBuilder<PetEventCache, PetEventCache, QSortThenBy> {
  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenByPetEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petEventId', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy>
      thenByPetEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petEventId', Sort.desc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QAfterSortBy> thenByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
    });
  }
}

extension PetEventCacheQueryWhereDistinct
    on QueryBuilder<PetEventCache, PetEventCache, QDistinct> {
  QueryBuilder<PetEventCache, PetEventCache, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QDistinct> distinctByPetEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petEventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetEventCache, PetEventCache, QDistinct> distinctByPetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petId', caseSensitive: caseSensitive);
    });
  }
}

extension PetEventCacheQueryProperty
    on QueryBuilder<PetEventCache, PetEventCache, QQueryProperty> {
  QueryBuilder<PetEventCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PetEventCache, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<PetEventCache, String, QQueryOperations> petEventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petEventId');
    });
  }

  QueryBuilder<PetEventCache, String, QQueryOperations> petIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petId');
    });
  }
}
