import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/get_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlist/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetAllWatchlist getAllWatchlist;

  WatchlistBloc(
      {required this.getAllWatchlist,
      required this.getWatchlistStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(WatchlistEmpty()) {
    on<LoadWatchlistStatus>(_loadWatchlistStatus);
    on<AddWatchlist>(_addWatchlist);
    on<RemoveFromWatchlist>(_removeFromWatchlist);
    on<FetchWatchlist>(_fetchWatclist);
  }

  Future<void> _fetchWatclist(FetchWatchlist event, Emitter<WatchlistState> emit) async {
    emit(WatchlistLoading());
    final result = await getAllWatchlist.execute();
    result.fold(
      (failure) {
        emit(WatchlistError(failure.message));
      },
      (watchlist) {
        emit(WatchlistLoaded(watchlist));
      },
    );
  }

  Future<void> _loadWatchlistStatus(LoadWatchlistStatus event, Emitter<WatchlistState> emit) async {
    final result = await getWatchlistStatus.execute(event.id);
    emit(WatchlistState(isAddedtoWatchlist: result));
  }

  Future<void> _addWatchlist(AddWatchlist event, Emitter<WatchlistState> emit) async {
    String message = '';
    final result = await saveWatchlist.execute(event.watchlist);

    await result.fold(
      (failure) async {
        message = failure.message;
      },
      (success) {
        message = success;
      },
    );

    final status = await getWatchlistStatus.execute(event.id);

    emit(WatchlistState(isAddedtoWatchlist: status, watchlistMessage: message));
  }

  Future<void> _removeFromWatchlist(RemoveFromWatchlist event, Emitter<WatchlistState> emit) async {
    String message = '';
    final result = await removeWatchlist.execute(event.watchlist);

    await result.fold(
      (failure) async {
        message = failure.message;
      },
      (success) {
        message = success;
      },
    );

    final status = await getWatchlistStatus.execute(event.id);

    emit(WatchlistState(isAddedtoWatchlist: status, watchlistMessage: message));
  }
}
