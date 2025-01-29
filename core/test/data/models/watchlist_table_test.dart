import 'package:core/data/models/watchlist_table.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tWatchlistTable = WatchlistTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    category: 'tv',
  );

  final tWatchlist = Watchlist(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
    category: 'tv',
  );

  test('should be a subclass of Watchlist entity', () async {
    final result = tWatchlistTable.toEntity();
    expect(result, tWatchlist);
  });
}
