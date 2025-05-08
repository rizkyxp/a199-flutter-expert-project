import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:ditonton/presentation/blocs/tv/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetTopRatedTv,
])
void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(getTopRatedTv: mockGetTopRatedTv);
  });

  test('initial state should be empty', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(testTvList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'Should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Left(ServerFailure('server failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvError('server failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
    },
  );
}
