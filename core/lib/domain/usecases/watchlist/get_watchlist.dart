import 'package:dartz/dartz.dart';
import '../../entities/watchlist.dart';
import '../../../utils/failure.dart';
import '../../repositories/watchlist_repository.dart';

class GetAllWatchlist {
  final WatchlistRepository _repository;

  GetAllWatchlist(this._repository);

  Future<Either<Failure, List<Watchlist>>> execute() {
    return _repository.getAllWatchlist();
  }
}
