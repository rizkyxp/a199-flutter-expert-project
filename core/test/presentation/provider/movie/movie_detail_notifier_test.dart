import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/usecases/watchlist/get_watchlist_status.dart';
import 'package:core/domain/usecases/watchlist/remove_watchlist.dart';
import 'package:core/domain/usecases/watchlist/save_watchlist.dart';
import 'package:core/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchlistStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailNotifier provider;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchlistStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchlistStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    provider = MovieDetailNotifier(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchlistStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  void arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      arrangeUsecase();
      // act
      provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.loaded);
      expect(provider.movie, testMovieDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.loaded);
      expect(provider.movieRecommendations, tMovies);
    });
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieRecommendations.execute(tId));
      expect(provider.movieRecommendations, tMovies);
    });

    test('should update recommendation state when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.loaded);
      expect(provider.movieRecommendations, tMovies);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      arrangeUsecase();
      when(mockSaveWatchlist.execute(testWatchlist)).thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testWatchlist.id)).thenAnswer((_) async => true);
      // act
      await provider.fetchMovieDetail(tId);
      await provider.addWatchlist(testWatchlist);
      // assert
      verify(mockSaveWatchlist.execute(testWatchlist));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      arrangeUsecase();
      when(mockRemoveWatchlist.execute(testWatchlist)).thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testWatchlist.id)).thenAnswer((_) async => false);
      // act
      await provider.fetchMovieDetail(tId);
      await provider.removeFromWatchlist(testWatchlist);
      // assert
      verify(mockRemoveWatchlist.execute(testWatchlist));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      arrangeUsecase();
      when(mockSaveWatchlist.execute(testWatchlist)).thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testWatchlist.id)).thenAnswer((_) async => true);
      // act
      await provider.fetchMovieDetail(tId);
      await provider.addWatchlist(testWatchlist);
      // assert
      verify(mockGetWatchlistStatus.execute(testWatchlist.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 4);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      arrangeUsecase();
      when(mockSaveWatchlist.execute(testWatchlist)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testWatchlist.id)).thenAnswer((_) async => false);
      // act
      await provider.fetchMovieDetail(tId);
      await provider.addWatchlist(testWatchlist);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 4);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(tMovies));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
