import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:ditonton/presentation/blocs/tv/recommendations_tv/tv_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_recommendations_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvRecommendation,
])
void main() {
  late TvRecommendationsBloc tvRecommendationsBloc;
  late MockGetTvRecommendation mockGetTvRecommendation;

  setUp(() {
    mockGetTvRecommendation = MockGetTvRecommendation();
    tvRecommendationsBloc = TvRecommendationsBloc(getTvRecommendation: mockGetTvRecommendation);
  });

  final tId = 1;

  test('initial state should be empty', () {
    expect(tvRecommendationsBloc.state, TvRecommendationsEmpty());
  });

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendation.execute(tId)).thenAnswer((_) async => Right(testTvList));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendations(tId)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendation.execute(tId));
    },
  );

  blocTest<TvRecommendationsBloc, TvRecommendationsState>(
    'Should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetTvRecommendation.execute(tId)).thenAnswer((_) async => Left(ServerFailure('server failure')));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendations(tId)),
    expect: () => [
      TvRecommendationsLoading(),
      TvRecommendationsError('server failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendation.execute(tId));
    },
  );
}
