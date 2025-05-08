import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/get_watchlist.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {
  List<Watchlist> _watchlist = <Watchlist>[];
  List<Watchlist> get watchlist => _watchlist;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier({required this.getAllWatchlist});

  final GetAllWatchlist getAllWatchlist;

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getAllWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.loaded;
        _watchlist = moviesData;
        notifyListeners();
      },
    );
  }
}
