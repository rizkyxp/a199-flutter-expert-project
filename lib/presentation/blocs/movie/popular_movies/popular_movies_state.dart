part of 'popular_movies_bloc.dart';

sealed class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

final class PopularMoviesEmpty extends PopularMoviesState {}

final class PopularMoviesLoading extends PopularMoviesState {}

final class PopularMoviesError extends PopularMoviesState {
  final String message;

  const PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

final class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> movies;

  const PopularMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}
