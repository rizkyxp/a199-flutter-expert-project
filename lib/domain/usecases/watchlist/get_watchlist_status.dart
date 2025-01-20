import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class GetWatchlistStatus {
  final WatchlistRepository repository;

  GetWatchlistStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
