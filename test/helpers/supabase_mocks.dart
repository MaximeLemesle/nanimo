import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSession extends Mock implements Session {}

class MockUser extends Mock implements User {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockSupabaseStorageClient extends Mock
    implements SupabaseStorageClient {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

/// Wires `supabase.storage.from(bucket)` to a mock [StorageFileApi] and returns
/// it so tests can stub `upload` / `createSignedUrl`.
MockStorageFileApi stubStorageBucket(
  MockSupabaseClient supabase,
  String bucket,
) {
  final storage = MockSupabaseStorageClient();
  final fileApi = MockStorageFileApi();
  when(() => supabase.storage).thenReturn(storage);
  when(() => storage.from(bucket)).thenReturn(fileApi);
  return fileApi;
}

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

  // `.update(...).eq(...).select()` returns the affected rows. Delegate to a
  // [FakeSelectChain] so the resolver's value is cast to a typed row list,
  // matching the real `PostgrestList` the repository awaits.
  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([
    String columns = '*',
  ]) =>
      FakeSelectChain(_resolver);
}

/// Typed stand-in for a `.select()` chain. Unlike [FakePostgrestChain], it
/// implements the concrete `PostgrestFilterBuilder<List<Map<String, dynamic>>>`
/// that `select()` declares, so the implicit cast at the call site succeeds.
/// `eq`/`order` stay on the same fake, and awaiting runs [_resolver].
class FakeSelectChain extends Fake
    implements
        PostgrestFilterBuilder<List<Map<String, dynamic>>>,
        PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  FakeSelectChain(this._resolver);

  final FutureOr<dynamic> Function() _resolver;

  Future<List<Map<String, dynamic>>> _future() async {
    final value = await Future.sync(_resolver);
    return (value as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<S> then<S>(
    FutureOr<S> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) =>
      _future().then(onValue, onError: onError);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> eq(
    String column,
    Object value,
  ) =>
      this;

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> order(
    String column, {
    bool ascending = false,
    bool nullsFirst = false,
    String? referencedTable,
  }) =>
      this;

  @override
  PostgrestTransformBuilder<Map<String, dynamic>> single() =>
      FakeSingleChain(_resolver);
}

/// Terminal `.single()` stand-in: awaiting it resolves [_resolver] and casts
/// the value to a single row.
class FakeSingleChain extends Fake
    implements PostgrestTransformBuilder<Map<String, dynamic>> {
  FakeSingleChain(this._resolver);

  final FutureOr<dynamic> Function() _resolver;

  Future<Map<String, dynamic>> _future() async {
    final value = await Future.sync(_resolver);
    return (value as Map).cast<String, dynamic>();
  }

  @override
  Future<S> then<S>(
    FutureOr<S> Function(Map<String, dynamic>) onValue, {
    Function? onError,
  }) =>
      _future().then(onValue, onError: onError);
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
  when(() => qb.upsert(
        any(),
        onConflict: any(named: 'onConflict'),
        ignoreDuplicates: any(named: 'ignoreDuplicates'),
      )).thenAnswer((_) => chain as dynamic);
  return chain;
}

/// Stubs `supabase.storage.from(bucket).remove(...)`, returning `resolver()`'s
/// result on success or letting it throw to drive the error path.
MockStorageFileApi stubStorageRemove(
  MockSupabaseClient supabase,
  String bucket, {
  required FutureOr<void> Function() resolver,
}) {
  final storageClient = MockSupabaseStorageClient();
  final fileApi = MockStorageFileApi();
  when(() => supabase.storage).thenReturn(storageClient);
  when(() => storageClient.from(bucket)).thenReturn(fileApi);
  when(() => fileApi.remove(any())).thenAnswer((_) async {
    await Future.sync(resolver);
    return <FileObject>[];
  });
  return fileApi;
}

FakeSelectChain stubSelect(
  MockSupabaseClient supabase,
  String table, {
  required FutureOr<dynamic> Function() resolver,
}) {
  final qb = MockSupabaseQueryBuilder();
  final chain = FakeSelectChain(resolver);
  when(() => supabase.from(table)).thenAnswer((_) => qb);
  when(() => qb.select(any())).thenAnswer((_) => chain);
  return chain;
}

/// `registerFallbacks()` must run once before any `any()` matcher is used on
/// non-nullable custom types. Call from `setUpAll` in each test file.
void registerSupabaseFallbacks() {
  registerFallbackValue(<String, dynamic>{});
  registerFallbackValue(<String>[]);
}
