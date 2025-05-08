import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  TvDetailBloc({required this.getTvDetail}) : super(TvDetailEmpty()) {
    on<FetchTvDetail>(_fetchTvDetail);
  }
  Future<void> _fetchTvDetail(FetchTvDetail event, Emitter<TvDetailState> emit) async {
    emit(TvDetailLoading());

    final detailResult = await getTvDetail.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(TvDetailError(failure.message));
      },
      (tvDetail) {
        emit(TvDetailLoaded(tvDetail));
      },
    );
  }
}
