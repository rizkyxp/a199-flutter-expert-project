part of 'watchlist_bloc.dart';

class WatchlistState extends Equatable {
  final bool isAddedtoWatchlist;
  final String watchlistMessage;
  const WatchlistState({this.isAddedtoWatchlist = false, this.watchlistMessage = ''});

  @override
  List<Object> get props => [isAddedtoWatchlist, watchlistMessage];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistLoaded extends WatchlistState {
  final List<Watchlist> watchlist;

  const WatchlistLoaded(this.watchlist);

  @override
  List<Object> get props => [watchlist];
}
