import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_empty_state_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_timeline_widget.dart';

class _FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  _FakeAuthCubit() : super(const AuthState.authenticated());

  int resyncCount = 0;

  @override
  Future<void> resync() async => resyncCount++;

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _StubJournalCubit extends Cubit<JournalState> implements JournalCubit {
  _StubJournalCubit(super.state);

  @override
  Future<String> imageUrl(String assetPath) async => 'https://x/$assetPath';

  @override
  void noSuchMethod(Invocation invocation) {}
}

void main() {
  final event = EventModel(
    eventId: 'e1',
    title: 'Promenade au parc',
    entryDate: DateTime(2026, 3, 5, 11, 43),
    eventTypeId: 't1',
  );

  Widget wrap(JournalState state, _FakeAuthCubit auth) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<JournalCubit>.value(value: _StubJournalCubit(state)),
        ],
        child: Scaffold(body: JournalTimelineWidget(state: state)),
      ),
    );
  }

  testWidgets('renders the empty state with a pull-to-refresh', (tester) async {
    final auth = _FakeAuthCubit();
    await tester.pumpWidget(wrap(const JournalState(), auth));

    expect(find.text(JournalEmptyStateWidget.message), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('renders events and resyncs on pull-to-refresh', (tester) async {
    final auth = _FakeAuthCubit();
    final state = JournalState(status: JournalStatus.loaded, events: [event]);
    await tester.pumpWidget(wrap(state, auth));

    expect(find.text('Promenade au parc'), findsOneWidget);

    await tester.fling(
      find.byType(ListView),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(auth.resyncCount, greaterThan(0));
  });
}
