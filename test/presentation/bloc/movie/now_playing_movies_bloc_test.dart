import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/presentation/blocs/movie/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
])
void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
  });

  test('initial state should be empty', () {
    expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(testMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'Should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Left(ServerFailure('server failure')));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [
      NowPlayingMoviesLoading(),
      NowPlayingMoviesError('server failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );
}
