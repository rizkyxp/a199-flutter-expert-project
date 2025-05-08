part of 'watchlist_bloc.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class AddWatchlist extends WatchlistEvent {
  final int id;
  final Watchlist watchlist;

  const AddWatchlist(this.watchlist, this.id);

  @override
  List<Object> get props => [watchlist];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final int id;
  final Watchlist watchlist;

  const RemoveFromWatchlist(this.watchlist, this.id);

  @override
  List<Object> get props => [watchlist];
}

class LoadWatchlistStatus extends WatchlistEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class FetchWatchlist extends WatchlistEvent {}
