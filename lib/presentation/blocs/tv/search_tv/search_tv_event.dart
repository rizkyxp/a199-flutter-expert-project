part of 'search_tv_bloc.dart';

sealed class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchTv extends SearchTvEvent {
  final String query;

  const FetchSearchTv(this.query);

  @override
  List<Object> get props => [];
}
