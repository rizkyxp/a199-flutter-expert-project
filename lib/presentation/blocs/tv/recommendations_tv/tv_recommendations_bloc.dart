import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_recommendations_event.dart';
part 'tv_recommendations_state.dart';

class TvRecommendationsBloc extends Bloc<TvRecommendationsEvent, TvRecommendationsState> {
  final GetTvRecommendation getTvRecommendation;
  TvRecommendationsBloc({required this.getTvRecommendation}) : super(TvRecommendationsEmpty()) {
    on<FetchTvRecommendations>(_fetchTvRecommendations);
  }
  Future<void> _fetchTvRecommendations(FetchTvRecommendations event, Emitter<TvRecommendationsState> emit) async {
    emit(TvRecommendationsLoading());

    final result = await getTvRecommendation.execute(event.id);

    result.fold(
      (failure) {
        emit(TvRecommendationsError(failure.message));
      },
      (recommendations) {
        emit(TvRecommendationsLoaded(recommendations));
      },
    );
  }
}
