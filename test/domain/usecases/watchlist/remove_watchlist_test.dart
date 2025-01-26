import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/watchlist/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = RemoveWatchlist(mockWatchlistRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockWatchlistRepository.removeWatchlist(testWatchlist))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testWatchlist);
    // assert
    verify(mockWatchlistRepository.removeWatchlist(testWatchlist));
    expect(result, Right('Removed from watchlist'));
  });
}
