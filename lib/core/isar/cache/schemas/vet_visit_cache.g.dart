// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vet_visit_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVetVisitCacheCollection on Isar {
  IsarCollection<VetVisitCache> get vetVisitCaches => this.collection();
}

const VetVisitCacheSchema = CollectionSchema(
  name: r'VetVisitCache',
  id: 4402653129602353447,
  properties: {
    r'clinicName': PropertySchema(
      id: 0,
      name: r'clinicName',
      type: IsarType.string,
    ),
    r'petId': PropertySchema(
      id: 1,
      name: r'petId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    ),
    r'vetName': PropertySchema(
      id: 3,
      name: r'vetName',
      type: IsarType.string,
    ),
    r'vetVisitId': PropertySchema(
      id: 4,
      name: r'vetVisitId',
      type: IsarType.string,
    ),
    r'visitedAt': PropertySchema(
      id: 5,
      name: r'visitedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _vetVisitCacheEstimateSize,
  serialize: _vetVisitCacheSerialize,
  deserialize: _vetVisitCacheDeserialize,
  deserializeProp: _vetVisitCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'vetVisitId': IndexSchema(
      id: -6445043672712305397,
      name: r'vetVisitId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'vetVisitId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'visitedAt': IndexSchema(
      id: 8115807346029026041,
      name: r'visitedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'visitedAt',
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
  getId: _vetVisitCacheGetId,
  getLinks: _vetVisitCacheGetLinks,
  attach: _vetVisitCacheAttach,
  version: '3.1.0+1',
);

int _vetVisitCacheEstimateSize(
  VetVisitCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.clinicName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.petId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.vetName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.vetVisitId.length * 3;
  return bytesCount;
}

void _vetVisitCacheSerialize(
  VetVisitCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clinicName);
  writer.writeString(offsets[1], object.petId);
  writer.writeString(offsets[2], object.title);
  writer.writeString(offsets[3], object.vetName);
  writer.writeString(offsets[4], object.vetVisitId);
  writer.writeDateTime(offsets[5], object.visitedAt);
}

VetVisitCache _vetVisitCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VetVisitCache();
  object.clinicName = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.petId = reader.readString(offsets[1]);
  object.title = reader.readString(offsets[2]);
  object.vetName = reader.readStringOrNull(offsets[3]);
  object.vetVisitId = reader.readString(offsets[4]);
  object.visitedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _vetVisitCacheDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vetVisitCacheGetId(VetVisitCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vetVisitCacheGetLinks(VetVisitCache object) {
  return [];
}

void _vetVisitCacheAttach(
    IsarCollection<dynamic> col, Id id, VetVisitCache object) {
  object.id = id;
}

extension VetVisitCacheByIndex on IsarCollection<VetVisitCache> {
  Future<VetVisitCache?> getByVetVisitId(String vetVisitId) {
    return getByIndex(r'vetVisitId', [vetVisitId]);
  }

  VetVisitCache? getByVetVisitIdSync(String vetVisitId) {
    return getByIndexSync(r'vetVisitId', [vetVisitId]);
  }

  Future<bool> deleteByVetVisitId(String vetVisitId) {
    return deleteByIndex(r'vetVisitId', [vetVisitId]);
  }

  bool deleteByVetVisitIdSync(String vetVisitId) {
    return deleteByIndexSync(r'vetVisitId', [vetVisitId]);
  }

  Future<List<VetVisitCache?>> getAllByVetVisitId(
      List<String> vetVisitIdValues) {
    final values = vetVisitIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'vetVisitId', values);
  }

  List<VetVisitCache?> getAllByVetVisitIdSync(List<String> vetVisitIdValues) {
    final values = vetVisitIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'vetVisitId', values);
  }

  Future<int> deleteAllByVetVisitId(List<String> vetVisitIdValues) {
    final values = vetVisitIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'vetVisitId', values);
  }

  int deleteAllByVetVisitIdSync(List<String> vetVisitIdValues) {
    final values = vetVisitIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'vetVisitId', values);
  }

  Future<Id> putByVetVisitId(VetVisitCache object) {
    return putByIndex(r'vetVisitId', object);
  }

  Id putByVetVisitIdSync(VetVisitCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'vetVisitId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByVetVisitId(List<VetVisitCache> objects) {
    return putAllByIndex(r'vetVisitId', objects);
  }

  List<Id> putAllByVetVisitIdSync(List<VetVisitCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'vetVisitId', objects, saveLinks: saveLinks);
  }
}

extension VetVisitCacheQueryWhereSort
    on QueryBuilder<VetVisitCache, VetVisitCache, QWhere> {
  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhere> anyVisitedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'visitedAt'),
      );
    });
  }
}

