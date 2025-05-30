import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc({required this.getNowPlayingMovies}) : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>(_fetchNowPlayingMovies);
  }

  Future<void> _fetchNowPlayingMovies(FetchNowPlayingMovies event, Emitter<NowPlayingMoviesState> emit) async {
    emit(NowPlayingMoviesLoading());

    final result = await getNowPlayingMovies.execute();

    result.fold(
      (failure) {
        emit(NowPlayingMoviesError(failure.message));
      },
      (movies) {
        emit(NowPlayingMoviesLoaded(movies));
      },
    );
  }
}
