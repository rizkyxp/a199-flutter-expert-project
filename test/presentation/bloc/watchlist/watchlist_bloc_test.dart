import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/get_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlist/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/save_watchlist.dart';
import 'package:ditonton/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistStatus,
  SaveWatchlist,
  RemoveWatchlist,
  GetAllWatchlist,
])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetAllWatchlist mockGetAllWatchlist;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetAllWatchlist = MockGetAllWatchlist();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistBloc = WatchlistBloc(
        getAllWatchlist: mockGetAllWatchlist,
        getWatchlistStatus: mockGetWatchlistStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist);
  });

  final tWatchlistModel = Watchlist(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
    category: 'category',
  );

  final tWatchlistList = <Watchlist>[tWatchlistModel];

  final tId = 1;

  test('initial state should be empty', () {
    expect(watchlistBloc.state, WatchlistEmpty());
  });

  blocTest(
    'Should emit [Loading, Loaded] when fetch all watchlist successfully',
    build: () {
      when(mockGetAllWatchlist.execute()).thenAnswer((_) async => Right(tWatchlistList));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlist()),
    expect: () => [
      WatchlistLoading(),
      WatchlistLoaded(tWatchlistList),
    ],
    verify: (bloc) {
      verify(mockGetAllWatchlist.execute());
    },
  );

  blocTest(
    'Should emit [Loading, Error] when fetch all watchlist unsuccessfully',
    build: () {
      when(mockGetAllWatchlist.execute()).thenAnswer((_) async => Left(ServerFailure('failed')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlist()),
    expect: () => [
      WatchlistLoading(),
      WatchlistError('failed'),
    ],
    verify: (bloc) {
      verify(mockGetAllWatchlist.execute());
    },
  );

  blocTest(
    'Should return watchlist status when fetch watchlist status',
    build: () {
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
    expect: () => [
      WatchlistState(isAddedtoWatchlist: true),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistStatus.execute(tId));
    },
  );

  blocTest(
    'Should return message "success" and status "true" when add to watchlist is successfully',
    build: () {
      when(mockSaveWatchlist.execute(tWatchlistModel)).thenAnswer((_) async => Right('success'));
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(AddWatchlist(tWatchlistModel, tId)),
    expect: () => [
      WatchlistState(isAddedtoWatchlist: true, watchlistMessage: 'success'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(tWatchlistModel));
      verify(mockGetWatchlistStatus.execute(tId));
    },
  );

  blocTest(
    'Should return message "success" and status "false" when remove from watchlist is successfully',
    build: () {
      when(mockRemoveWatchlist.execute(tWatchlistModel)).thenAnswer((_) async => Right('success'));
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(tWatchlistModel, tId)),
    expect: () => [
      WatchlistState(isAddedtoWatchlist: false, watchlistMessage: 'success'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(tWatchlistModel));
      verify(mockGetWatchlistStatus.execute(tId));
    },
  );
}
