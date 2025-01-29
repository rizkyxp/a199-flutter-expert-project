import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/watchlist/get_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetAllWatchlist usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = GetAllWatchlist(mockWatchlistRepository);
  });

  test('should get list of watchlist from the repository', () async {
    // arrange
    when(mockWatchlistRepository.getAllWatchlist())
        .thenAnswer((_) async => Right(testWatchlistList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testWatchlistList));
  });
}