extension VetVisitCacheQueryWhere
    on QueryBuilder<VetVisitCache, VetVisitCache, QWhereClause> {
  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      vetVisitIdEqualTo(String vetVisitId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'vetVisitId',
        value: [vetVisitId],
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      vetVisitIdNotEqualTo(String vetVisitId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vetVisitId',
              lower: [],
              upper: [vetVisitId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vetVisitId',
              lower: [vetVisitId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vetVisitId',
              lower: [vetVisitId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vetVisitId',
              lower: [],
              upper: [vetVisitId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      visitedAtEqualTo(DateTime visitedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'visitedAt',
        value: [visitedAt],
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      visitedAtNotEqualTo(DateTime visitedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitedAt',
              lower: [],
              upper: [visitedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitedAt',
              lower: [visitedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitedAt',
              lower: [visitedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitedAt',
              lower: [],
              upper: [visitedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      visitedAtGreaterThan(
    DateTime visitedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'visitedAt',
        lower: [visitedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      visitedAtLessThan(
    DateTime visitedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'visitedAt',
        lower: [],
        upper: [visitedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause>
      visitedAtBetween(
    DateTime lowerVisitedAt,
    DateTime upperVisitedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'visitedAt',
        lower: [lowerVisitedAt],
        includeLower: includeLower,
        upper: [upperVisitedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> petIdEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petId',
        value: [petId],
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterWhereClause> petIdNotEqualTo(
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
}

extension VetVisitCacheQueryFilter
    on QueryBuilder<VetVisitCache, VetVisitCache, QFilterCondition> {
  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clinicName',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clinicName',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clinicName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clinicName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clinicName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clinicName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clinicName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clinicName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clinicName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clinicName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clinicName',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      clinicNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clinicName',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      petIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      petIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      petIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      petIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleEqualTo(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleLessThan(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleBetween(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleEndsWith(
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

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vetName',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vetName',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vetName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vetName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetName',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vetName',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetVisitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vetVisitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vetVisitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vetVisitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vetVisitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vetVisitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vetVisitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vetVisitId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetVisitId',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      vetVisitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vetVisitId',
        value: '',
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      visitedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visitedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      visitedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visitedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      visitedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visitedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterFilterCondition>
      visitedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visitedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VetVisitCacheQueryObject
    on QueryBuilder<VetVisitCache, VetVisitCache, QFilterCondition> {}

extension VetVisitCacheQueryLinks
    on QueryBuilder<VetVisitCache, VetVisitCache, QFilterCondition> {}

extension VetVisitCacheQuerySortBy
    on QueryBuilder<VetVisitCache, VetVisitCache, QSortBy> {
  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByClinicName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clinicName', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy>
      sortByClinicNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clinicName', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByVetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByVetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByVetVisitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetVisitId', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy>
      sortByVetVisitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetVisitId', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> sortByVisitedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitedAt', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy>
      sortByVisitedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitedAt', Sort.desc);
    });
  }
}

extension VetVisitCacheQuerySortThenBy
    on QueryBuilder<VetVisitCache, VetVisitCache, QSortThenBy> {
  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByClinicName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clinicName', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy>
      thenByClinicNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clinicName', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByVetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByVetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByVetVisitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetVisitId', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy>
      thenByVetVisitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetVisitId', Sort.desc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy> thenByVisitedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitedAt', Sort.asc);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QAfterSortBy>
      thenByVisitedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitedAt', Sort.desc);
    });
  }
}

extension VetVisitCacheQueryWhereDistinct
    on QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> {
  QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> distinctByClinicName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clinicName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> distinctByPetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> distinctByVetName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vetName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> distinctByVetVisitId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vetVisitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VetVisitCache, VetVisitCache, QDistinct> distinctByVisitedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visitedAt');
    });
  }
}

extension VetVisitCacheQueryProperty
    on QueryBuilder<VetVisitCache, VetVisitCache, QQueryProperty> {
  QueryBuilder<VetVisitCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VetVisitCache, String?, QQueryOperations> clinicNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clinicName');
    });
  }

  QueryBuilder<VetVisitCache, String, QQueryOperations> petIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petId');
    });
  }

  QueryBuilder<VetVisitCache, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<VetVisitCache, String?, QQueryOperations> vetNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vetName');
    });
  }

  QueryBuilder<VetVisitCache, String, QQueryOperations> vetVisitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vetVisitId');
    });
  }

  QueryBuilder<VetVisitCache, DateTime, QQueryOperations> visitedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visitedAt');
    });
  }
}
