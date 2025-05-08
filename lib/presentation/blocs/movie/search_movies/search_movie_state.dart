part of 'search_movie_bloc.dart';

sealed class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

final class SearchMovieEmpty extends SearchMovieState {}

final class SearchMovieLoading extends SearchMovieState {}

final class SearchMovieError extends SearchMovieState {
  final String message;

  const SearchMovieError(this.message);

  @override
  List<Object> get props => [message];
}

final class SearchMovieLoaded extends SearchMovieState {
  final List<Movie> movies;

  const SearchMovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}
