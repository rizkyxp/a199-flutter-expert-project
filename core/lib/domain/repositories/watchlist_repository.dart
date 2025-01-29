import 'package:dartz/dartz.dart';
import '../../utils/failure.dart';
import '../entities/watchlist.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, String>> saveWatchlist(Watchlist watchlist);
  Future<Either<Failure, String>> removeWatchlist(Watchlist watchlist);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Watchlist>>> getAllWatchlist();
}
