part of 'search_movie_bloc.dart';

sealed class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchMovie extends SearchMovieEvent {
  final String query;

  const FetchSearchMovie(this.query);

  @override
  List<Object> get props => [query];
}
