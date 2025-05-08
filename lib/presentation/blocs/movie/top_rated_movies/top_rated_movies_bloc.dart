import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies}) : super(TopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>(_fetchTopRatedMovies);
  }

  Future<void> _fetchTopRatedMovies(FetchTopRatedMovies event, Emitter<TopRatedMoviesState> emit) async {
    emit(TopRatedMoviesLoading());

    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) {
        emit(TopRatedMoviesError(failure.message));
      },
      (movies) {
        emit(TopRatedMoviesLoaded(movies));
      },
    );
  }
}
