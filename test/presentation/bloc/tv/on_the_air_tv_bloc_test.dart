import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv.dart';
import 'package:ditonton/presentation/blocs/tv/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'on_the_air_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTv,
])
void main() {
  late OnTheAirTvBloc onTheAirTvBloc;
  late MockGetOnTheAirTv mockGetOnTheAirTv;

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    onTheAirTvBloc = OnTheAirTvBloc(getOnTheAirTv: mockGetOnTheAirTv);
  });

  test('initial state should be empty', () {
    expect(onTheAirTvBloc.state, OnTheAirTvEmpty());
  });

  blocTest<OnTheAirTvBloc, OnTheAirTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right(testTvList));
      return onTheAirTvBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTv()),
    expect: () => [
      OnTheAirTvLoading(),
      OnTheAirTvLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
    },
  );

  blocTest<OnTheAirTvBloc, OnTheAirTvState>(
    'Should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Left(ServerFailure('server failure')));
      return onTheAirTvBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTv()),
    expect: () => [
      OnTheAirTvLoading(),
      OnTheAirTvError('server failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
    },
  );
}
