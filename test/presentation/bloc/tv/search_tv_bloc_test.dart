import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/blocs/tv/search_tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([
  SearchTv,
])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(searchTv: mockSearchTv);
  });

  final tQuery = 'Breaking Bad';

  test('initial state should be empty', () {
    expect(searchTvBloc.state, SearchTvEmpty());
  });

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchTv.execute(tQuery)).thenAnswer((_) async => Right(testTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(FetchSearchTv(tQuery)),
    expect: () => [
      SearchTvLoading(),
      SearchTvLoaded(testTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockSearchTv.execute(tQuery)).thenAnswer((_) async => Left(ServerFailure('server failure')));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(FetchSearchTv(tQuery)),
    expect: () => [
      SearchTvLoading(),
      SearchTvError('server failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );
}
