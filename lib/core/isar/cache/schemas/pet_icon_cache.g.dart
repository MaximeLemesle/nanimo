// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_icon_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPetIconCacheCollection on Isar {
  IsarCollection<PetIconCache> get petIconCaches => this.collection();
}

const PetIconCacheSchema = CollectionSchema(
  name: r'PetIconCache',
  id: -1815155019234384744,
  properties: {
    r'assetPath': PropertySchema(
      id: 0,
      name: r'assetPath',
      type: IsarType.string,
    ),
    r'isPremium': PropertySchema(
      id: 1,
      name: r'isPremium',
      type: IsarType.bool,
    ),
    r'petIconId': PropertySchema(
      id: 2,
      name: r'petIconId',
      type: IsarType.string,
    ),
    r'petIconName': PropertySchema(
      id: 3,
      name: r'petIconName',
      type: IsarType.string,
    ),
    r'petRaceId': PropertySchema(
      id: 4,
      name: r'petRaceId',
      type: IsarType.string,
    ),
    r'petSpeciesId': PropertySchema(
      id: 5,
      name: r'petSpeciesId',
      type: IsarType.string,
    )
  },
  estimateSize: _petIconCacheEstimateSize,
  serialize: _petIconCacheSerialize,
  deserialize: _petIconCacheDeserialize,
  deserializeProp: _petIconCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'petIconId': IndexSchema(
      id: -6913113645814521335,
      name: r'petIconId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petIconId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'petSpeciesId': IndexSchema(
      id: 6831563341087857817,
      name: r'petSpeciesId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petSpeciesId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'petRaceId': IndexSchema(
      id: 7746922278487465235,
      name: r'petRaceId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petRaceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _petIconCacheGetId,
  getLinks: _petIconCacheGetLinks,
  attach: _petIconCacheAttach,
  version: '3.1.0+1',
);

int _petIconCacheEstimateSize(
  PetIconCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetPath.length * 3;
  bytesCount += 3 + object.petIconId.length * 3;
  bytesCount += 3 + object.petIconName.length * 3;
  {
    final value = object.petRaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.petSpeciesId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _petIconCacheSerialize(
  PetIconCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetPath);
  writer.writeBool(offsets[1], object.isPremium);
  writer.writeString(offsets[2], object.petIconId);
  writer.writeString(offsets[3], object.petIconName);
  writer.writeString(offsets[4], object.petRaceId);
  writer.writeString(offsets[5], object.petSpeciesId);
}

PetIconCache _petIconCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PetIconCache();
  object.assetPath = reader.readString(offsets[0]);
  object.id = id;
  object.isPremium = reader.readBool(offsets[1]);
  object.petIconId = reader.readString(offsets[2]);
  object.petIconName = reader.readString(offsets[3]);
  object.petRaceId = reader.readStringOrNull(offsets[4]);
  object.petSpeciesId = reader.readStringOrNull(offsets[5]);
  return object;
}

P _petIconCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _petIconCacheGetId(PetIconCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _petIconCacheGetLinks(PetIconCache object) {
  return [];
}

void _petIconCacheAttach(
    IsarCollection<dynamic> col, Id id, PetIconCache object) {
  object.id = id;
}

extension PetIconCacheByIndex on IsarCollection<PetIconCache> {
  Future<PetIconCache?> getByPetIconId(String petIconId) {
    return getByIndex(r'petIconId', [petIconId]);
  }

  PetIconCache? getByPetIconIdSync(String petIconId) {
    return getByIndexSync(r'petIconId', [petIconId]);
  }

  Future<bool> deleteByPetIconId(String petIconId) {
    return deleteByIndex(r'petIconId', [petIconId]);
  }

  bool deleteByPetIconIdSync(String petIconId) {
    return deleteByIndexSync(r'petIconId', [petIconId]);
  }

  Future<List<PetIconCache?>> getAllByPetIconId(List<String> petIconIdValues) {
    final values = petIconIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'petIconId', values);
  }

  List<PetIconCache?> getAllByPetIconIdSync(List<String> petIconIdValues) {
    final values = petIconIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'petIconId', values);
  }

  Future<int> deleteAllByPetIconId(List<String> petIconIdValues) {
    final values = petIconIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'petIconId', values);
  }

  int deleteAllByPetIconIdSync(List<String> petIconIdValues) {
    final values = petIconIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'petIconId', values);
  }

  Future<Id> putByPetIconId(PetIconCache object) {
    return putByIndex(r'petIconId', object);
  }

  Id putByPetIconIdSync(PetIconCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'petIconId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPetIconId(List<PetIconCache> objects) {
    return putAllByIndex(r'petIconId', objects);
  }

  List<Id> putAllByPetIconIdSync(List<PetIconCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'petIconId', objects, saveLinks: saveLinks);
  }
}

