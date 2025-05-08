import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv getTopRatedTv;
  TopRatedTvBloc({required this.getTopRatedTv}) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>(_fetchTopRatedTv);
  }

  Future<void> _fetchTopRatedTv(FetchTopRatedTv event, Emitter<TopRatedTvState> emit) async {
    emit(TopRatedTvLoading());

    final result = await getTopRatedTv.execute();

    result.fold(
      (failure) {
        emit(TopRatedTvError(failure.message));
      },
      (tv) {
        emit(TopRatedTvLoaded(tv));
      },
    );
  }
}
