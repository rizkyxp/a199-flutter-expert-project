import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc({required this.getMovieDetail}) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>(_fetchMovieDetail);
  }

  Future<void> _fetchMovieDetail(FetchMovieDetail event, Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());

    final detailResult = await getMovieDetail.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(MovieDetailError(failure.message));
      },
      (movieDetail) {
        emit(MovieDetailLoaded(movieDetail));
      },
    );
  }
}
