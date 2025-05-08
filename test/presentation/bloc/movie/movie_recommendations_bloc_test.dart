import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/blocs/movie/recommendations_movies/movie_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieRecommendations,
])
void main() {
  late MovieRecommendationsBloc movieRecommendationsBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(getMovieRecommendations: mockGetMovieRecommendations);
  });

  final tId = 1;

  test('initial state should be empty', () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchMovieRecommendations(tId)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'Should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure('server failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchMovieRecommendations(tId)),
    expect: () => [
      MovieRecommendationsLoading(),
      MovieRecommendationsError('server failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );
}
