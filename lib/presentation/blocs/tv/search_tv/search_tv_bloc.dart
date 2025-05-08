import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTv searchTv;
  SearchTvBloc({required this.searchTv}) : super(SearchTvEmpty()) {
    on<FetchSearchTv>(_fetchSearchTv);
  }

  Future<void> _fetchSearchTv(FetchSearchTv event, Emitter<SearchTvState> emit) async {
    emit(SearchTvLoading());

    final result = await searchTv.execute(event.query);

    result.fold(
      (failure) {
        emit(SearchTvError(failure.message));
      },
      (tv) {
        emit(SearchTvLoaded(tv));
      },
    );
  }
}
