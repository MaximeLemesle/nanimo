import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSession extends Mock implements Session {}

class MockUser extends Mock implements User {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

/// Awaitable stand-in for any Postgrest chain. All chain methods return `this`
/// so an arbitrarily deep `.eq(...).single()` call still resolves to the same
/// terminal `Future` configured at construction. Awaiting the chain executes
/// [_resolver], which can return a value or throw to drive happy/error paths.
///
/// The fake claims `dynamic` for its generic so it can be slotted into chains
/// of any declared shape (e.g. `PostgrestFilterBuilder<PostgrestList>`) via the
/// untyped helpers below.
class FakePostgrestChain extends Fake
    implements
        PostgrestFilterBuilder<dynamic>,
        PostgrestTransformBuilder<dynamic>,
        PostgrestBuilder<dynamic, dynamic, dynamic> {
  FakePostgrestChain(this._resolver);

  final FutureOr<dynamic> Function() _resolver;

  Future<dynamic> _future() => Future.sync(_resolver);

  @override
  Future<S> then<S>(
    FutureOr<S> Function(dynamic) onValue, {
    Function? onError,
  }) =>
      _future().then(onValue, onError: onError);

  @override
  Stream<dynamic> asStream() => _future().asStream();

  @override
  Future<dynamic> catchError(Function onError, {bool Function(Object)? test}) =>
      _future().catchError(onError, test: test);

  @override
  Future<dynamic> whenComplete(FutureOr<void> Function() action) =>
      _future().whenComplete(action);

  @override
  Future<dynamic> timeout(
    Duration timeLimit, {
    FutureOr<dynamic> Function()? onTimeout,
  }) =>
      _future().timeout(timeLimit, onTimeout: onTimeout);

  // Chain helpers — stay on the same fake.

  @override
  PostgrestFilterBuilder<dynamic> eq(String column, Object value) => this;

  @override
  PostgrestTransformBuilder<Map<String, dynamic>> single() =>
      this as PostgrestTransformBuilder<Map<String, dynamic>>;
}

FakePostgrestChain stubInsert(
  MockSupabaseClient supabase,
  String table, {
  required FutureOr<dynamic> Function() resolver,
}) {
  final qb = MockSupabaseQueryBuilder();
  final chain = FakePostgrestChain(resolver);
  when(() => supabase.from(table)).thenAnswer((_) => qb);
  when(() => qb.insert(any())).thenAnswer((_) => chain as dynamic);
  return chain;
}

FakePostgrestChain stubUpdate(
  MockSupabaseClient supabase,
  String table, {
  required FutureOr<dynamic> Function() resolver,
}) {
  final qb = MockSupabaseQueryBuilder();
  final chain = FakePostgrestChain(resolver);
  when(() => supabase.from(table)).thenAnswer((_) => qb);
  when(() => qb.update(any())).thenAnswer((_) => chain as dynamic);
  return chain;
}

FakePostgrestChain stubDelete(
  MockSupabaseClient supabase,
  String table, {
  required FutureOr<dynamic> Function() resolver,
}) {
  final qb = MockSupabaseQueryBuilder();
  final chain = FakePostgrestChain(resolver);
  when(() => supabase.from(table)).thenAnswer((_) => qb);
  when(() => qb.delete()).thenAnswer((_) => chain as dynamic);
  return chain;
}

FakePostgrestChain stubUpsert(
  MockSupabaseClient supabase,
  String table, {
  required FutureOr<dynamic> Function() resolver,
}) {
  final qb = MockSupabaseQueryBuilder();
  final chain = FakePostgrestChain(resolver);
  when(() => supabase.from(table)).thenAnswer((_) => qb);
  when(() => qb.upsert(any(), onConflict: any(named: 'onConflict')))
      .thenAnswer((_) => chain as dynamic);
  return chain;
}

FakePostgrestChain stubSelect(
  MockSupabaseClient supabase,
  String table, {
  required FutureOr<dynamic> Function() resolver,
}) {
  final qb = MockSupabaseQueryBuilder();
  final chain = FakePostgrestChain(resolver);
  when(() => supabase.from(table)).thenAnswer((_) => qb);
  when(() => qb.select(any())).thenAnswer((_) => chain as dynamic);
  return chain;
}

/// `registerFallbacks()` must run once before any `any()` matcher is used on
/// non-nullable custom types. Call from `setUpAll` in each test file.
void registerSupabaseFallbacks() {
  registerFallbackValue(<String, dynamic>{});
  registerFallbackValue(<String>[]);
}
