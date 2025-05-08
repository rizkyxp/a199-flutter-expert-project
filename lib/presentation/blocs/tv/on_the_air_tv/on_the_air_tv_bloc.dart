import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_the_air_tv_event.dart';
part 'on_the_air_tv_state.dart';

class OnTheAirTvBloc extends Bloc<OnTheAirTvEvent, OnTheAirTvState> {
  final GetOnTheAirTv getOnTheAirTv;
  OnTheAirTvBloc({required this.getOnTheAirTv}) : super(OnTheAirTvEmpty()) {
    on<FetchOnTheAirTv>(_fetchOnTheAirTv);
  }

  Future<void> _fetchOnTheAirTv(FetchOnTheAirTv event, Emitter<OnTheAirTvState> emit) async {
    emit(OnTheAirTvLoading());

    final result = await getOnTheAirTv.execute();

    result.fold(
      (failure) {
        emit(OnTheAirTvError(failure.message));
      },
      (tv) {
        emit(OnTheAirTvLoaded(tv));
      },
    );
  }
}
