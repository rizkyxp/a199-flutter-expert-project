part of 'now_playing_movies_bloc.dart';

sealed class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

final class NowPlayingMoviesEmpty extends NowPlayingMoviesState {}

final class NowPlayingMoviesLoading extends NowPlayingMoviesState {}

final class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  const NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

final class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> movies;

  const NowPlayingMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}
