import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import '../../entities/watchlist.dart';
import '../../repositories/watchlist_repository.dart';

class RemoveWatchlist {
  final WatchlistRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(Watchlist watchlist) {
    return repository.removeWatchlist(watchlist);
  }
}
