import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies searchMovies;
  SearchMovieBloc({required this.searchMovies}) : super(SearchMovieEmpty()) {
    on<FetchSearchMovie>(_fetchMovieSearch);
  }

  Future<void> _fetchMovieSearch(FetchSearchMovie event, Emitter<SearchMovieState> emit) async {
    emit(SearchMovieLoading());

    final result = await searchMovies.execute(event.query);

    result.fold(
      (failure) {
        emit(SearchMovieError(failure.message));
      },
      (movies) {
        emit(SearchMovieLoaded(movies));
      },
    );
  }
}