extension PetIconCacheQueryWhereSort
    on QueryBuilder<PetIconCache, PetIconCache, QWhere> {
  QueryBuilder<PetIconCache, PetIconCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PetIconCacheQueryWhere
    on QueryBuilder<PetIconCache, PetIconCache, QWhereClause> {
  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> petIconIdEqualTo(
      String petIconId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petIconId',
        value: [petIconId],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petIconIdNotEqualTo(String petIconId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petIconId',
              lower: [],
              upper: [petIconId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petIconId',
              lower: [petIconId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petIconId',
              lower: [petIconId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petIconId',
              lower: [],
              upper: [petIconId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petSpeciesIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petSpeciesId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petSpeciesIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'petSpeciesId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petSpeciesIdEqualTo(String? petSpeciesId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petSpeciesId',
        value: [petSpeciesId],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petSpeciesIdNotEqualTo(String? petSpeciesId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [],
              upper: [petSpeciesId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [petSpeciesId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [petSpeciesId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petSpeciesId',
              lower: [],
              upper: [petSpeciesId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petRaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petRaceId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petRaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'petRaceId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause> petRaceIdEqualTo(
      String? petRaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petRaceId',
        value: [petRaceId],
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterWhereClause>
      petRaceIdNotEqualTo(String? petRaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petRaceId',
              lower: [],
              upper: [petRaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petRaceId',
              lower: [petRaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petRaceId',
              lower: [petRaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petRaceId',
              lower: [],
              upper: [petRaceId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PetIconCacheQueryFilter
    on QueryBuilder<PetIconCache, PetIconCache, QFilterCondition> {
  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      assetPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      assetPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      assetPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      assetPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetPath',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      isPremiumEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPremium',
        value: value,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petIconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petIconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petIconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petIconId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petIconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petIconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petIconId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petIconId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petIconId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petIconId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petIconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petIconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petIconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petIconName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petIconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petIconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petIconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petIconName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petIconName',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petIconNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petIconName',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'petRaceId',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'petRaceId',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petRaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petRaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petRaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petRaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petRaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petRaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'petSpeciesId',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'petSpeciesId',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petSpeciesId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petSpeciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petSpeciesId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petSpeciesId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterFilterCondition>
      petSpeciesIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petSpeciesId',
        value: '',
      ));
    });
  }
}

extension PetIconCacheQueryObject
    on QueryBuilder<PetIconCache, PetIconCache, QFilterCondition> {}

extension PetIconCacheQueryLinks
    on QueryBuilder<PetIconCache, PetIconCache, QFilterCondition> {}

extension PetIconCacheQuerySortBy
    on QueryBuilder<PetIconCache, PetIconCache, QSortBy> {
  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByIsPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByIsPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByPetIconId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconId', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByPetIconIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconId', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByPetIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconName', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy>
      sortByPetIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconName', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByPetRaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByPetRaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> sortByPetSpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy>
      sortByPetSpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.desc);
    });
  }
}

extension PetIconCacheQuerySortThenBy
    on QueryBuilder<PetIconCache, PetIconCache, QSortThenBy> {
  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetPath', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByIsPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByIsPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremium', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByPetIconId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconId', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByPetIconIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconId', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByPetIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconName', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy>
      thenByPetIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petIconName', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByPetRaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByPetRaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petRaceId', Sort.desc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy> thenByPetSpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.asc);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QAfterSortBy>
      thenByPetSpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petSpeciesId', Sort.desc);
    });
  }
}

extension PetIconCacheQueryWhereDistinct
    on QueryBuilder<PetIconCache, PetIconCache, QDistinct> {
  QueryBuilder<PetIconCache, PetIconCache, QDistinct> distinctByAssetPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QDistinct> distinctByIsPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPremium');
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QDistinct> distinctByPetIconId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petIconId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QDistinct> distinctByPetIconName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petIconName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QDistinct> distinctByPetRaceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petRaceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetIconCache, PetIconCache, QDistinct> distinctByPetSpeciesId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petSpeciesId', caseSensitive: caseSensitive);
    });
  }
}

extension PetIconCacheQueryProperty
    on QueryBuilder<PetIconCache, PetIconCache, QQueryProperty> {
  QueryBuilder<PetIconCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PetIconCache, String, QQueryOperations> assetPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetPath');
    });
  }

  QueryBuilder<PetIconCache, bool, QQueryOperations> isPremiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPremium');
    });
  }

  QueryBuilder<PetIconCache, String, QQueryOperations> petIconIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petIconId');
    });
  }

  QueryBuilder<PetIconCache, String, QQueryOperations> petIconNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petIconName');
    });
  }

  QueryBuilder<PetIconCache, String?, QQueryOperations> petRaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petRaceId');
    });
  }

  QueryBuilder<PetIconCache, String?, QQueryOperations> petSpeciesIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petSpeciesId');
    });
  }
}
